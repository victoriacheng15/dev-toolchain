#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure title is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <title-of-the-decision>"
    exit 1
fi

TITLE="$1"
ADR_DIR="docs/adr"
README_FILE="${ADR_DIR}/README.md"

# Ensure the ADR directory exists
mkdir -p "$ADR_DIR"

# Calculate the next index using a dynamic digits pattern
NEXT_INDEX=1
HIGHEST_FILE=$(find "$ADR_DIR" -maxdepth 1 -name "[0-9]*-*.md" | sort | tail -n 1 || true)

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
TARGET_FILE="${ADR_DIR}/${FILE_NAME}"

# Format the current date
CURRENT_DATE=$(date +%Y-%m-%d)

# Write the ADR template exactly matching the user's specification with Author placeholder
cat <<EOF > "$TARGET_FILE"
# ADR ${PADDED_INDEX}: ${TITLE}

- **Status:** Proposed
- **Date:** ${CURRENT_DATE}
- **Author:** [Author Name]

## Context and Problem Statement

What specific issue triggered this change?

## Decision Outcome

What was the chosen architectural path?

## Consequences

### Positive

- **Benefit 1:** Description

### Negative

- **Drawback 1:** Description

## Verification

- [ ] **Manual Check:** (e.g., Verified logs/UI locally).
- [ ] **Automated Tests:** (e.g., \`make nix-go-test\` passed).
EOF

# Ensure the README.md index file exists in the adr folder
if [ ! -f "$README_FILE" ]; then
    cat <<EOF > "$README_FILE"
# Architectural Decision Records (ADR)

This directory contains the architectural decisions made during the evolution of Cover Craft.

| ID | Title | Description | Status |
| :--- | :--- | :--- | :--- |
EOF
fi

# Append the new ADR as a row to the README.md table automatically
echo "| ${PADDED_INDEX} | [${TITLE}](./${FILE_NAME}) | [Description] | Proposed |" >> "$README_FILE"

echo "Success: Created new ADR at '$TARGET_FILE'"
echo "Updated ADR Index at '$README_FILE'"
echo "To view your active workspace status, run: git status"
