# rinshari-ui

`rinshari-ui` is the central UI/UX design guide for VontaJamal repositories.

It exists to capture reusable design principles, not one-size-fits-all templates, so each product can keep its own identity while still sharing quality standards.

## Identity Frame
- `rinshari-ui` is the Double Rinnesharingan doctrine hub: broad capability with deliberate focus.
- Governance runs through a separate Protagonist Commander (Monarch authority) and the Seven Saints system.
- Orchestration is interleaved through Commander authority and Shared Operating Law instead of being a standalone saint.
- Under Saint of Aesthetics, whimsical flourishes and animation are first-class only when they improve UX outcomes like delight, comprehension, usability, and retention.
- Every saint now includes a `Script (AI Laws)` section to enforce pragmatic AI leverage: use AI heavily when useful, never by default, and always under safety and validation constraints.

## Purpose
- Maintain a principle-first design knowledge base.
- Translate learning inputs into durable guidance agents can apply.
- Keep accessibility, hierarchy, and interaction quality explicit.
- Support deterministic design preflight across downstream repos.

## Agent Entry Points
- Start with `AGENTS.md` in this repo for operating rules.
- Use `templates/lesson-card.md` for new lesson ingestion.
- Use `governance/checklist.md` before promoting or updating principles.

## Repository Structure
- `principles/`: stable principle docs used across products.
- `patterns/`: implementation patterns derived from principles.
- `playbooks/`: repeatable workflows for application.
- `ingestion/lessons/`: draft/promoted lesson cards from incoming material.
- `decision-log/`: major design-system decisions and rationale.
- `templates/`: required templates for ingestion and downstream use.
- `governance/`: quality and policy checks.

## Public Contracts
- `templates/lesson-card.md`: canonical schema for lesson ingestion.
- `templates/design-preflight.md`: preflight checklist downstream agents must read.
- `templates/site-soul-brief.md`: per-project identity brief template.
- `governance/checklist.md`: required quality gate for principle updates.

## Content Policy
This is a paraphrase-only repo for course-derived material.
- Do not store full transcripts.
- Do not store raw clips or full lesson dumps.
- Store distilled guidance with source traces.

## Downstream Integration Model
- Downstream repos mount this repo as submodule path `design/rinshari-ui`.
- Agents in downstream repos must read:
  - `design/rinshari-ui/templates/design-preflight.md`
  - relevant `design/rinshari-ui/principles/*`
- local `docs/site-soul-brief.md`
- New guidance reaches downstream repos when the submodule pointer is bumped and merged.

## Agents Baseline Enforcement
- Canonical `CORE-DOCTRINE` content is sourced from `templates/agents-baseline-doctrine.md`.
- Canon doctrine is Commander-led Seven Saints governance with Saint of Scales and Saint of Value included.
- Canon doctrine requires per-saint `Script (AI Laws)` with strict external AI data boundaries and explicit validation/fallback rules.
- TypeScript is the default language baseline for new implementation work.
- TypeScript strict mode and Zod boundary validation are required in TypeScript repos.
- Python is a pre-approved exception with required Pydantic boundary validation.
- Any non-TypeScript/non-Python language requires owner-approved exception plus a local `Language Exception Record`.

Baseline commands:
```bash
# Validate baseline drift across default repos
ops/sync-agents-baseline.sh --check

# Write baseline to default repos (skips dirty repos by default)
ops/sync-agents-baseline.sh --write

# Target specific repos
ops/sync-agents-baseline.sh --write --repos "/path/repoA,/path/repoB"

# Override dirty-repo behavior or branch name
ops/sync-agents-baseline.sh --write --skip-dirty false --branch codex/custom-baseline-sync
```

## Automation Scripts
- `ops/bootstrap-downstream.sh`: bootstraps submodule + policy files + workflows in downstream repos.
- `ops/sync-agents-baseline.sh`: manages and validates the canonical `CORE-DOCTRINE` baseline across repositories.
- `scripts/new-lesson-draft.sh`: creates lesson-card drafts from paraphrased claims and evidence metadata.
