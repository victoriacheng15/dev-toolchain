#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure source file or directory is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-source-file-or-directory>"
    exit 1
fi

TARGET="$1"

# If it's a directory, recursively process all supported files
if [ -d "$TARGET" ]; then
    echo "Scanning directory '$TARGET' for source files..."
    # Find all supported files, excluding common test folders/files themselves to avoid infinite loops
    find "$TARGET" -type f \( -name "*.go" -o -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.rs" \) \
        ! -name "*_test.go" ! -name "*.test.ts" ! -name "*.test.js" ! -name "test_*.py" ! -name "test_*.rs" \
        ! -path "*/.*" ! -path "*/node_modules/*" ! -path "*/target/*" ! -path "*/.venv/*" ! -path "*/dist/*" | \
    while read -r file; do
        echo "------------------------------------------------"
        echo "Scaffolding tests for: $file"
        "$0" "$file" || echo "Warning: Skipped $file due to errors or collision."
    done
    echo "------------------------------------------------"
    echo "Scan and scaffolding complete."
    exit 0
fi

# Guard: Ensure file exists
if [ ! -f "$TARGET" ]; then
    echo "Error: Target file or directory '$TARGET' does not exist." >&2
    exit 1
fi

BASE_NAME=$(basename -- "$TARGET")
DIR_NAME=$(dirname -- "$TARGET")
EXTENSION="${BASE_NAME##*.}"
MODULE_NAME="${BASE_NAME%.*}"

case "$EXTENSION" in
    go)
        TEST_FILE="${DIR_NAME}/${MODULE_NAME}_test.go"
        ;;
    ts|js)
        TEST_FILE="${DIR_NAME}/${MODULE_NAME}.test.${EXTENSION}"
        ;;
    py)
        TEST_FILE="${DIR_NAME}/test_${MODULE_NAME}.py"
        ;;
    rs)
        TEST_FILE="${DIR_NAME}/test_${MODULE_NAME}.rs"
        ;;
    *)
        echo "Error: Unsupported file extension '$EXTENSION'. Supported: .go, .ts, .js, .py, .rs" >&2
        exit 1
        ;;
esac

# Collision Prevention
if [ -f "$TEST_FILE" ]; then
    echo "Error: Test file already exists at '$TEST_FILE'. Collision prevented." >&2
    exit 1
fi

if [ "$EXTENSION" = "go" ]; then
    PACKAGE_NAME=$(grep -E '^\s*package\s+[a-zA-Z0-9_]+' "$TARGET" | head -n 1 | awk '{print $2}' || true)
    if [ -z "$PACKAGE_NAME" ]; then
        PACKAGE_NAME="main"
    fi

    # Extract public functions/methods
    FUNCTIONS=$(grep -E '^\s*func\s+(\([^)]+\)\s+)?([A-Z][a-zA-Z0-9_]*)' "$TARGET" | sed -E 's/.*func\s+(\([^)]+\)\s+)?([A-Z][a-zA-Z0-9_]*).*/\2/' | sort -u || true)

    if [ -z "$FUNCTIONS" ]; then
        FUNCTIONS="PlaceholderFunction"
    fi

    cat <<EOF > "$TEST_FILE"
package ${PACKAGE_NAME}

import (
	"testing"
)
EOF

    for FUNC in $FUNCTIONS; do
        cat <<EOF >> "$TEST_FILE"

func Test${FUNC}(t *testing.T) {
	tests := []struct {
		name     string
		input    any // Replace with actual input type
		expected any // Replace with actual expected type
		wantErr  bool
	}{
		{
			name:     "happy path",
			input:    nil,
			expected: nil,
			wantErr:  false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// TODO: Invoke the function/method and assert results
			// got, err := ${FUNC}(tt.input)
			// if (err != nil) != tt.wantErr {
			// 	t.Errorf("${FUNC}() error = %v, wantErr %v", err, tt.wantErr)
			// 	return
			// }
			// if got != tt.expected {
			// 	t.Errorf("${FUNC}() = %v, want %v", got, tt.expected)
			// }
		})
	}
}
EOF
    done

elif [ "$EXTENSION" = "ts" ] || [ "$EXTENSION" = "js" ]; then
    # Extract exported functions or classes or const arrow functions
    FUNCTIONS=$(grep -E '^\s*export\s+(function|const|class)\s+([a-zA-Z0-9_]*)' "$TARGET" | sed -E 's/.*export\s+(function|const|class)\s+([a-zA-Z0-9_]*).*/\2/' | sort -u || true)

    if [ -z "$FUNCTIONS" ]; then
        FUNCTIONS="placeholderFunction"
    fi

    IMPORT_LIST=$(echo "$FUNCTIONS" | paste -sd, - | sed 's/,/, /g')

    cat <<EOF > "$TEST_FILE"
import { describe, it, expect } from 'vitest';
import { ${IMPORT_LIST} } from './${MODULE_NAME}';
EOF

    for FUNC in $FUNCTIONS; do
        cat <<EOF >> "$TEST_FILE"

describe('${FUNC}', () => {
  const cases = [
    {
      name: 'happy path',
      input: undefined,
      expected: undefined,
      wantErr: false,
    },
  ];

  it.each(cases)('\$name', ({ input, expected, wantErr }) => {
    if (wantErr) {
      expect(() => ${FUNC}(input)).toThrow();
    } else {
      expect(${FUNC}(input)).toEqual(expected);
    }
  });
});
EOF
    done

elif [ "$EXTENSION" = "py" ]; then
    # Extract function definitions (avoiding private functions starting with double underscores)
    FUNCTIONS=$(grep -E '^\s*def\s+([a-zA-Z0-9_]+)' "$TARGET" | grep -v 'def __' | sed -E 's/.*def\s+([a-zA-Z0-9_]+).*/\1/' | sort -u || true)

    if [ -z "$FUNCTIONS" ]; then
        FUNCTIONS="placeholder_function"
    fi

    IMPORT_LIST=$(echo "$FUNCTIONS" | paste -sd, - | sed 's/,/, /g')

    cat <<EOF > "$TEST_FILE"
import pytest
from .${MODULE_NAME} import ${IMPORT_LIST}
EOF

    for FUNC in $FUNCTIONS; do
        cat <<EOF >> "$TEST_FILE"


@pytest.mark.parametrize(
    "input_data, expected, want_err",
    [
        pytest.param(None, None, False, id="happy_path"),
    ]
)
def test_${FUNC}(input_data, expected, want_err):
    if want_err:
        with pytest.raises(Exception):
            ${FUNC}(input_data)
    else:
        assert ${FUNC}(input_data) == expected
EOF
    done

elif [ "$EXTENSION" = "rs" ]; then
    # Extract pub fn functions
    FUNCTIONS=$(grep -E '^\s*pub\s+fn\s+([a-zA-Z0-9_]+)' "$TARGET" | sed -E 's/.*pub\s+fn\s+([a-zA-Z0-9_]+).*/\1/' | sort -u || true)

    if [ -z "$FUNCTIONS" ]; then
        FUNCTIONS="placeholder_function"
    fi

    cat <<EOF > "$TEST_FILE"
use rstest::rstest;
// Adjust the super module path below if necessary (e.g. use crate::${MODULE_NAME})
use super::${MODULE_NAME}::{$(echo "$FUNCTIONS" | paste -sd, - | sed 's/,/, /g')};
EOF

    for FUNC in $FUNCTIONS; do
        cat <<EOF >> "$TEST_FILE"

#[rstest]
#[case::happy_path(None, None, false)]
fn test_${FUNC}(
    #[case] input: Option<()>,
    #[case] expected: Option<()>,
    #[case] want_err: bool,
) {
    // TODO: Implement test assertions
    // let result = ${FUNC}(input);
    // if want_err {
    //     assert!(result.is_err());
    // } else {
    //     assert_eq!(result.unwrap(), expected.unwrap());
    // }
}
EOF
    done
fi

echo "Success: Created test file at '$TEST_FILE'"
echo "To view your active workspace status, run: git status"
