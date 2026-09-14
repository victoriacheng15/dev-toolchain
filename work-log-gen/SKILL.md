---
name: work-log-gen
description: Guides the creation and incremental logging of high-signal engineering contributions, PRs, and architectural notes per project or workplace.
version: 1.0.0
license: MIT
inputs:
  project_name:
    type: string
    description: The name of the target project, repository, or organization.
    required: true
  action:
    type: string
    description: "The action to perform: 'init' to scaffold a new log, or 'log' to append a new milestone entry."
    required: false
    default: "log"
outputs:
  - "work-log-[project_name].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Work Log Generator

## Overview

Maintaining a work log (also known as a brag document or contribution tracker) is a core engineering practice. This skill manages a single living document per project or workplace (`work-log-[project-name].md`) to record high-impact milestones, pull requests, complex debugging, and architectural decisions for open-source contributions or internal corporate work.

---

## Execution Workflows

Execution is divided into two distinct procedural workflows:

### Part 1: Initial Scaffolding Workflow (New Project)

When starting work on a new repository, open-source project, or company workplace:

1. **Resolve File Name:**
   - Format the target path as `work-log-[project-name].md` in the workspace root, where `[project-name]` is lowercased and hyphenated.
   - If the file already exists, switch to **Part 2: Incremental Logging Workflow**.

2. **Scaffold Log File:**
   - Create the file using the mandatory template schema below.
   - Populate header metadata:
     - **Repository:** Upstream or repository URL.
     - **Focus Areas:** Subsystems or packages worked on (e.g., Core controllers, API schemas, UI components).
     - **Primary Tech:** Language stack and frameworks (e.g., Go, TypeScript, React, Kubernetes).

3. **Initialize Active Year:**
   - Determine the active calendar year from the current date.
   - Insert the current year header (`## [YYYY]`), `### Key Highlights`, and `### Epics & Major Initiatives` at the top of the initiatives section.

---

### Part 2: Incremental Logging Workflow (Adding New Work)

When logging a newly merged PR, triaged issue, code review, or technical learning:

1. **Filter for High Signal (Context-Specific Rules):**
   Evaluate the contribution against the active environment before logging:
   - **Open Source Contribution Context:**
     - *Include:* Substantive bug fixes, root-cause investigations, race condition resolutions, CI and build pipeline stabilization (fixing flaky tests, unblocking releases), feature implementations, API contract improvements, and architectural documentation.
     - *Exclude:* Trivial typos in documentation, automated dependency bumps (Dependabot/Renovate) with no migration logic, pure styling or formatting changes (`gofmt`, `prettier`), or routine comment edits.
   - **Workplace / Corporate Context:**
     - *Include:* Business-critical features, revenue-impacting fixes, SLA improvements, cross-team service integrations, incident firefighting and postmortem follow-ups, reliability and scale hardening, security and compliance updates, and operational migrations (e.g., secret rotation, fleet upgrades).
     - *Exclude:* Routine daily rebases, merge commits, mechanical dependency bumps without code adaptation, or trivial syntax tweaks.

2. **Group by Epic (Multi-PR Initiatives at Year Level):**
   - An **Epic** is an initiative or feature that spans multiple pull requests (e.g., migrating a storage layer, implementing OAuth2, or introducing end-to-end telemetry).
   - Rather than scattering 4 or 5 isolated micro-PRs across the master PR list, group them under an Epic entry in `## [YYYY]` -> `### Epics & Major Initiatives`.
   - When writing an Epic entry:
     - **Related PRs:** List all constituent PR numbers with their individual scope (e.g., `#315 (Schema)`, `#332 (Core logic)`, `#340 (Telemetry)`).
     - **Problem / Context (Why):** Explain the systemic constraint, user need, or architectural bottleneck requiring a multi-PR effort.
     - **Architecture & Migration (What):** Summarize cross-package changes, migration paths, and rollout safeguards (e.g., canary deployments, feature flags).
     - **Key Decisions / Trade-offs:** Document design alternatives evaluated, trade-offs accepted, and technical consensus reached.
     - **Outcome / Impact:** Record measurable reliability, performance, or capability outcomes.

3. **Insert Milestone Entry (Descending Numerical Ordering into Master Lists):**
   - **Pull Requests:** Insert into the flat `## Pull Requests` master list, ordered strictly descending by PR number (`### PR #[High]` before `### PR #[Low]`).
   - **Issues & Triage:** Insert into the flat `## Issues & Triage` master list, ordered strictly descending by Issue number (`### Issue #[High]` before `### Issue #[Low]`).
   - Capture required fields per entry:
     - **Pull Requests:** PR number, title, link, status, Problem/Context (Why), Implementation (What), and Key Decisions / Trade-offs.
     - **Issues & Triage:** Issue number, title, link, status, and root cause summary.
     - **Code Reviews & Community Discussions:** PR/issue link, author username, and technical input provided.
     - **Architectural & Domain Notes:** System invariants, failure modes, or lessons learned.

---

## Mandatory Log Template Structure

The log file must strictly adhere to the following schema:

````markdown
# [Project Name]

* **Repository:** [Repository URL]
* **Focus Areas:** [e.g., Core controllers, API schemas, UI components]
* **Primary Tech:** [e.g., Go, TypeScript, React, Kubernetes]

---

## [Year]

### Key Highlights
* [Top impact 1: System leverage, complexity, or measurable outcome]
* [Top impact 2: System leverage, complexity, or measurable outcome]

### Epics & Major Initiatives

#### Epic: [Feature or Multi-PR Initiative Title]
* **Related PRs:** #[Number] (Scope), #[Number] (Scope)
* **Status:** [Merged | Open | In Review]
* **Problem / Context (Why):** [Describe the systemic constraint, user need, or architecture limitation]
* **Architecture & Migration (What):** [Describe coordinated changes across services, packages, and rollout safeguards]
* **Key Decisions / Trade-offs:** [Record core trade-offs, discarded alternatives, and architectural patterns adopted]
* **Outcome / Impact:** [Record measurable performance, reliability, or capability outcome]

---

## Pull Requests

### PR #[Number] - [PR Title]
* **Link:** [PR URL]
* **Status:** [Merged | Open | In Review]
* **Problem / Context (Why):** [Describe the bug, missing feature, or contract drift]
* **Implementation (What):** [Describe technical changes, packages modified, and tests added]
* **Key Decisions / Trade-offs:** [Note any architectural debates, reviewer feedback, or design alternatives]

---

## Issues & Triage

### Issue #[Number] - [Issue Title]
* **Link:** [Issue URL]
* **Status:** [Open | Closed]
* **Summary / Root Cause:** [Describe the problem identified or investigated]

---

## Code Reviews & Community Discussions

* **PR / Issue #[Number] (Author: [Username])**
  * **Link:** [URL]
  * **Input Provided:** [Summary of technical feedback, edge cases caught, or verification done]

---

## Architectural & Domain Notes

* **[Topic / Area]:** [Key system invariant, API stability note, failure mode, or lesson learned]
````

---

## Verification Checklist

Prior to completing a work log update, verify that:

1. [ ] **Consolidated File:** The entry is added to the single project log file (`work-log-[project-name].md`).
2. [ ] **Signal Verified:** Evaluated against the appropriate Open Source or Workplace filtering criteria.
3. [ ] **Numeric Ordering Preserved:** Standalone pull requests and issues are strictly ordered descending by number in their respective master lists.
4. [ ] **Epics Scoped to Year:** Multi-PR initiatives are unified under `## [Year]` -> `### Epics & Major Initiatives` with constituent PR roles and architectural outcomes documented.
5. [ ] **Rationale Captured:** Pull request and epic entries explain the "Why" (root cause and architectural trade-offs) rather than merely listing file diffs.
