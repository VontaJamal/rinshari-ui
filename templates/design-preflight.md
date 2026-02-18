# Design Preflight

Before UI/UX work in downstream repos, complete all of the following:

1. Scan the repository for animation and motion-related implementation first (CSS keyframes/transitions, JS/TS animation libraries, timing tokens, motion utility files, animation tests, and reduced-motion handling).
2. Summarize what exists, what must be preserved, and what conflicts with the intended change before proposing UI/UX edits.
3. Read relevant docs in `design/rinshari-ui/principles/`.
4. Read local `docs/site-soul-brief.md`.
5. State intended visual/UX effect and how it supports user goals.
6. Identify one accessibility risk and mitigation.
7. In PR/task output, include:
   - Applied principles
   - Site Soul alignment
   - Animation audit summary (files checked + keep/change decisions)
