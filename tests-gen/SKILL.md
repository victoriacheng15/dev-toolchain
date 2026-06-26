---
name: tests-gen
description: Programmatically scaffolds language-specific unit test suites with table-driven assertions for Go, TS, Python, and Rust.
---

# Unit Test Scaffolding

## Overview

Unit testing is the cornerstone of system reliability, but writing boilerplate setup code creates friction and delays coverage. This skill automates the programmatically scaffolded creation of unit test suites across Go, TypeScript/JavaScript, Python, and Rust, establishing table-driven assertions as the project standard.

---

## Automated Execution

To scaffold a new test file for a target source file, execute the template generator from the root of the workspace:

```bash
./tests-gen/tests-gen.sh path/to/source_file.ext
```

This script parses the target file for exports, receiver methods, and function signatures, creates the corresponding test file in the same directory, and outputs a table-driven test skeleton.

---

## Collision Prevention

To prevent accidental data loss, the script enforces a strict collision check. If a test file with the target name already exists (e.g. `test_utils.py` for `utils.py`), the execution will fail immediately with a non-zero exit status and block overwriting.

---

## Language Specifications and Standards

Every generated test skeleton is structured around a **Table-Driven / Parameterized Testing Pattern** to ensure tests remain highly readable and expandable:

### 1. Go (`*_test.go`)

- **Pattern:** Standard Go slice-of-struct table-driven blocks using `t.Run()`.
- **Framework:** Standard Library `testing` package.

### 2. TypeScript (`*.test.ts` or `*.test.js`)

- **Pattern:** Vitest `describe` block utilizing `it.each()` for parameterized data-driven test rows.
- **Framework:** `vitest`.

### 3. Python (`test_*.py`)

- **Pattern:** Function-based test with `@pytest.mark.parametrize` decorator supplying isolated test cases.
- **Framework:** `pytest`.

### 4. Rust (`test_*.rs`)

- **Pattern:** Parameterized tests driven by the `#[rstest]` macro-based case configurations.
- **Framework:** `rstest`.

---

## Verification Checklist

Prior to finalizing test generation, verify that:

1. [ ] **Exported Elements Parsed:** Confirm all public functions and methods were scanned and represented in the test suite.
2. [ ] **No Collision Occurred:** Verify the generator succeeded with a zero-exit status and created a new file.
3. [ ] **Syntax Valid:** Confirm that the generated import paths relative to the source module are syntactically correct.
4. [ ] **Table Configured:** Populate the test table array or macro blocks with realistic input, expected outcomes, and error flags.
