# 🛠️ Dev Toolchain

The **Dev Toolchain** is a portable library of standardized engineering skills and automation workflows for AI coding agents.

Built on the open `SKILL.md` specification, it replaces ad-hoc conversational prompting with declarative, deterministic execution rules. The toolchain enforces strict engineering hygiene across any LLM client: staging and commit discipline, immutable Architectural Decision Records (ADRs), table-driven unit test generation, and structured incident post-mortems.

---

## 🛠️ Available Skills

The toolchain organizes skills across four core phases of the engineering lifecycle:

### 📐 Architecture & Planning

| Skill | Directory | Primary Purpose | Status |
| :--- | :--- | :--- | :--- |
| **ADR Generator** | [`adr-gen/`](adr-gen/SKILL.md) | Standardizes architectural pivots and trade-off matrices with immutable indexing. | **Active** |
| **Plan Generator** | [`plan-gen/`](plan-gen/SKILL.md) | Scaffolds a local execution plan template to sequence PRs and prevent goal drift. | **Active** |

### 🧪 Quality & Testing

| Skill | Directory | Primary Purpose | Status |
| :--- | :--- | :--- | :--- |
| **Code Review Auditor** | [`fresh-eye/`](fresh-eye/SKILL.md) | Performs pre-commit code quality, safety, and test coverage sanity audits on local diffs. | **Active** |
| **Tests Generator** | [`tests-gen/`](tests-gen/SKILL.md) | Scaffolds language-specific, table-driven unit test suites without external AST dependencies. | **Active** |

### 🚀 Delivery & Review

| Skill | Directory | Primary Purpose | Status |
| :--- | :--- | :--- | :--- |
| **Commit Prepper** | [`prepare-commit/`](prepare-commit/SKILL.md) | Enforces staging hygiene, repository state audits, and drafts semantic commit specs. | **Active** |
| **PR Review & Verification** | [`pr-review/`](pr-review/SKILL.md) | Compares diffs against a base branch, verifies tests and builds, and drafts review reports. | **Active** |
| **Work Log Generator** | [`work-log-gen/`](work-log-gen/SKILL.md) | Guides the incremental logging of engineering contributions, PRs, and architectural notes. | **Active** |

### 🔍 Operations & Incident Triage

| Skill | Directory | Primary Purpose | Status |
| :--- | :--- | :--- | :--- |
| **Issue Triage Generator** | [`triage-gen/`](triage-gen/SKILL.md) | Scaffolds local reproduction, fix, and verification tracking for upstream issues. | **Active** |
| **RCA Generator** | [`rca-gen/`](rca-gen/SKILL.md) | Standardizes incident post-mortem documentation and timelines under `docs/incidents/`. | **Active** |

---

## 🔄 Orchestration Flow: Lifecycle of a Skill

```text
                  [ Code changes initiated ]
                             │
                             ▼
              [ AI agent loads SKILL.md manual ]
                             │
                             ▼
              [ Executes task constraints ]
                             │
                             ▼
              [ Verification & Linting Gate ]
                 │                       │
              (Pass)                  (Fail)
                 │                       │
                 │                       ▼
                 │                [ Fix & Retry ]
                 ▼
      [ Clean, compliant state ]
```
