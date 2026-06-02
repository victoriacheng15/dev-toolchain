---
name: rca-gen
description: Guides the creation and management of Root Cause Analysis (RCA) records with chronological indexing.
---

# Root Cause Analysis (RCA)

## Overview

Root Cause Analysis (RCA) is a structured process to identify the underlying vulnerabilities that caused a system failure or incident. This skill standardizes the lifecycle of RCAs, ensuring that we learn from every failure, document technical debt, and prevent regression through systemic, architectural improvements.

---

## Automated Execution

To create a new, auto-incremented RCA skeleton, execute the companion template generator from the root of the workspace:

```bash
./rca-gen/new-rca.sh "Title of the Incident"
```

This script scans the `docs/incidents/` directory, detects the next sequential ID, and generates a pre-formatted template with standard metadata headers.

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
2. [ ] **Chronology Checked:** The next sequential integer index has been reserved using the orchestration script.
3. [ ] **Root Cause Analyzed:** The technical explanation is explicitly written out to avoid superficial blame.
4. [ ] **Action Items Assigned:** Every action item in mitigation or prevention has clear, actionable definitions.
