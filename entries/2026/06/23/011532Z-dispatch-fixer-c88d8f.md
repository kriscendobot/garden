---
kind: dispatch
role: fixer
host: endolinbot
posture: liaison
short_id: c88d8f
dispatch_root: dispatches/fixer--c88d8f
repo: endojs/endo-but-for-bots
branch: feat/narrow-bytearray-to-uint8
pr_number: 475
model: sonnet
---

RE-DISPATCH of fixer for PR #475's review 4548978783 — the prior
fixer (short_id 11fa53) hit `API Error: Unable to connect to API
(ConnectionRefused)` after 222 tool uses and 41 minutes. No commits
landed on the branch (still at `ce8d05782` on origin).

Scope narrowed for retry: address the **9 named inline asks
literally**, then **report** any broader cross-applications you
identify in the summary comment — don't expand silently. If the
literal 9 asks complete cleanly, a follow-up dispatch can cover
the broader sweep.

Direction (unchanged from prior dispatch brief):
- `@endo/bytes` deals EXCLUSIVELY in mutable Uint8Array (strict).
- `@endo/pass-style/*-bytes.js` must not copy when the operation
  is read-only.
- Cross-applications: list, don't apply silently.
