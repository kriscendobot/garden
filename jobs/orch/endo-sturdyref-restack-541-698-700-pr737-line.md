---
order: serial
children: endojs-endo-but-for-bots-pr541-restack-pr737-line endojs-endo-but-for-bots-pr698-restack-pr737-line endojs-endo-but-for-bots-pr700-restack-pr737-line
on-child-failure: halt
state: running
created_by: endo-sturdyref-press-20260722-095006
created_at: 2026-07-22T13:58:55Z
---

# orchestration: restack the sturdyref stack (#541 → #698 → #700) onto the arbitrated #774→#737 line

Maintainer arbitration (kriskowal, 2026-07-22T06:27Z on
https://github.com/endojs/endo-but-for-bots/pull/737): standalone
`@endo/sturdyref` shim home (#774), marshal rank prefix `l`; #737 was rebased
onto #774 and its GitHub base changed — modeling RESTACK (not fold) for the
stack shape. This orchestration applies the same shape downstream, replacing
the stale closed-#521 foundation (`build/sturdyrefs-pass-style-ocapn`) with
the new line: llm ← #774 ← #737 ← #541 ← #698 ← #700. Serial, halt on child
failure (each child rebases onto the branch the previous child moved).
Restacking preserves PR identities, so a later fold remains possible if the
maintainer prefers it at merge time. Posted by the sturdyref press-driver
(endo-sturdyref-press-20260722-095006).
