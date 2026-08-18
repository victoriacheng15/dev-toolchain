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

# Guard: Ensure PR number is provided
if [ $# -lt 1 ]; then
    echo -e "${RED}${BOLD}Usage:${NC} $0 <pr-number> [base-branch]" >&2
    exit 1
fi

PR_NUM="$1"
BASE_BRANCH="${2:-}"

# Sanitize PR number to integer-like string
NUM=$(echo "$PR_NUM" | tr -cd '0-9')
if [ -z "$NUM" ]; then
    echo -e "${RED}${BOLD}Error:${NC} PR number must contain digits." >&2
    exit 1
fi

# Ensure execution context is within a valid git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}${BOLD}Error:${NC} Execution context is not within a valid Git repository." >&2
    exit 1
fi

echo -e "${BOLD}${BLUE}========================================================================${NC}"
echo -e "${BOLD}${CYAN}                   PR REVIEW & VERIFICATION SYSTEM                      ${NC}"
echo -e "${BOLD}${BLUE}========================================================================${NC}"

# Detect base branch if not provided
if [ -z "$BASE_BRANCH" ]; then
    if git show-ref --verify --quiet refs/heads/main; then
        BASE_BRANCH="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        BASE_BRANCH="master"
    else
        # Fallback to HEAD~1 if no main/master branches are found
        BASE_BRANCH="HEAD~1"
    fi
fi

CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || git rev-parse --abbrev-ref HEAD)
CURRENT_DATE=$(date +%Y-%m-%d)
REPORT_FILE="pr-${NUM}.md"

# Find merge base or fallback to base branch ref
if [ "$BASE_BRANCH" = "HEAD~1" ]; then
    MERGE_BASE="HEAD~1"
else
    MERGE_BASE=$(git merge-base "$BASE_BRANCH" HEAD 2>/dev/null || echo "$BASE_BRANCH")
fi

# Resolve to short commit SHA for readability if possible
MERGE_BASE_SHORT=$(git rev-parse --short "$MERGE_BASE" 2>/dev/null || echo "$MERGE_BASE")

echo -e "${BOLD}PR Number:${NC}      ${NUM}"
echo -e "${BOLD}Current Branch:${NC} ${CURRENT_BRANCH}"
echo -e "${BOLD}Base Branch:${NC}    ${BASE_BRANCH}"
echo -e "${BOLD}Review Date:${NC}   ${CURRENT_DATE}"
echo -e "${BOLD}Report File:${NC}   ${REPORT_FILE}"
echo -e "${BOLD}Merge Base:${NC}     ${MERGE_BASE_SHORT}"

# Gather changed files
CHANGED_FILES=$( (git diff --name-only "$MERGE_BASE" HEAD && git diff --name-only && git diff --cached --name-only) | sort -u || true)

if [ -z "$CHANGED_FILES" ]; then
    echo -e "\n${GREEN}${BOLD}No changes detected between ${BASE_BRANCH} and HEAD. Status clean.${NC}"
    echo -e "${BOLD}${BLUE}========================================================================${NC}"
    exit 0
fi

echo -e "\n${BOLD}${YELLOW}[1/4] Scope of Changes${NC}"
echo "$CHANGED_FILES" | sed 's/^/  - /'

# Detect test files
TEST_FILES=""
while read -r file; do
    if [ -z "$file" ] || [ ! -f "$file" ]; then continue; fi
    filename=$(basename -- "$file")
    if [[ "$filename" =~ (_test\.go|\.test\.(js|ts)|\.spec\.(js|ts)|test_.*\.py)$ ]]; then
        TEST_FILES="${TEST_FILES}${file}\n"
    fi
done <<< "$CHANGED_FILES"

echo -e "\n${BOLD}${YELLOW}[2/4] Test Detection & Execution${NC}"
TEST_CMD=""
TEST_STATUS="No Tests Found"
TEST_LOG=""

# Detect test framework/language
if [ -f "go.mod" ]; then
    TEST_CMD="go test -v ./..."
elif [ -f "package.json" ] && grep -q '"test"' package.json; then
    TEST_CMD="npm test"
elif [ -f "Cargo.toml" ]; then
    TEST_CMD="cargo test"
elif [ -f "Makefile" ] && grep -q '^test:' Makefile; then
    TEST_CMD="make test"
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    if command -v pytest >/dev/null 2>&1; then
        TEST_CMD="pytest"
    elif command -v python >/dev/null 2>&1; then
        TEST_CMD="python -m unittest"
    fi
fi

if [ -n "$TEST_FILES" ]; then
    echo -e "  Modified test files detected:"
    echo -e "$TEST_FILES" | sed '/^$/d' | sed 's/^/    - /'
fi

if [ -n "$TEST_CMD" ]; then
    echo -e "  Running test suite: ${BOLD}${CYAN}${TEST_CMD}${NC}"
    set +e
    TEST_OUTPUT=$(eval "$TEST_CMD" 2>&1)
    TEST_EXIT_CODE=$?
    set -e
    
    if [ $TEST_EXIT_CODE -eq 0 ]; then
        TEST_STATUS="Passed"
        echo -e "  ${GREEN}✓ Tests passed successfully.${NC}"
    else
        TEST_STATUS="Failed"
        echo -e "  ${RED}✗ Tests failed with exit code $TEST_EXIT_CODE.${NC}"
    fi
    TEST_LOG="$TEST_OUTPUT"
else
    echo -e "  ${YELLOW}No automated test command detected or configured for this repository type.${NC}"
    TEST_LOG="No automated test suite discovered."
fi

# Run Build & Dev Verification
echo -e "\n${BOLD}${YELLOW}[3/4] Build & Dev Verification${NC}"
BUILD_CMD=""
BUILD_STATUS="Not Configured"
BUILD_LOG=""

if [ -f "go.mod" ]; then
    BUILD_CMD="go build ./..."
elif [ -f "package.json" ] && grep -q '"build"' package.json; then
    BUILD_CMD="npm run build"
elif [ -f "Cargo.toml" ]; then
    BUILD_CMD="cargo build"
elif [ -f "Makefile" ] && grep -q '^build:' Makefile; then
    BUILD_CMD="make build"
fi

if [ -n "$BUILD_CMD" ]; then
    echo -e "  Running build validation: ${BOLD}${CYAN}${BUILD_CMD}${NC}"
    set +e
    BUILD_OUTPUT=$(eval "$BUILD_CMD" 2>&1)
    BUILD_EXIT_CODE=$?
    set -e
    
    if [ $BUILD_EXIT_CODE -eq 0 ]; then
        BUILD_STATUS="Passed"
        echo -e "  ${GREEN}✓ Build compiled successfully.${NC}"
    else
        BUILD_STATUS="Failed"
        echo -e "  ${RED}✗ Build failed with exit code $BUILD_EXIT_CODE.${NC}"
    fi
    BUILD_LOG="$BUILD_OUTPUT"
else
    echo -e "  ${YELLOW}No automated build command detected for this repository type.${NC}"
    BUILD_LOG="No automated build command discovered."
fi

# Generate Report Skeleton
echo -e "\n${BOLD}${YELLOW}[4/4] Generating PR Review Report${NC}"

# Collision Prevention
if [ -f "$REPORT_FILE" ]; then
    echo -e "${RED}${BOLD}Warning:${NC} '${REPORT_FILE}' already exists. Overwriting." >&2
fi

cat <<EOF > "$REPORT_FILE"
# Pull Request Review Report: PR #${NUM}

- **Target Branch:** \`${CURRENT_BRANCH}\`
- **Base Branch:** \`${BASE_BRANCH}\`
- **Compare Commits:** \`${MERGE_BASE_SHORT}\`...HEAD
- **Review Date:** ${CURRENT_DATE}
- **Issue Link:** [Link to related issue]

## 1. Scope of Changes

The following files were modified, added, or deleted between \`${BASE_BRANCH}\` and \`HEAD\`:

\`\`\`text
$(echo "$CHANGED_FILES")
\`\`\`

## 2. Test Verification Status

- **Test Command Detected/Run:** \`${TEST_CMD:-None}\`
- **Status:** **${TEST_STATUS}**
- **Output Summary:**
\`\`\`text
${TEST_LOG}
\`\`\`

## 3. Build & Dev Verification Status

- **Build/Dev Command Detected/Run:** \`${BUILD_CMD:-None}\`
- **Status:** **${BUILD_STATUS}**
- **Output Summary:**
\`\`\`text
${BUILD_LOG}
\`\`\`

## 4. Detailed Code Review

*The AI agent will analyze the diff in detail and populate this section with critical reviews concerning correctness, logic, performance, security, and styling.*

## 5. Summary & Recommendation

- **Verdict:** [Pending / Approved / Request Changes]
- **Key Actions Required:**
  - [ ] Add specific actions here.
EOF

echo -e "  ${GREEN}✓ Created review report at ${REPORT_FILE}${NC}"
echo -e "${BOLD}${BLUE}========================================================================${NC}"
