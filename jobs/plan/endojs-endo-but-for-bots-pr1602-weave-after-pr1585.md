---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1585
priority: normal
posted_by: producer
posted_at: 2026-11-01T07:16:53Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR https://github.com/endojs/endo-but-for-bots/pull/1602 (head `ironhorse-test262-ratchet-resource-disposal-20261101`, currently on frozen base `llm-9a14ddf`) onto a fresh snapshot of llm, so it picks up the stage3-math asinh/acosh ubuntu-26.04 libm fix from https://github.com/endojs/endo-but-for-bots/pull/1585. Then confirm that `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` go green on the new head, along with the rest of CI, and re-run the PR's gauntlet (run the gauntlet #1602).

Context: gauntlet-clean job endojs-endo-but-for-bots-pr1602-gauntlet-clean found coverage clean (nothing to push). Its only CI reds were the base-level corpus 054/055 libm drift (`Math.asinh(1.7)`, `Math.acosh(2.3)` last-digit) and a macOS `daemon http-content-plane.test.js` flake. If https://github.com/endojs/endo-but-for-bots/pull/1585 is closed instead of merged, check what replaced it on llm before weaving.
