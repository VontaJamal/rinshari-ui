# rinshari-ui

`rinshari-ui` is the central design source of truth for shared UI/UX principles, patterns, and governance used across VontaJamal repositories.

## Purpose
- Preserve principle-first design guidance.
- Keep implementation adaptable to each product's soul and audience.
- Enable deterministic agent preflight for UI/UX work.

## Public Contracts
- `templates/lesson-card.md`: canonical ingestion card for course learnings.
- `templates/design-preflight.md`: required preflight checklist for design tasks.
- `templates/site-soul-brief.md`: required local brand brief template per downstream repo.
- `governance/checklist.md`: quality gate for principle updates.

## Downstream Integration
Downstream repositories should include this repo as a submodule at `design/rinshari-ui` and enforce preflight via:
- local `AGENTS.md` policy block,
- PR template required fields,
- CI workflow check.

## Content Policy
This is a **paraphrase-only** repo for course-derived material.
- Do not store full transcripts.
- Do not store raw video clips.
- Store distilled principles with source traces.

## Scripts
- `ops/bootstrap-downstream.sh`: bootstrap downstream repos and open setup PRs.
- `scripts/new-lesson-draft.sh`: generate a lesson-card draft from metadata + paraphrased claims.
