#!/bin/sh

# Project directory relative to the workspace root
HOST_PROJECT_PATH="$(pwd)/frontend-desktop/magnate"
GODOT_PROJECT_PATH="/workspace/frontend-desktop/magnate"
OUTPUT_DIR="desktop-releases"
GODOT_VERSION="4.6"
DEPENDENCIES="libfontconfig1"

if [ -f .env ]; then
    ENV_HOST=$(grep '^BACKEND_HOST=' .env | cut -d '=' -f2- | tr -d '"' | tr -d "'")
    if [ -n "$ENV_HOST" ]; then
        SERVER_HOST="$ENV_HOST"
    else
        echo -e "ERROR: BACKEND_HOST not defined in .env"
        exit 1
    fi
fi

# TODO: Remove
CERT_SOURCE="ssl-certs/fullchain.pem"
CERT_DEST_NAME="server.crt"
if [ -f "$CERT_SOURCE" ]; then
    echo "🔐 Copying $CERT_SOURCE to project..."
    # We copy it into the project root so res:// can find it
    cp "$CERT_SOURCE" "$HOST_PROJECT_PATH/$CERT_DEST_NAME"
    # Prepare the setting for the project.godot injection
    CERT_SETTING="network/tls/certificate_bundle_override=\"res://$CERT_DEST_NAME\""
else
    echo "❌ ERROR: $CERT_SOURCE not found!"
    exit 1
fi

echo "📝 Generating config.cfg in the Godot project..."
cat <<EOF > "$HOST_PROJECT_PATH/config.cfg"
[network]
server_host="$SERVER_HOST"
ws_protocol="wss"
rest_protocol="https"
EOF

mkdir -p "$OUTPUT_DIR"

echo "Starting Godot multi-platform compilation using Docker..."

docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  barichello/godot-ci:$GODOT_VERSION \
  bash -c "
    # Install dependencies
    apt-get update && apt-get install -y ${DEPENDENCIES} &&

    # TODO: Remove
    echo '$CERT_SETTING' >> '$GODOT_PROJECT_PATH/project.godot'

    echo '📦 Exporting Linux...' &&
    mkdir -p /workspace/${OUTPUT_DIR}/linux &&
    godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'Linux' '/workspace/${OUTPUT_DIR}/linux/Magnate.x86_64' &&
    
    echo '📦 Exporting Windows...' &&
    mkdir -p /workspace/${OUTPUT_DIR}/windows &&
    godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'Windows Desktop' '/workspace/${OUTPUT_DIR}/windows/Magnate.exe' &&
    # 
    # echo '📦 Exporting MacOS...' &&
    # mkdir -p /workspace/${OUTPUT_DIR}/macos &&
    # godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'macOS' '/workspace/${OUTPUT_DIR}/macos/Magnate.zip' &&
    
    echo '✅ All exports completed successfully!'
  "

echo "Binaries are ready in the $OUTPUT_DIR directory."
