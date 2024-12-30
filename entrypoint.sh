#!/bin/bash

set -e

# Eingaben auslesen
NEXTCLOUD_URL="${INPUT_NEXTCLOUD_URL}"
NEXTCLOUD_USER="${INPUT_USERNAME}"
NEXTCLOUD_PASS="${INPUT_PASSWORD}"
ZIP_BEFORE_UPLOAD="${INPUT_ZIP_BEFORE_UPLOAD:-true}"
BASE64="${INPUT_BASE64:-false}"

# Base64-Dekodierung falls aktiviert
if [ "$BASE64" == "true" ]; then
  echo "Decoding Base64 inputs..."
  NEXTCLOUD_URL=$(echo "$NEXTCLOUD_URL" | base64 -d)
  NEXTCLOUD_USER=$(echo "$NEXTCLOUD_USER" | base64 -d)
fi

# Dynamischer ZIP-Dateiname
REPO_NAME=$(basename "${GITHUB_REPOSITORY}")
COMMIT_SHORT_HASH=$(echo "${GITHUB_SHA}" | cut -c 1-7) # Kürze den Commit-Hash auf 7 Zeichen
DATE=$(date +"%Y%m%d_%H%M%S") # Format: YYYYMMDD_HHMMSS
ZIP_NAME="GitHub_${REPO_NAME}_${COMMIT_SHORT_HASH}_${DATE}.zip"

# Debugging-Ausgaben
echo "DEBUG: NEXTCLOUD_URL=${NEXTCLOUD_URL}"
echo "DEBUG: NEXTCLOUD_USER=${NEXTCLOUD_USER}"
echo "DEBUG: ZIP_NAME=${ZIP_NAME}"
echo "DEBUG: COMMIT_SHORT_HASH=${COMMIT_SHORT_HASH}"

# Temporäres Arbeitsverzeichnis erstellen
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"
cd "$TEMP_DIR"

# Git-Repository klonen und ins Verzeichnis wechseln
echo "Cloning the repository..."
mkdir -p "$TEMP_DIR/repo"
git clone "https://github.com/${GITHUB_REPOSITORY}.git" "$TEMP_DIR/repo"
cd "$TEMP_DIR/repo"

# ZIP-Datei erstellen
echo "Creating a zip of the repository..."
zip -r "$TEMP_DIR/$ZIP_NAME" .

# Überprüfen, ob die ZIP-Datei erstellt wurde
if [ ! -f "$TEMP_DIR/$ZIP_NAME" ]; then
  echo "ERROR: ZIP file was not created."
  exit 1
fi

# Datei hochladen (Überschreiben, falls sie bereits existiert)
UPLOAD_URL="${NEXTCLOUD_URL%/}/$ZIP_NAME"
curl -u "${NEXTCLOUD_USER}:${NEXTCLOUD_PASS}" -T "$TEMP_DIR/$ZIP_NAME" "$UPLOAD_URL"

# Aufräumen
echo "Cleaning up temporary directory."
rm -rf "$TEMP_DIR"

# ZIP-Name als Output zurückgeben
echo "zip-name=$ZIP_NAME" >> $GITHUB_ENV

echo "Backup completed successfully!"
