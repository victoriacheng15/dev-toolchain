#!/usr/bin/env bash
set -euo pipefail

# ANSI color codes for premium visual output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Ensure execution context is within a valid git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}${BOLD}Error:${NC} Execution context is not within a valid Git repository." >&2
    exit 1
fi

echo -e "${BOLD}${BLUE}========================================================================${NC}"
echo -e "${BOLD}${CYAN}                   FRESH-EYE CODE AUDITOR                               ${NC}"
echo -e "${BOLD}${BLUE}========================================================================${NC}"

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD)
CURRENT_DATE=$(date +%Y-%m-%d)

echo -e "${BOLD}Target Branch:${NC} ${CURRENT_BRANCH}"
echo -e "${BOLD}Audit Date:${NC}    ${CURRENT_DATE}"

# Detect modified files
MODIFIED_FILES=$(git diff --name-only && git diff --cached --name-only | sort -u || true)

if [ -z "$MODIFIED_FILES" ]; then
    echo -e "\n${GREEN}${BOLD}No modifications detected in the working tree. Status clean.${NC}"
    echo -e "${BOLD}${BLUE}========================================================================${NC}"
    exit 0
fi

echo -e "\n${BOLD}${YELLOW}[1/3] Scope of Changes${NC}"
echo "$MODIFIED_FILES" | sed 's/^/  - /'

# Run audits on diff
echo -e "\n${BOLD}${YELLOW}[2/3] Code Quality & Safety Audit${NC}"

BLOCKERS=0

# Check for debug print statements in the diff
# Searches for added lines containing console.log, print(, println(, fmt.Print, TODO, or FIXME
STAGED_DIFF=$(git diff --cached && git diff || true)

# Search for console.log/println/print in modified lines
DEBUG_LINES=$(echo "$STAGED_DIFF" | grep -E '^\+[^+]' | grep -E '(console\.log|print\(|println\(|fmt\.Print|TODO|FIXME)' || true)

if [ -n "$DEBUG_LINES" ]; then
    echo -e "  ${RED}${BOLD}● Blocker:${NC} Debug or temporary code detected in modifications:"
    echo "$DEBUG_LINES" | sed 's/^/    /'
    BLOCKERS=$((BLOCKERS + 1))
else
    echo -e "  ${GREEN}✓ No temporary debug statements or TODOs detected.${NC}"
fi

# Run Test Coverage Audit
echo -e "\n${BOLD}${YELLOW}[3/3] Test Coverage Audit${NC}"

MISSING_TESTS=0
while read -r file; do
    # Skip directories or non-source files
    if [ ! -f "$file" ]; then continue; fi
    
    filename=$(basename -- "$file")
    extension="${filename##*.}"
    name="${filename%.*}"
    dir=$(dirname -- "$file")
    
    # Logic to check if matching test file exists
    case "$extension" in
        go)
            if [[ ! "$filename" =~ _test\.go$ ]] && [ ! -f "${dir}/${name}_test.go" ]; then
                echo -e "  ${YELLOW}⚠ Warning:${NC} Missing test file for Go source: ${file}"
                MISSING_TESTS=$((MISSING_TESTS + 1))
            fi
            ;;
        ts|js)
            if [[ ! "$filename" =~ \.test\.(ts|js)$ ]] && [ ! -f "${dir}/${name}.test.${extension}" ]; then
                echo -e "  ${YELLOW}⚠ Warning:${NC} Missing test file for JavaScript/TypeScript: ${file}"
                MISSING_TESTS=$((MISSING_TESTS + 1))
            fi
            ;;
        py)
            if [[ ! "$filename" =~ ^test_ ]] && [ ! -f "${dir}/test_${filename}" ]; then
                echo -e "  ${YELLOW}⚠ Warning:${NC} Missing test file for Python source: ${file}"
                MISSING_TESTS=$((MISSING_TESTS + 1))
            fi
            ;;
        rs)
            if [[ ! "$filename" =~ ^test_ ]] && [ ! -f "${dir}/test_${filename}" ]; then
                echo -e "  ${YELLOW}⚠ Warning:${NC} Missing test file for Rust source: ${file}"
                MISSING_TESTS=$((MISSING_TESTS + 1))
            fi
            ;;
    esac
done <<< "$MODIFIED_FILES"

if [ "$MISSING_TESTS" -eq 0 ]; then
    echo -e "  ${GREEN}✓ All modified files have corresponding test files.${NC}"
fi

echo -e "\n${BOLD}${BLUE}========================================================================${NC}"

# Audit Decisions & Exit Status
if [ "$BLOCKERS" -gt 0 ]; then
    echo -e "${RED}${BOLD}Audit Failed:${NC} ${BLOCKERS} blocker(s) detected. Fix before committing."
    echo -e "${BOLD}${BLUE}========================================================================${NC}"
    exit 1
else
    echo -e "${GREEN}${BOLD}Audit Passed:${NC} No blockers detected."
    echo -e "${BOLD}${BLUE}========================================================================${NC}"
    exit 0
fi
