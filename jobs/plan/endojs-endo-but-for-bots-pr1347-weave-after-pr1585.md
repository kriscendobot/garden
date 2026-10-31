---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1585
priority: normal
posted_by: producer
posted_at: 2026-10-31T18:58:23Z
---

---
role: weaver
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Weave endojs/endo-but-for-bots PR https://github.com/endojs/endo-but-for-bots/pull/1347 (M3 gateway draft "feat(gateway): register per-user daemons with the host gateway", head `build/endo-gateway`, currently on frozen base `llm-9a14ddf`) onto a fresh snapshot of llm, so it picks up the stage3-math asinh/acosh ubuntu-26.04 libm fix from https://github.com/endojs/endo-but-for-bots/pull/1585. Keep the PR's scope unchanged (packages/gateway + changeset + yarn.lock only). Then confirm that `test-ironhorse-oracle` and `ironhorse-oracle-sanitizers` go green on the new head, along with the rest of CI.

Context: fixer job fix-endojs-endo-but-for-bots-pr1347-ci found that both oracle reds are the inherited corpus 054/055 drift (`Math.asinh(1.7)` / `Math.acosh(2.3)` over-acceptance in corpus_conversion_equivalence and generated_multi_crank). No PR code causes them. The PR runs the oracle lanes only because its yarn.lock change counts as a shared-JS input in scripts/ci-changes.py. If https://github.com/endojs/endo-but-for-bots/pull/1585 is closed instead of merged, check what replaced it on llm before weaving.
