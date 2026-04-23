#!/bin/sh

# Project directory relative to the workspace root
GODOT_PROJECT_PATH="/workspace/frontend-desktop/magnate"
OUTPUT_DIR="desktop-releases"
GODOT_VERSION="4.6"
DEPENDENCIES="libfontconfig1"

mkdir -p "$OUTPUT_DIR"

echo "Starting Godot multi-platform compilation using Docker..."

docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace \
  barichello/godot-ci:$GODOT_VERSION \
  bash -c "
    # Install dependencies
    apt-get update && apt-get install -y ${DEPENDENCIES} &&

    echo '📦 Exporting Linux...' &&
    mkdir -p /workspace/${OUTPUT_DIR}/linux &&
    godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'Linux/X11' '/workspace/${OUTPUT_DIR}/linux/mi_juego.x86_64' &&
    
    echo '📦 Exporting Windows...' &&
    mkdir -p /workspace/${OUTPUT_DIR}/windows &&
    godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'Windows Desktop' '/workspace/${OUTPUT_DIR}/windows/mi_juego.exe' &&
    
    echo '📦 Exporting MacOS...' &&
    mkdir -p /workspace/${OUTPUT_DIR}/macos &&
    godot --headless --path '$GODOT_PROJECT_PATH' --export-release 'macOS' '/workspace/${OUTPUT_DIR}/macos/mi_juego.zip' &&
    
    echo '✅ All exports completed successfully!'
  "

echo "Binaries are ready in the $OUTPUT_DIR directory."
