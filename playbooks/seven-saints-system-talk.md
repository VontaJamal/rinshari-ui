# Seven Saints System Talk

## Talk Goal
Present the Double Rinnesharingan doctrine as a practical operating system for expert UI/design software development: high capability, deliberate focus, and measurable outcomes.

## Core Framing
- The Protagonist Commander (Monarch authority) is separate from saints and resolves doctrine conflicts.
- The Seven Saints are governance domains that make execution predictable across repositories.
- Orchestration is interleaved across all saint domains and directed by Commander authority.
- Whimsical flourishes and animation are powerful only when they improve user outcomes and respect accessibility.

## Seven Saints Script
1. Saint of Aesthetics
   Steward visual identity, interaction clarity, and purposeful motion. Flourishes are welcome when they improve delight, comprehension, and retention.
   Script (AI Laws):
   - Use AI for concepts/prototypes only when a defined UX outcome exists.
   - Require each AI-generated flourish to map to clarity, delight, or retention.
   - Do not ship AI-generated visual/motion artifacts without accessibility and reduced-motion validation.
2. Saint of Security
   Protect trust boundaries, inputs, secrets, and release posture.
   Script (AI Laws):
   - No raw secrets, credentials, or sensitive user data to external AI systems.
   - Redact or abstract prompts and attachments before model exposure.
   - Treat AI output as untrusted input and run standard security review.
3. Saint of Accessibility
   Enforce WCAG 2.2 AA, keyboard-first behavior, semantic correctness, and reduced-motion compliance.
   Script (AI Laws):
   - AI can assist accessibility audits/content drafting but cannot be sole validator.
   - Validate keyboard, screen-reader, and reduced-motion behavior independently.
   - Review AI-generated alt text and labels for context accuracy.
4. Saint of Testing
   Validate behavior first through E2E and integration coverage with critical unit tests where deterministic logic requires it.
   Script (AI Laws):
   - AI-drafted tests must remain behavior-first and user-outcome focused.
   - Human review is required to remove brittle or misleading generated tests.
   - Keep deterministic assertions for critical flows even with AI-assisted implementation.
5. Saint of Execution
   Deliver on codex feature branches, run autonomously, and finish with a clean tree.
   Script (AI Laws):
   - AI can automate planning/implementation steps, but accountability stays human-owned.
   - Never claim completion based only on AI output without verification.
   - Branch hygiene and clean-tree completion gates remain mandatory.
6. Saint of Scales
   Right-size complexity. Build simple when simple is enough, and scale hard when growth and constraints demand it.
   Script (AI Laws):
   - AI may propose architecture/capacity options, but final topology is requirement-driven.
   - Choose minimal viable complexity first.
   - Increase complexity only when measured constraints justify it.
7. Saint of Value
   Balance user delight and product outcomes so design quality also drives adoption, retention, and revenue sustainability.
   Script (AI Laws):
   - Tie AI usage to user value and business value hypotheses.
   - Require measurable success signals for AI-enabled features.
   - Define fallback/manual behavior for degraded model performance in every AI-assisted user flow.

## Doctrine-to-Practice Mapping
- Discovery: run motion/animation audit first before any UI/layout change.
- Design: map each visual flourish to a user goal and expected value impact.
- Delivery: cite applied principles and Saint domains in PR/task output.
- Validation: include reduced-motion behavior, accessibility risks, and mitigation.

## Contracting Language
Use this contract sentence in planning docs or PRs:
"This change operates under Commander authority and satisfies the Seven Saints by linking aesthetics to UX outcomes, scales to complexity fit, and value to product impact."

## Downstream Usage
1. Read `design/rinshari-ui/templates/design-preflight.md`.
2. Read relevant `design/rinshari-ui/principles/*` docs.
3. Align with local `docs/site-soul-brief.md`.
4. Report animation files checked and keep/change decisions before visual implementation.
