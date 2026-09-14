---
name: tests-gen
description: Programmatically scaffolds language-specific unit test suites with table-driven assertions for Go, TS, Python, and Rust.
version: 1.0.0
license: MIT
inputs:
  source_file:
    type: string
    description: Path to the target source code file.
    required: true
outputs:
  - "[source_file]_test.[ext]"
on_failure:
  policy: retry
  max_retries: 3
---

# Unit Test Scaffolding

## Overview

Unit testing is the cornerstone of system reliability, but writing boilerplate setup code creates friction and delays coverage. This skill standardizes the scaffolded creation of unit test suites across Go, TypeScript/JavaScript, Python, and Rust, establishing table-driven assertions as the project standard.

---

## Execution Workflow

When scaffolding unit tests for a target source file, follow these procedural steps:

1. **Resolve Test File Path:**
   - Identify the source file language and derive the target test path in the same directory:
     - **Go:** `[dir]/[name].go` -> `[dir]/[name]_test.go`
     - **TypeScript/JavaScript:** `[dir]/[name].[ext]` -> `[dir]/[name].test.[ext]`
     - **Python:** `[dir]/[name].py` -> `[dir]/test_[name].py`
     - **Rust:** `[dir]/[name].rs` -> `[dir]/test_[name].rs`

2. **Collision Check:**
   - Verify whether the target test file already exists.
   - If the file exists, halt creation to prevent overwriting existing test suites.

3. **Analyze Source Signatures:**
   - Read the target source file and identify exported functions, methods, parameters, and return types.
   - Determine error-handling signatures (e.g., `error` in Go, throwing functions in TS, exceptions in Python, `Result` in Rust).

4. **Generate Table-Driven Test Skeleton:**
   - Scaffold the test file using the appropriate language pattern below.
   - Construct parameterized test cases including positive paths, edge boundaries, and error conditions.

---

## Language Specifications and Templates

Every generated test file must follow the table-driven or parameterized pattern for its language:

### 1. Go (`*_test.go`)

- **Framework:** Standard library `testing` package.
- **Pattern:** Slice of struct executed via `t.Run()`.

```go
package example

import (
  "testing"
)

func TestFunctionName(t *testing.T) {
  tests := []struct {
    name     string
    input    any
    expected any
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
      got, err := FunctionName(tt.input)
      if (err != nil) != tt.wantErr {
        t.Fatalf("FunctionName() error = %v, wantErr %v", err, tt.wantErr)
      }
      if got != tt.expected {
        t.Errorf("FunctionName() = %v, want %v", got, tt.expected)
      }
    })
  }
}
```

### 2. TypeScript / JavaScript (`*.test.ts` / `*.test.js`)

- **Framework:** `vitest`.
- **Pattern:** `describe` block utilizing `it.each()` for parameterized data rows.

```typescript
import { describe, it, expect } from 'vitest';
import { functionName } from './module';

describe('functionName', () => {
  const cases = [
    {
      name: 'happy path',
      input: 'valid-input',
      expected: 'expected-output',
      wantErr: false,
    },
  ];

  it.each(cases)('$name', ({ input, expected, wantErr }) => {
    if (wantErr) {
      expect(() => functionName(input)).toThrow();
    } else {
      expect(functionName(input)).toEqual(expected);
    }
  });
});
```

### 3. Python (`test_*.py`)

- **Framework:** `pytest`.
- **Pattern:** Function-based test with `@pytest.mark.parametrize`.

```python
import pytest
from .module import function_name


@pytest.mark.parametrize(
    "input_data, expected, want_err",
    [
        pytest.param("valid-input", "expected-output", False, id="happy_path"),
    ],
)
def test_function_name(input_data, expected, want_err):
    if want_err:
        with pytest.raises(Exception):
            function_name(input_data)
    else:
        assert function_name(input_data) == expected
```

### 4. Rust (`test_*.rs`)

- **Framework:** `rstest`.
- **Pattern:** Parameterized tests driven by `#[rstest]`.

```rust
use rstest::rstest;
use super::module::function_name;

#[rstest]
#[case::happy_path("valid-input", "expected-output", false)]
fn test_function_name(
    #[case] input: &str,
    #[case] expected: &str,
    #[case] want_err: bool,
) {
    let result = function_name(input);
    if want_err {
        assert!(result.is_err());
    } else {
        assert_eq!(result.unwrap(), expected);
    }
}
```

---

## Verification Checklist

Prior to finalizing test generation, verify that:

1. [ ] **Exported Elements Parsed:** Confirm all public functions and methods were scanned and represented in the test suite.
2. [ ] **No Collision Occurred:** Confirm the target test file was newly created without overwriting existing tests.
3. [ ] **Imports Valid:** Confirm import paths relative to the source module are syntactically valid.
4. [ ] **Table Configured:** Verify the test table contains realistic input, expected outcome, and error cases.
