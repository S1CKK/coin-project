#!/bin/bash

# check fvm
if command -v fvm >/dev/null 2>&1; then
  echo "📦 Using FVM"
  FLUTTER="fvm flutter"
else
  echo "⚠️ FVM not found, using global flutter"
  FLUTTER="flutter"
fi

echo "📦 Getting packages..."
$FLUTTER pub get

echo "🌐 Generating localization..."
$FLUTTER gen-l10n

echo "🚀 Running app..."
$FLUTTER run