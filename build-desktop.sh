#!/bin/sh

GODOT_DIR="./frontend-desktop/magnate"
OUTPUT_DIR="desktop-releases"
GODOT_VERSION="4.2.1"

mkdir -p "$OUTPUT_DIR"

echo "Starting Godot multi-platform compilation using Docker..."

docker run --rm \
  -v "$(pwd):/workspace" \
  -w /workspace/godot \
  barichello/godot-ci:$GODOT_VERSION \
  bash -c "
    echo '📦 Exporting Linux...' &&
    mkdir -p /workspace/desktop-releases/linux &&
    godot --headless --export-release 'Linux/X11' /workspace/${OUTPUT_DIR}/linux/mi_juego.x86_64 &&
    
    echo '📦 Exporting Windows...' &&
    mkdir -p /workspace/desktop-releases/windows &&
    godot --headless --export-release 'Windows Desktop' /workspace/${OUTPUT_DIR}/windows/mi_juego.exe &&
    
    echo '📦 Exporting MacOS...' &&
    mkdir -p /workspace/desktop-releases/macos &&
    godot --headless --export-release 'macOS' /workspace/${OUTPUT_DIR}/macos/mi_juego.zip &&
    
    echo '✅ All exports completed successfully!'
  "

echo "Binaries are ready in the $OUTPUT_DIR directory."
