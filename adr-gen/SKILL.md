---
name: adr-gen
description: Guides the creation and management of Architectural Decision Records (ADRs) with immutable indexing.
---

# Architectural Decision Records (ADR)

## Overview

Architectural Decision Records (ADRs) capture critical design decisions, the context in which they were made, and the long-term consequences and trade-offs. This skill standardizes the lifecycle of ADRs, ensuring architectural continuity and visibility as the codebase evolves.

---

## Automated Execution

To create a new, auto-incremented ADR skeleton, execute the companion template generator from the root of the workspace:

```bash
./adr-gen/new-adr.sh "Title of the Decision"
```

This script scans the `docs/adr/` directory, detects the next sequential ID, and generates a pre-formatted template with standard metadata headers.

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
2. [ ] **Chronology Checked:** The next sequential integer index has been reserved using the orchestration script.
3. [ ] **Consequences Documented:** Both positive benefits and negative drawbacks are explicitly listed.
4. [ ] **Traceability Maintained:** If this ADR supersedes an existing one, the old ADR has been edited to change its status to "Superseded by ADR-XXX".
