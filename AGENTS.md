# AGENTS.md

## Mission
Use this repository as the shared UI/UX knowledge base across products.

Primary goal:
- turn incoming design learning into reusable principles and patterns.

Secondary goal:
- keep each product's local identity intact through downstream Site Soul Briefs.

## What To Update
When adding new learning:
1. Create or update a lesson card in `ingestion/lessons/`.
2. Promote stable insights into `principles/` and optionally `patterns/`.
3. Record notable updates in `CHANGELOG.md`.
4. Add/refresh `INDEX.md` entries when new docs are introduced.

## Required Content Rules
- Paraphrase-only for course-derived material.
- Never paste full transcript blocks.
- Never commit raw video clips or full lesson exports.
- Include source traces for promoted principles.

## Promotion Standard
Before promoting a lesson insight into a principle:
1. Ensure at least one evidence item exists (transcript paraphrase or concrete example).
2. Ensure intended UX effect is explicit.
3. Ensure at least one accessibility implication is noted.
4. Ensure at least one failure mode/anti-pattern is documented.
5. Validate against `governance/checklist.md`.

## Downstream Awareness
This repo is consumed as a submodule at `design/rinshari-ui` in downstream repos.

When changing shared guidance:
1. Keep guidance principle-first, not overfitted to one project.
2. Avoid assumptions that conflict with local `docs/site-soul-brief.md` files.
3. Write updates so downstream agents can cite applied principles in PRs.

Before downstream UI/UX edits:
1. Perform a repository-wide animation/motion audit first.
2. Resolve animation implications before visual layout/styling changes.
3. Explicitly report animation files checked and keep/change decisions in task or PR output.

## File/Schema Contracts
- Lesson card schema: `templates/lesson-card.md`
- Design preflight contract: `templates/design-preflight.md`
- Site soul template: `templates/site-soul-brief.md`

Do not break these contracts without updating templates and README in the same change.
