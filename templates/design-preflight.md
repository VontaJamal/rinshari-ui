# Design Preflight

Before UI/UX work in downstream repos, complete all of the following:

1. Scan the repository for animation and motion-related implementation first (CSS keyframes/transitions, JS/TS animation libraries, timing tokens, motion utility files, animation tests, and reduced-motion handling).
2. For each proposed flourish or motion change, map the intended UX outcome (delight, orientation, comprehension, or feedback) and state why that outcome matters for user behavior.
3. Verify reduced-motion behavior for each motion pattern and document fallback behavior when users prefer less motion.
4. Summarize what exists, what must be preserved, and what conflicts with the intended change before proposing UI/UX edits.
5. Read relevant docs in `design/rinshari-ui/principles/`.
6. Read local `docs/site-soul-brief.md`.
7. Declare AI intent: where AI is used, why AI is needed, and why non-AI execution is insufficient; if AI is not used, state that explicitly.
8. Declare AI data boundaries: no raw secrets, credentials, or sensitive user data to external AI systems, with redaction/abstraction method when AI is used.
9. Define AI reliability controls: validation method, confidence limits, and fallback/manual behavior.
10. State intended visual/UX effect and how it supports user goals and product/value outcomes.
11. Identify one accessibility risk and mitigation.
12. In PR/task output, include:
   - Applied principles
   - Site Soul alignment
   - Animation audit summary (files checked + keep/change decisions)
   - Motion intent map (effect -> user goal -> reduced-motion fallback -> expected value outcome)
   - AI intent map (task -> value hypothesis -> data class -> validation -> fallback)
