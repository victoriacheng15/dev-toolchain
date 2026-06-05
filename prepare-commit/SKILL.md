---
name: prepare-commit
description: Prepares standardized commits by checking repository state, enforcing staging hygiene, and drafting structured commit.md specs.
---

# Prepare Commit

## Overview

The `prepare-commit` skill establishes a standardized workflow for checking repository state, staging changes cleanly, and drafting a high-signal `commit.md` metadata file. This ensures that every integration is fully documented and conforms to the project's commit message rules.

---

## Automated Execution

For autonomous agents or developer loops, execution of this skill is automated via the companion orchestration script. This script automatically runs the repository audits (`git status`, `git diff HEAD`, and `git log -n 3`) to capture state telemetry.

### Invocation Pattern

The agent discovers the script path from this skill directory and executes it within the repository workspace:

```bash
bash prepare-commit/prepare-commit.sh
```

### Telemetry Processing

Upon execution, the script runs the core workflow queries and automatically outputs the audited state and drafts the compliant `commit.md` file pre-filled with suggested git staging commands.

---

## Commit Message Standard

Commit messages must strictly adhere to the following semantic layout:

- **Format:** `type(scope): imperative subject`
- **Length Constraint:** The subject line must be kept strictly under 72 characters.
- **Allowed Types:** `feat`, `fix`, `refactor`, `chore`, `docs`

---

## Staging Guidelines

To maintain clean and precise pull requests, follow these staging practices:

- **Folder-Level Staging:** Prefer adding directories when it is safe and helps keep staging clean. Prioritize directory-level `git add <dir>` commands when the directory contains only changes intended for the target commit.
- **Path Precision:** Use specific, file-level paths when granular precision is required.
- **Exclusion Rule:** Avoid broad or wildcard adds (`git add .` or `git add -A`) if they risk staging unrelated changes, temporary files, or local secrets.
- **Strict Constraint:** Do not include planning documents or `commit.md` itself in the final execution staging commands.

---

## commit.md Writing Guidelines

The `commit.md` file provides peer reviewers with immediate, high-level structural context.

### List of Changes Requirements

- Explain the primary purpose of the changes.
- Focus on *why* the changes matter.
- Describe overall improvements to the system, workflow, safety, or review process.
- Avoid low-level, line-by-line technical details.
- **Strict Constraint:** Do NOT utilize labels such as `Strategic Impact:` or `Operational Resilience:` within the bullets.

### Writing Style

- Clear and concise.
- Natural and professional.
- Easily digestible for reviewers.

### Mandatory Structure for commit.md

```markdown
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
[Include only the exact git commands used to:
1. git switch -c <branch-name>
2. git add <paths>
3. git commit -m "<type>(<scope>): <subject>"
Do not include commit.md in the staged files.]
```

---

## Verification Checklist

Prior to completing the staging and commit phase, verify that:

1. [ ] **Repository Baseline Audited:** The three status, diff, and log commands have been executed.
2. [ ] **Metadata Compliance:** The `commit.md` file follows the mandatory structure and does not contain illegal labels.
3. [ ] **Commit Message Boundary:** The proposed commit subject line is semantic and under 72 characters.
4. [ ] **Exclusion Verified:** The `commit.md` file and planning documents are excluded from the staging commands.
5. [ ] **Execution Commands Documented:** The execution commands section lists the three required git commands (switch, add, and commit).
