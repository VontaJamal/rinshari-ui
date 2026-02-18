# Changelog

All notable changes to `rinshari-ui` are tracked here.

## [Unreleased]
- Canonized per-saint `Script (AI Laws)` blocks across the Seven Saints doctrine with a Commander-level AI framing rule: AI is a force multiplier under discipline, not judgment replacement.
- Added strict AI boundary law to doctrine enforcement (`No raw secrets, credentials, or sensitive user data to external AI systems.`) and wired it into baseline validators.
- Updated `templates/design-preflight.md` and `governance/checklist.md` with mandatory AI intent, data handling, validation, and fallback requirements.
- Expanded downstream bootstrap PR contracts and generated `design-preflight-check.yml` enforcement with required AI declaration sections and AI-used gating.
- Updated Seven Saints principle, talk playbook, README framing, and lesson evidence to reflect pragmatic AI guardrails across all saint scripts.
- Migrated canonical doctrine from Five Saints to Commander-led Seven Saints, adding `Saint of Scales` and `Saint of Value` while keeping Monarch authority separate from saint domains.
- Updated Saint of Aesthetics doctrine and design preflight contract to treat whimsical flourishes/animation as first-class only when tied to UX outcomes, reduced-motion behavior, and value impact.
- Added `principles/001-seven-saints-system.md` and indexed it as a promoted cross-repo principle.
- Added `playbooks/seven-saints-system-talk.md` as a reusable narrative and contracting artifact for downstream teams.
- Added lesson evidence card `ingestion/lessons/2026-02-18-seven-saints-system.md` to document claims, evidence, a11y implications, and promotion trail.
- Updated governance checklist with a required gate linking motion/flourish decisions to user and product/value outcomes.
- Restored canonical baseline management assets (`templates/agents-baseline-doctrine.md`, `ops/sync-agents-baseline.sh`, `.github/workflows/agents-baseline-check.yml`) on the active doctrine branch.
- Upgraded the canonical `CORE-DOCTRINE` to Five Saints plus a mandatory engineering baseline: TypeScript-by-default, strict typing discipline, controlled `any`, Zod boundary validation, and Python exception policy with Pydantic.
- Extended `ops/sync-agents-baseline.sh` with `--repos`, `--skip-dirty`, and `--branch`; default write behavior now skips dirty repos and auto-switches clean non-`codex/*` repos to `codex/agents-ts-zod-baseline`.
- Added `/Users/vonta/Documents/Code Repos/agent-orchestration-lab` to baseline sync targets.
- Expanded downstream bootstrap PR template and CI checks to require engineering baseline compliance declarations and rationale.
- Strengthened preflight and governance guidance to require an animation-first repository audit before UI/UX changes, plus explicit animation audit reporting in downstream PR/task output.
- Updated downstream bootstrap automation so managed AGENTS/PR templates and design-preflight CI checks require a non-empty animation audit summary section.
- Added `principles/` with foundational seed principle (`principles/000-foundations.md`) and index entry to restore downstream contract.
- Bootstrap repository structure, governance templates, and automation scripts.
