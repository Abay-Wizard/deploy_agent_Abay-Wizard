#!/bin/bash

read -p "Enter project identifier (e.g., v1): " input
input=${input:-v1}

PROJECT_DIR="attendance_tracker_${input}"

cleanup() {
    echo ""
    echo "⚠️ Interrupt detected. Archiving current state..."
    if [ -d "$PROJECT_DIR" ]; then
        tar -czf "${PROJECT_DIR}_archive.tar.gz" "$PROJECT_DIR"
        rm -rf "$PROJECT_DIR"
        echo "📦 Archive created: ${PROJECT_DIR}_archive.tar.gz"
        echo "🗑️ Incomplete directory removed."
    fi
    exit 1
}

trap cleanup SIGINT

echo "🚀 Creating directory structure..."
mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

touch "$PROJECT_DIR/attendance_checker.py"
touch "$PROJECT_DIR/Helpers/assets.csv"
touch "$PROJECT_DIR/Helpers/config.json"
touch "$PROJECT_DIR/reports/reports.log"

read -p "Do you want to update attendance thresholds? (y/n): " choice

if [[ "$choice" == "y" ]]; then
    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure

    warning=${warning:-75}
    failure=${failure:-50}

    sed -i "s/\"warning\": 75/\"warning\": $warning/" "$PROJECT_DIR/Helpers/config.json"
    sed -i "s/\"failure\": 50/\"failure\": $failure/" "$PROJECT_DIR/Helpers/config.json"

    echo "⚙️ Thresholds updated using sed."
else
    echo "Using default thresholds."
fi

echo "🔎 Performing system health check..."
if python3 --version >/dev/null 2>&1; then
    echo "✅ Python3 is installed."
else
    echo "⚠️ Warning: Python3 is NOT installed."
fi

if [ -f "$PROJECT_DIR/attendance_checker.py" ] &&
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] &&
   [ -f "$PROJECT_DIR/Helpers/config.json" ] &&
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then
    echo "✅ Directory structure verified."
else
    echo "❌ Directory validation failed."
fi

echo "🎉 Project setup complete!"
