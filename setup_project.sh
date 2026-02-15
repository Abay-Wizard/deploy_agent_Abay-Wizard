#!/bin/bash

# ====================================
# setup_project.sh
# Automated Project Factory (IaC)
# ====================================

# Ask for project identifier
read -p "Enter project identifier (e.g., v1): " input
input=${input:-v1}

PROJECT_DIR="attendance_tracker_${input}"

# ----------------------------
# Trap Function (SIGINT)
# ----------------------------
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

# ----------------------------
# Create Directory Structure
# ----------------------------
echo "🚀 Creating directory structure..."

mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

# Create required files
touch "$PROJECT_DIR/attendance_checker.py"
touch "$PROJECT_DIR/Helpers/assets.csv"
touch "$PROJECT_DIR/reports/reports.log"

# Create default config.json
CONFIG_FILE="$PROJECT_DIR/Helpers/config.json"

cat <<EOF > "$CONFIG_FILE"
{
  "warning": 75,
  "failure": 50
}
EOF

echo "✅ Structure and default files created."

# ----------------------------
# Dynamic Configuration (sed)
# ----------------------------
read -p "Do you want to update attendance thresholds? (y/n): " choice

if [[ "$choice" == "y" ]]; then

    read -p "Enter Warning threshold (default 75): " warning
    read -p "Enter Failure threshold (default 50): " failure

    warning=${warning:-75}
    failure=${failure:-50}

    # In-place edit using sed
    sed -i "s/\"warning\": 75/\"warning\": $warning/" "$CONFIG_FILE"
    sed -i "s/\"failure\": 50/\"failure\": $failure/" "$CONFIG_FILE"

    echo "⚙️ Thresholds updated using sed."
else
    echo "Using default thresholds."
fi

# ----------------------------
# Health Check
# ----------------------------
echo "🔎 Performing system health check..."

if python3 --version >/dev/null 2>&1; then
    echo "✅ Python3 is installed."
else
    echo "⚠️ Warning: Python3 is NOT installed."
fi

# ----------------------------
# Structure Validation
# ----------------------------
if [ -f "$PROJECT_DIR/attendance_checker.py" ] &&
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] &&
   [ -f "$PROJECT_DIR/Helpers/config.json" ] &&
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then

    echo "✅ Directory structure verified."
else
    echo "❌ Directory validation failed."
fi

echo "🎉 Project setup complete!"

