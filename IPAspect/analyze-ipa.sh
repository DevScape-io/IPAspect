#!/bin/bash

#!/bin/bash
#
# analyze-ipa.sh
# Command-line tool to analyze IPA provisioning profiles
# Usage: ./analyze-ipa.sh <path-to-ipa-file>
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

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if IPA file is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path-to-ipa-file>"
    exit 1
fi

IPA_FILE="$1"

# Verify file exists
if [ ! -f "$IPA_FILE" ]; then
    echo -e "${RED}Error: File not found: $IPA_FILE${NC}"
    exit 1
fi

# Verify it's an IPA file
if [[ ! "$IPA_FILE" =~ \.ipa$ ]]; then
    echo -e "${RED}Error: File must have .ipa extension${NC}"
    exit 1
fi

echo -e "${BLUE}=== IPAspect - IPA Analyzer ===${NC}"
echo -e "Analyzing: ${GREEN}$(basename "$IPA_FILE")${NC}\n"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Extract IPA
echo "📦 Extracting IPA..."
unzip -q "$IPA_FILE" -d "$TEMP_DIR"

# Find provisioning profile
PROFILE=$(find "$TEMP_DIR" -name "*.mobileprovision" | head -n 1)

if [ -z "$PROFILE" ]; then
    echo -e "${RED}❌ Error: No provisioning profile found in IPA${NC}"
    exit 1
fi

echo -e "${GREEN}✓${NC} Found provisioning profile\n"

# Extract plist from provisioning profile
PLIST_FILE="$TEMP_DIR/profile.plist"
security cms -D -i "$PROFILE" > "$PLIST_FILE" 2>/dev/null || {
    # Fallback: extract XML manually if security command fails
    sed -n '/<plist/,/<\/plist>/p' "$PROFILE" > "$PLIST_FILE"
}

# Parse provisioning profile information
echo -e "${BLUE}📋 Provisioning Profile Information${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Team Name
TEAM_NAME=$(/usr/libexec/PlistBuddy -c "Print :TeamName" "$PLIST_FILE" 2>/dev/null || echo "N/A")
echo -e "Team Name:     ${GREEN}$TEAM_NAME${NC}"

# Team Identifier
TEAM_ID=$(/usr/libexec/PlistBuddy -c "Print :TeamIdentifier:0" "$PLIST_FILE" 2>/dev/null || echo "N/A")
echo -e "Team ID:       ${GREEN}$TEAM_ID${NC}"

# Bundle Identifier
BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:application-identifier" "$PLIST_FILE" 2>/dev/null || echo "N/A")
BUNDLE_ID=$(echo "$BUNDLE_ID" | sed "s/^$TEAM_ID\.//")
echo -e "Bundle ID:     ${GREEN}$BUNDLE_ID${NC}"

# Profile Type
GET_TASK_ALLOW=$(/usr/libexec/PlistBuddy -c "Print :Entitlements:get-task-allow" "$PLIST_FILE" 2>/dev/null || echo "false")
DEVICES_COUNT=$(/usr/libexec/PlistBuddy -c "Print :ProvisionedDevices" "$PLIST_FILE" 2>/dev/null | grep -c "^    " || echo "0")

if [ "$GET_TASK_ALLOW" = "true" ]; then
    PROFILE_TYPE="Development"
elif [ "$DEVICES_COUNT" -gt 0 ]; then
    PROFILE_TYPE="Ad Hoc"
else
    PROFILE_TYPE="App Store"
fi
echo -e "Profile Type:  ${GREEN}$PROFILE_TYPE${NC}"

# Creation Date
CREATION_DATE=$(/usr/libexec/PlistBuddy -c "Print :CreationDate" "$PLIST_FILE" 2>/dev/null || echo "N/A")
echo -e "Created:       ${GREEN}$CREATION_DATE${NC}"

# Expiration Date
EXPIRATION_DATE=$(/usr/libexec/PlistBuddy -c "Print :ExpirationDate" "$PLIST_FILE" 2>/dev/null || echo "N/A")
echo -e "Expires:       ${GREEN}$EXPIRATION_DATE${NC}"

# Check if expired
if [ "$EXPIRATION_DATE" != "N/A" ]; then
    EXPIRATION_EPOCH=$(date -j -f "%a %b %d %T %Z %Y" "$EXPIRATION_DATE" +%s 2>/dev/null || echo "0")
    CURRENT_EPOCH=$(date +%s)
    
    echo ""
    echo -e "${BLUE}⏰ Expiration Status${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ "$EXPIRATION_EPOCH" -lt "$CURRENT_EPOCH" ]; then
        DAYS_DIFF=$(( (CURRENT_EPOCH - EXPIRATION_EPOCH) / 86400 ))
        echo -e "${RED}❌ EXPIRED${NC} (${DAYS_DIFF} days ago)"
    else
        DAYS_REMAINING=$(( (EXPIRATION_EPOCH - CURRENT_EPOCH) / 86400 ))
        if [ "$DAYS_REMAINING" -lt 30 ]; then
            echo -e "${YELLOW}⚠️  EXPIRING SOON${NC} (${DAYS_REMAINING} days remaining)"
        else
            echo -e "${GREEN}✓ VALID${NC} (${DAYS_REMAINING} days remaining)"
        fi
    fi
fi

# Provisioned Devices
if [ "$DEVICES_COUNT" -gt 0 ]; then
    echo ""
    echo -e "${BLUE}📱 Provisioned Devices${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "Device Count: ${GREEN}$DEVICES_COUNT${NC}"
    
    if [ "$DEVICES_COUNT" -le 10 ]; then
        echo ""
        for i in $(seq 0 $((DEVICES_COUNT - 1))); do
            DEVICE=$(/usr/libexec/PlistBuddy -c "Print :ProvisionedDevices:$i" "$PLIST_FILE" 2>/dev/null)
            echo "  • $DEVICE"
        done
    else
        echo "(Use -v flag to list all devices)"
    fi
fi

echo ""
echo -e "${GREEN}✓ Analysis complete${NC}"
