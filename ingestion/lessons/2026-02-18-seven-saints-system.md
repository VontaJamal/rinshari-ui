# Lesson Card: Seven Saints System Doctrine

- lesson_title: Seven Saints System Doctrine
- source_type: mixed
- source_refs:
  - /Users/vonta/Documents/Code Repos/rinshari-ui/templates/agents-baseline-doctrine.md
  - /Users/vonta/Documents/Code Repos/rinshari-ui/AGENTS.md
  - /Users/vonta/Documents/Code Repos/rinshari-ui/templates/design-preflight.md
- core_claims:
  - Commander authority is separate from saint domains and resolves principle conflicts.
  - Orchestration is interleaved across saint domains under Commander authority, not modeled as a separate saint.
  - Every saint contains a `Script (AI Laws)` so AI use is intentional, validated, and bounded by safety rules.
  - Saint of Aesthetics treats whimsical flourishes and animation as first-class only when tied to user outcomes.
  - Saint of Scales keeps architecture complexity proportional to real requirements.
  - Saint of Value balances user delight with product adoption, retention, and revenue-fit outcomes.
- ui_effect_goal: Create interfaces people love to use while preserving clarity, accessibility, and sustainable product impact.
- evidence_items:
  - Doctrine template explicitly defines Seven Saints, including Saint of Scales and Saint of Value.
  - Design preflight now requires motion intent mapping to user goals, reduced-motion fallback, and expected value outcome.
  - Doctrine and downstream contracts require strict AI boundary controls (no raw secrets/credentials/sensitive user data to external AI systems).
- do:
  - Tie every flourish to a concrete UX purpose and a measurable product outcome.
  - Scale systems deliberately based on actual growth and operational constraints.
  - Use AI when it increases leverage, with explicit validation and fallback/manual behavior.
- dont:
  - Add animation for decoration without comprehension or feedback value.
  - Overbuild architecture before demand, or underspec architecture when demand is proven.
  - Use AI by default without clear value, safe data handling, and verification.
- candidate_principles:
  - principles/001-seven-saints-system.md
- a11y_notes:
  - Provide reduced-motion alternatives and non-motion cues so critical information is never motion-only.
- promotion_status: promoted

## Notes
- Paraphrased from doctrine framing and repository policy decisions.
- Captures AI-script doctrine expansion and downstream enforcement requirements.
- Written for downstream reuse as principle evidence.
