---
name: prepare-commit
description: Prepares standardized commits by checking repository state, enforcing staging hygiene, and drafting structured commit.md specs.
version: 1.0.0
license: MIT
inputs: {}
outputs:
  - commit.md
on_failure:
  policy: retry
  max_retries: 3
---

# Prepare Commit

## Overview

The `prepare-commit` skill establishes a standardized workflow for checking repository state, staging changes cleanly, and drafting a high-signal `commit.md` metadata file. This ensures that every integration is fully documented and conforms to the project's commit message rules.

---

## Execution Workflow

When preparing a commit, follow these procedural steps:

1. **Audit Repository Baseline:**
   - Execute `git status` to identify untracked, staged, and unstaged modifications.
   - Execute `git diff HEAD --stat` to review the scope and modified file footprint.
   - Execute `git log -n 3 --oneline` to review recent commit history for style and convention context.

2. **Analyze Scope and Semantic Type:**
   - Determine the primary affected directory or subsystem to establish the commit `scope`.
   - Select the semantic change `type` (`feat`, `fix`, `refactor`, `chore`, `docs`).
   - Choose a unique branch name (must not match the current branch).
   - Identify clean staging paths (prioritize directory-level paths when safe).

3. **Draft `commit.md` Specification:**
   - Create `commit.md` in the workspace root following the mandatory structure below.
   - Verify the subject line adheres to semantic conventions and is under 72 characters.
   - Format the execution commands section inside a bash code block.

---

## Commit Message Standard

Commit messages must strictly adhere to the following semantic layout:

- **Format:** `type(scope): imperative subject`
- **Length Constraint:** The subject line must be kept strictly under 72 characters.
- **Allowed Types:** `feat`, `fix`, `refactor`, `chore`, `docs`

---

## Branching & Staging Guidelines

To maintain clean and precise pull requests, follow these practices:

- **Branch Uniqueness:** The target branch name must not be the same as the previous (or current) branch.
- **Folder-Level Staging (Critical Priority):** Prefer adding directories when it is safe and helps keep staging clean. Prioritize directory-level `git add <dir>` commands when the directory contains only changes intended for the target commit.
- **Path Precision:** Use specific, file-level paths when granular precision is required.
- **Exclusion Rule:** Avoid broad or wildcard adds (`git add .` or `git add -A`) if they risk staging unrelated changes, temporary files, or local secrets.
- **Strict Constraint:** Do not include planning documents or `commit.md` itself in the final execution staging commands.

---

## commit.md Writing Guidelines

The `commit.md` file provides peer reviewers with immediate, high-level structural context.

### List of Changes & Verification Requirements

1. **Writing Style**:
   - Clear and concise.
   - Natural and professional.
   - Easily digestible for reviewers.
2. **List of Changes**:
   - **Strategic & High-Level Context**:
     - Focus on *why* the changes matter.
     - Explain the primary purpose of the changes.
   - **System & Process Impact**:
     - Describe overall improvements to the system, workflow, safety, or review process.
     - Avoid low-level, line-by-line technical details.
     - **Strict Constraint:** Do NOT utilize labels such as `Strategic Impact:` or `Operational Resilience:` within the bullets.
3. **Verification**:
   - **Keep it Short and Simple**:
     - Only include the command(s) that verify the state on test, formatting, linting, or any specific part of the code that changed.
     - Do not include the final results of the commands (e.g., use "- [x] `make test`" without appending test counts, status codes, or terminal logs).

### Mandatory Structure for commit.md

````markdown
# Git Commit Info

## PR Description

### Summary
[Write 2 to 3 sentences explaining the problem being solved and the value of the change.]

### List of Changes
- [One bullet describing the main improvement or purpose]
- [One bullet describing system, workflow, safety, or review benefit]

### Verification
[Use Markdown checklist syntax for verification items. Verification items must directly verify the current PR's scope. Treat the items below as examples, not required slots to fill mechanically.]

- [ ] [At least one automated test or check that was completed]
- [ ] [At least one manual validation step that still needs to be completed]

## Execution Commands

```bash
git switch -c <branch-name>
git add <paths>
git commit -m "<type>(<scope>): <subject>"
```
````

---

## Verification Checklist

Prior to completing the staging and commit phase, verify that:

1. [ ] **Repository Baseline Audited:** The three status, diff, and log commands have been executed.
2. [ ] **Metadata Compliance:** The `commit.md` file follows the mandatory structure and does not contain illegal labels.
3. [ ] **Commit Message Boundary:** The proposed commit subject line is semantic and under 72 characters.
4. [ ] **Exclusion Verified:** The `commit.md` file and planning documents are excluded from the staging commands.
5. [ ] **Execution Commands Documented:** The execution commands section lists the three required git commands (switch, add, and commit).
6. [ ] **Branch Uniqueness Verified:** The new branch name is not the same as the previous (or current) branch.
