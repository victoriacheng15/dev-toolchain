#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure title is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <title-of-the-incident>"
    exit 1
fi

TITLE="$1"
INCIDENTS_DIR="docs/incidents"
README_FILE="${INCIDENTS_DIR}/README.md"

# Ensure the incidents directory exists
mkdir -p "$INCIDENTS_DIR"

# Calculate the next index using a dynamic digits pattern
NEXT_INDEX=1
HIGHEST_FILE=$(find "$INCIDENTS_DIR" -maxdepth 1 -name "[0-9]*-*.md" | sort | tail -n 1 || true)

if [ -n "$HIGHEST_FILE" ]; then
    BASENAME=$(basename -- "$HIGHEST_FILE")
    HIGHEST_INDEX=$(echo "$BASENAME" | cut -d'-' -f1)
    # Remove leading zeros to treat as a decimal number
    HIGHEST_INDEX_DECIMAL=$((10#$HIGHEST_INDEX))
    NEXT_INDEX=$((HIGHEST_INDEX_DECIMAL + 1))
fi

# Pad the index with leading zeros to 3 digits (e.g. 001)
PADDED_INDEX=$(printf "%03d" "$NEXT_INDEX")

# Slugify the title (lowercase, replace spaces/special chars with hyphens)
SLUG=$(echo "$TITLE" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g' | sed -E 's/^-+|-+$//g')

FILE_NAME="${PADDED_INDEX}-${SLUG}.md"
TARGET_FILE="${INCIDENTS_DIR}/${FILE_NAME}"

# Format the current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Write the RCA template matching user spec exactly
cat <<EOF > "$TARGET_FILE"
# RCA [${PADDED_INDEX}]: ${TITLE}

- **Status:** Investigating
- **Date:** ${CURRENT_DATE}
- **Severity:** Medium
- **Author:** [Author Name]

## Summary

A brief overview of what happened, the impact, and the duration.

## Timeline

- **${CURRENT_DATE} HH:MM:** Incident detected.
- **${CURRENT_DATE} HH:MM:** Investigation started.
- **${CURRENT_DATE} HH:MM:** Mitigation applied.
- **${CURRENT_DATE} HH:MM:** Root cause identified.
- **${CURRENT_DATE} HH:MM:** Permanent fix deployed.

## Root Cause Analysis

Detailed explanation of why the incident happened (The "Why").

## Lessons Learned (Optional)

What went well? What went wrong? What reduced the impact?

## Action Items

- [ ] **Fix:** Immediate technical resolution.
- [ ] **Prevention:** Changes to prevent recurrence (e.g., monitoring, tests).
- [ ] **Process:** Changes to workflows or documentation.

## Verification

- [ ] **Manual Check:**
- [ ] **Automated Tests:**
EOF

# Ensure the README.md index file exists in the incidents folder
if [ ! -f "$README_FILE" ]; then
    cat <<EOF > "$README_FILE"
# Root Cause Analysis (RCA)

This directory contains the root cause analyses recorded for system incidents.

| ID | Title | Date | Severity | Status |
| :--- | :--- | :--- | :--- | :--- |
EOF
fi

# Append the new RCA as a row to the README.md table automatically
echo "| ${PADDED_INDEX} | [${TITLE}](./${FILE_NAME}) | ${CURRENT_DATE} | Medium | Investigating |" >> "$README_FILE"

echo "Success: Created new RCA at '$TARGET_FILE'"
echo "Updated RCA Index at '$README_FILE'"
echo "To view your active workspace status, run: git status"
