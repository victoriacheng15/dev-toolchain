---
name: contribute-triage
description: Guides the agent to resolve an upstream issue using a local issue-[num].md file tracking reproduction, fix, and verification states.
version: 1.0.0
license: MIT
inputs:
  issue_number:
    type: integer
    description: The target GitHub issue number.
    required: true
  issue_title:
    type: string
    description: The raw title of the issue.
    required: true
outputs:
  - "issue-[issue_number].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Open Source Contributor Triage

## Overview

Contributing to open-source repositories requires systematic triage, local bug reproduction, code implementation, and compliance with upstream project standards. This skill automates the tracking of this process in a single, local, non-committed `issue-[num].md` file in the workspace root.

---

## Automated Execution Workflow

When triaging a new issue, the AI agent must:

1. Identify the GitHub issue number (e.g., `452`) and title.
2. Execute the script from the root of the workspace to bootstrap the template:

```bash
./contribute-triage/contribute-triage.sh "ISSUE_NUM" "ISSUE_TITLE"
```

1. Progressively edit the metadata header (Issue Link, PR Link, Target Branch, Subsystem) and complete the generated `issue-[num].md` file's three core sections as the lifecycle advances.

---

## State Sections in `issue-[num].md`

The generated file contains three core sections. The agent must populate them with the following detailed items:

* **Bug Repro**
  * **Failure Analysis:** A description of the observed bug or incorrect behavior.
  * **Reproduction Steps:** A checklist of manual or automated steps, including the exact command executed to trigger the failure.
  * **Failure Output:** A code block containing the raw compiler error, stack trace, or failure logs.
* **Fix**
  * **Goal:** A concise summary of the resolution target.
  * **Approach:** A description of the code modifications and files to be changed.
  * **Detailed Execution Checklist:** A step-by-step checklist tracking the implementation tasks.
* **Verify**
  * **Test Command:** The commands executed to verify the fix.
  * **Test Output Summary:** Logs or statistics confirming the tests passed.
  * **Upstream Compliance Checklist:** Checkboxes verifying DCO commit sign-offs (`git commit -s` if required by upstream), code style formatting, repository PR template completion, and adding/verifying that all unit/integration tests pass.
  * **Cleanup Checklist:** Checkboxes confirming removal of temporary reproduction scripts, configuration files, and debug statement prints from the source.

---

## Verification Checklist

Prior to completing the triage workflow, verify that:

1. [ ] **Issue File Created:** The file `issue-[num].md` exists in the workspace root.
2. [ ] **Reproduction Documented:** The `Bug Repro` section contains the reproduction command and failure logs.
3. [ ] **Upstream Compliance Checked:** Commit sign-offs and linting checks are logged in `Verify`.
4. [ ] **Workspace Cleaned:** All temporary reproduction stubs, scripts, and logs outside of source modifications are removed.
