---
name: adr-gen
description: Guides the creation and management of Architectural Decision Records (ADRs) with immutable indexing.
version: 1.0.0
license: MIT
inputs:
  adr_title:
    type: string
    description: The title of the architectural decision.
    required: true
outputs:
  - "docs/adr/[num]-[title-slug].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Architectural Decision Records (ADR)

## Overview

Architectural Decision Records (ADRs) capture critical design decisions, the context in which they were made, and the long-term consequences and trade-offs. This skill standardizes the lifecycle of ADRs, ensuring architectural continuity and visibility as the codebase evolves.

---

## Execution Workflow

When creating an ADR, follow these procedural steps:

1. **Resolve Next Index:**
   - Ensure the `docs/adr/` directory exists.
   - Scan `docs/adr/` for existing files matching `[0-9]*-*.md`.
   - Identify the highest decimal integer prefix. Increment by 1 (or start at 1 if none exist).
   - Format the index with 3-digit zero padding (e.g., `001`, `002`).

2. **Slugify Title:**
   - Convert the decision title to lowercase.
   - Replace whitespace and special characters with single hyphens.
   - Strip leading or trailing hyphens to produce `[title-slug]`.
   - Target path: `docs/adr/[num]-[title-slug].md`.

3. **Generate ADR File:**
   - Scaffold the new ADR file using the mandatory schema below.
   - Populate the header with the padded index, title, current date (`YYYY-MM-DD`), and author name.
   - Set the initial status to `Proposed`.

4. **Update Repository Index:**
   - Check if `docs/adr/README.md` exists. If not, initialize it with the index table header:

     ```markdown
     # Architectural Decision Records (ADR)

     This directory contains the architectural decisions made during the evolution of the project.

     | ID | Title | Description | Status |
     | :--- | :--- | :--- | :--- |
     ```

   - Append the new entry row to `docs/adr/README.md`:

     ```markdown
     | [num] | [[title]](./[num]-[title-slug].md) | [Description] | Proposed |
     ```

5. **Populate Decision Content:**
   - Document the problem context, decision outcome, positive/negative consequences, and verification checks.

---

## ADR Lifecycle States

Every ADR must transition through defined, explicit lifecycle states:

- **Proposed:** The decision is currently under active discussion or review.
- **Accepted:** The decision has been approved by the core engineering team and is active.
- **Superseded:** The decision has been replaced by a newer ADR. When superseding, you must update the older ADR's metadata block to point directly to the replacing ADR (e.g., `Superseded by ADR-005`).

---

## Mandatory ADR Template Structure

All ADR markdown files (e.g., `docs/adr/001-use-vitest-for-testing.md`) must strictly adhere to the following schema:

```markdown
# ADR XXX: [Descriptive Title]

- **Status:** [Proposed | Accepted | Superseded by ADR-YYY]
- **Date:** [YYYY-MM-DD]
- **Author:** [Author Name]

## Context and Problem Statement

[What specific issue triggered this change?]

## Decision Outcome

[What was the chosen architectural path?]

## Consequences

### Positive

- **[Benefit 1]:** [Description]

### Negative

- **[Drawback 1]:** [Description]

## Verification

- [ ] **Manual Check:** (e.g., Verified logs/UI locally).
- [ ] **Automated Tests:** (e.g., `make test` passed).
```

---

## Verification Checklist

Prior to committing a new ADR, verify that:

1. [ ] **State Specified:** The metadata section contains an allowed lifecycle state.
2. [ ] **Chronology Checked:** The next sequential integer index has been reserved by inspecting `docs/adr/`.
3. [ ] **Consequences Documented:** Both positive benefits and negative drawbacks are explicitly listed.
4. [ ] **Traceability Maintained:** If this ADR supersedes an existing one, the old ADR has been edited to change its status to "Superseded by ADR-XXX".
5. [ ] **Index Table Synchronized:** A corresponding row has been added to `docs/adr/README.md`.
