# Changelog

All notable changes to `rinshari-ui` are tracked here.

## [Unreleased]
- Restored canonical baseline management assets (`templates/agents-baseline-doctrine.md`, `ops/sync-agents-baseline.sh`, `.github/workflows/agents-baseline-check.yml`) on the active doctrine branch.
- Upgraded the canonical `CORE-DOCTRINE` to Five Saints plus a mandatory engineering baseline: TypeScript-by-default, strict typing discipline, controlled `any`, Zod boundary validation, and Python exception policy with Pydantic.
- Extended `ops/sync-agents-baseline.sh` with `--repos`, `--skip-dirty`, and `--branch`; default write behavior now skips dirty repos and auto-switches clean non-`codex/*` repos to `codex/agents-ts-zod-baseline`.
- Added `/Users/vonta/Documents/Code Repos/agent-orchestration-lab` to baseline sync targets.
- Expanded downstream bootstrap PR template and CI checks to require engineering baseline compliance declarations and rationale.
- Strengthened preflight and governance guidance to require an animation-first repository audit before UI/UX changes, plus explicit animation audit reporting in downstream PR/task output.
- Updated downstream bootstrap automation so managed AGENTS/PR templates and design-preflight CI checks require a non-empty animation audit summary section.
- Added `principles/` with foundational seed principle (`principles/000-foundations.md`) and index entry to restore downstream contract.
- Bootstrap repository structure, governance templates, and automation scripts.
