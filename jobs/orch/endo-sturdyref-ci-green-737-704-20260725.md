---
order: serial
children: endojs-endo-but-for-bots-pr737-ci-green-20260725 endojs-endo-but-for-bots-pr541-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr698-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr700-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr701-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr702-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr703-ci-green-cascade-20260725 endojs-endo-but-for-bots-pr704-ci-green-cascade-20260725
on-child-failure: halt
state: running
created_by: gardener
created_at: 2026-07-25T03:29:20Z
---

# orchestration: SturdyRef stack CI-green cascade (#737 → #704), 2026-07-25

The whole restacked SturdyRef stack is red on CI while base llm is green:
lint (tsconfig.composite drift) + zizmor (stale action-pin version comments)
fail from #737 up; real test failures from #700 up. Serial bottom-up: fix the
stack-wide static failures at #737 first, then rebase each successor onto its
moved predecessor and drive its residuals green. Halt on child failure and
surface. Posted by the hourly sturdyref press-driver
(endo-sturdyref-press-20260724-105003).
