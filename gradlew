#!/bin/sh
# Lanzador de respaldo sin gradle-wrapper.jar. Requiere curl y unzip.
set -eu
VERSION=8.13
BASE="${GRADLE_USER_HOME:-$HOME/.gradle}/vibra-bootstrap"
TARGET="$BASE/gradle-$VERSION"
GRADLE="$TARGET/gradle-$VERSION/bin/gradle"
if [ ! -x "$GRADLE" ]; then
  mkdir -p "$BASE" "$TARGET"
  ZIP="$BASE/gradle-$VERSION-bin.zip"
  if [ ! -f "$ZIP" ]; then
    curl -fL "https://services.gradle.org/distributions/gradle-$VERSION-bin.zip" -o "$ZIP"
  fi
  unzip -oq "$ZIP" -d "$TARGET"
fi
exec "$GRADLE" "$@"
