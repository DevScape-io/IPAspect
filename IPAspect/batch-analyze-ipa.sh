#!/bin/bash

#!/bin/bash
#
# batch-analyze-ipa.sh
# Batch IPA analyzer - analyzes multiple IPA files and generates a report
# Usage: ./batch-analyze-ipa.sh <directory-with-ipa-files> [output.csv]
#
# Copyright 2026 DevScape.io LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory-with-ipa-files> [output.csv]"
    echo ""
    echo "Analyzes all IPA files in the specified directory and generates a CSV report."
    exit 1
fi

IPA_DIR="$1"
OUTPUT_FILE="${2:-ipa-analysis-$(date +%Y%m%d-%H%M%S).csv}"

if [ ! -d "$IPA_DIR" ]; then
    echo -e "${RED}Error: Directory not found: $IPA_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}=== IPAspect Batch Analyzer ===${NC}"
echo -e "Scanning directory: ${GREEN}$IPA_DIR${NC}"
echo ""

# Create CSV header
echo "File Name,Bundle ID,Team Name,Team ID,Profile Type,Created,Expires,Status,Days Remaining" > "$OUTPUT_FILE"

# Find all IPA files
IPA_FILES=($(find "$IPA_DIR" -name "*.ipa" -type f))

if [ ${#IPA_FILES[@]} -eq 0 ]; then
    echo -e "${YELLOW}No IPA files found in directory${NC}"
    exit 0
fi

echo -e "Found ${GREEN}${#IPA_FILES[@]}${NC} IPA file(s)"
echo ""

ANALYZED=0
FAILED=0

for IPA_FILE in "${IPA_FILES[@]}"; do
    BASENAME=$(basename "$IPA_FILE")
    echo -n "Analyzing $BASENAME... "
    
    # Create temporary directory
    TEMP_DIR=$(mktemp -d)
    
    # Extract IPA
    if ! unzip -q "$IPA_FILE" -d "$TEMP_DIR" 2>/dev/null; then
        echo -e "${RED}✗ Failed to extract${NC}"
        rm -rf "$TEMP_DIR"
        ((FAILED++))
        continue
    fi
    
    # Find provisioning profile
    PROFILE=$(find "$TEMP_DIR" -name "*.mobileprovision" | head -n 1)
    
    if [ -z "$PROFILE" ]; then
        echo -e "${RED}✗ No profile found${NC}"
        rm -rf "$TEMP_DIR"
        ((FAILED++))
        continue
    fi
    
    # Extract plist
    PLIST_FILE="$TEMP_DIR/profile.plist"
    security cms -D -i "$PROFILE" > "$PLIST_FILE" 2>/dev/null || {
        sed -n '/<plist/,/<\/plist>/p' "$PROFILE" > "$PLIST_FILE"
    }
    
    # Parse data
    TEAM_NAME=$(/usr/libexec/PlistBuddy -c "Print :TeamName" "$PLIST_FILE" 2>/dev/null || echo "N/A")
    TEAM_ID=$(/usr/libexec/PlistBuddy -c "Print :TeamIdentifier:0" "$PLIST_FILE" 2>/dev/null || echo "N/A")
    BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:application-identifier" "$PLIST_FILE" 2>/dev/null || echo "N/A")
    BUNDLE_ID=$(echo "$BUNDLE_ID" | sed "s/^$TEAM_ID\.//")
    
    GET_TASK_ALLOW=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:get-task-allow" "$PLIST_FILE" 2>/dev/null || echo "false")
    DEVICES_COUNT=$(/usr/libexec/PlistBuddy -c "Print :ProvisionedDevices" "$PLIST_FILE" 2>/dev/null | grep -c "^    " || echo "0")
    
    if [ "$GET_TASK_ALLOW" = "true" ]; then
        PROFILE_TYPE="Development"
    elif [ "$DEVICES_COUNT" -gt 0 ]; then
        PROFILE_TYPE="Ad Hoc"
    else
        PROFILE_TYPE="App Store"
    fi
    
    CREATION_DATE=$(/usr/libexec/PlistBuddy -c "Print :CreationDate" "$PLIST_FILE" 2>/dev/null || echo "N/A")
    EXPIRATION_DATE=$(/usr/libexec/PlistBuddy -c "Print :ExpirationDate" "$PLIST_FILE" 2>/dev/null || echo "N/A")
    
    # Calculate status
    STATUS="Unknown"
    DAYS_REMAINING="N/A"
    
    if [ "$EXPIRATION_DATE" != "N/A" ]; then
        EXPIRATION_EPOCH=$(date -j -f "%a %b %d %T %Z %Y" "$EXPIRATION_DATE" +%s 2>/dev/null || echo "0")
        CURRENT_EPOCH=$(date +%s)
        
        if [ "$EXPIRATION_EPOCH" -lt "$CURRENT_EPOCH" ]; then
            STATUS="Expired"
            DAYS_REMAINING=$(( (EXPIRATION_EPOCH - CURRENT_EPOCH) / 86400 ))
        else
            DAYS_REMAINING=$(( (EXPIRATION_EPOCH - CURRENT_EPOCH) / 86400 ))
            if [ "$DAYS_REMAINING" -lt 30 ]; then
                STATUS="Expiring Soon"
            else
                STATUS="Valid"
            fi
        fi
    fi
    
    # Escape CSV values
    escape_csv() {
        local value="$1"
        if [[ "$value" == *,* ]] || [[ "$value" == *\"* ]] || [[ "$value" == *$'\n'* ]]; then
            value="${value//\"/\"\"}"
            echo "\"$value\""
        else
            echo "$value"
        fi
    }
    
    BASENAME=$(escape_csv "$BASENAME")
    BUNDLE_ID=$(escape_csv "$BUNDLE_ID")
    TEAM_NAME=$(escape_csv "$TEAM_NAME")
    TEAM_ID=$(escape_csv "$TEAM_ID")
    PROFILE_TYPE=$(escape_csv "$PROFILE_TYPE")
    
    # Write to CSV
    echo "$BASENAME,$BUNDLE_ID,$TEAM_NAME,$TEAM_ID,$PROFILE_TYPE,$CREATION_DATE,$EXPIRATION_DATE,$STATUS,$DAYS_REMAINING" >> "$OUTPUT_FILE"
    
    # Clean up
    rm -rf "$TEMP_DIR"
    
    # Status indicator
    case $STATUS in
        "Valid")
            echo -e "${GREEN}✓ $STATUS${NC}"
            ;;
        "Expiring Soon")
            echo -e "${YELLOW}⚠ $STATUS${NC}"
            ;;
        "Expired")
            echo -e "${RED}✗ $STATUS${NC}"
            ;;
        *)
            echo -e "✓ Complete"
            ;;
    esac
    
    ((ANALYZED++))
done

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "Analyzed: ${GREEN}$ANALYZED${NC}"
if [ $FAILED -gt 0 ]; then
    echo -e "Failed: ${RED}$FAILED${NC}"
fi
echo -e "Report saved: ${GREEN}$OUTPUT_FILE${NC}"
echo ""
echo "You can open the CSV in Numbers, Excel, or any spreadsheet application."
