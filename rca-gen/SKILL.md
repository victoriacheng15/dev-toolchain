---
name: rca-gen
description: Guides the creation and management of Root Cause Analysis (RCA) records with chronological indexing.
version: 1.0.0
license: MIT
inputs:
  incident_title:
    type: string
    description: The title of the incident / outage.
    required: true
outputs:
  - "docs/incidents/[num]-[title-slug].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Root Cause Analysis (RCA)

## Overview

Root Cause Analysis (RCA) is a structured process to identify the underlying vulnerabilities that caused a system failure or incident. This skill standardizes the lifecycle of RCAs, ensuring that we learn from every failure, document technical debt, and prevent regression through systemic, architectural improvements.

---

## Execution Workflow

When documenting an incident, follow these procedural steps:

1. **Resolve Next Index:**
   - Ensure the `docs/incidents/` directory exists.
   - Scan `docs/incidents/` for existing files matching `[0-9]*-*.md`.
   - Identify the highest decimal integer prefix. Increment by 1 (or start at 1 if none exist).
   - Format the index with 3-digit zero padding (e.g., `001`, `002`).

2. **Slugify Title:**
   - Convert the incident title to lowercase.
   - Replace whitespace and special characters with single hyphens.
   - Strip leading or trailing hyphens to produce `[title-slug]`.
   - Target path: `docs/incidents/[num]-[title-slug].md`.

3. **Generate RCA File:**
   - Scaffold the new RCA file using the mandatory schema below.
   - Populate the header with the padded index, title, current date (`YYYY-MM-DD`), initial severity (`Medium` by default), and author name.
   - Set the initial status to `Investigating`.

4. **Update Repository Index:**
   - Check if `docs/incidents/README.md` exists. If not, initialize it with the index table header:

     ```markdown
     # Root Cause Analysis (RCA)

     This directory contains the root cause analyses recorded for system incidents.

     | ID | Title | Date | Severity | Status |
     | :--- | :--- | :--- | :--- | :--- |
     ```

   - Append the new entry row to `docs/incidents/README.md`:

     ```markdown
     | [num] | [[title]](./[num]-[title-slug].md) | [YYYY-MM-DD] | [Severity] | Investigating |
     ```

5. **Populate Incident Analysis:**
   - Fill in Summary, Timeline, Root Cause Analysis, Lessons Learned, Action Items, and Verification.

---

## RCA Lifecycle States

Every RCA must transition through defined, explicit lifecycle states:

- **Investigating:** The incident is under active investigation, or the document is currently being drafted.
- **Mitigated:** The technical impact of the incident is stopped, but the long-term permanent fix is not yet complete.
- **Resolved:** All follow-up actions, prevention plans, and verification tests have been fully completed and closed.

---

## Mandatory RCA Template Structure

All RCA markdown files (e.g., `docs/incidents/001-database-connection-exhaustion.md`) must strictly adhere to the following schema:

```markdown
# RCA XXX: [Descriptive Title]

- **Status:** [Investigating | Mitigated | Resolved]
- **Date:** [YYYY-MM-DD]
- **Severity:** [High | Medium | Low]
- **Author:** [Author Name]

## Summary

A brief overview of what happened, the impact, and the duration.

## Timeline

- **[YYYY-MM-DD HH:MM]:** Incident detected.
- **[YYYY-MM-DD HH:MM]:** Investigation started.
- **[YYYY-MM-DD HH:MM]:** Mitigation applied.
- **[YYYY-MM-DD HH:MM]:** Root cause identified.
- **[YYYY-MM-DD HH:MM]:** Permanent fix deployed.

## Root Cause Analysis

Detailed explanation of why the incident happened (The "Why").

## Lessons Learned (Optional)

What went well? What went wrong? What reduced the impact?

## Action Items

- [ ] **Fix:** Immediate technical resolution.
- [ ] **Prevention:** Changes to prevent recurrence (e.g., monitoring, tests).
- [ ] **Process:** Changes to workflows or documentation.

## Verification

- [ ] **Manual Check:**
- [ ] **Automated Tests:**
```

---

## Verification Checklist

Prior to committing a new RCA, verify that:

1. [ ] **State Specified:** The metadata section contains an allowed lifecycle state.
2. [ ] **Chronology Checked:** The next sequential integer index has been reserved by inspecting `docs/incidents/`.
3. [ ] **Root Cause Analyzed:** The technical explanation is explicitly written out to avoid superficial blame.
4. [ ] **Action Items Assigned:** Every action item in mitigation or prevention has clear, actionable definitions.
5. [ ] **Index Table Synchronized:** A corresponding row has been added to `docs/incidents/README.md`.
