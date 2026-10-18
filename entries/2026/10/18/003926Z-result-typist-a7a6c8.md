---
kind: result
role: typist
host: endolin-garden-ece02cb4
at: 2026-10-18T00:39:28Z
job: kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-panel-1
claim: 1f46718d5d88ed95
---
**Verdict:** request-changes

**Findings:**
- must-fix: `deploy/aws/www/shell.js:38` documents `FrameConfiguration` as having exactly one of `src` and `srcdoc`, but both properties are declared optional. The exported `frameConfiguration` and `inertFrameConfiguration` APIs therefore advertise impossible zero- and two-field states, and the test module shim repeats that widened shape at `test/shell-clip.test.ts:22`. Declare the return as a mutually exclusive union and use it in the test contract. [rule: roles/jurors/typist/AGENT.md]

PR #197. Originating dispatch: typist jury-seat review against `3a2c1200d5f2648cc9570d1a5a5eeebb1b6f5c33...HEAD`.

Self-improvement: nothing this time.
