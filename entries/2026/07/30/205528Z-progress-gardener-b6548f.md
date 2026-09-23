---
kind: progress
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-30T20:55:29Z
---
SturdyRef press tick endo-sturdyref-press-20260730-203502: rebased both stale design PRs onto current llm; the code stack and #871 gauntlet remain maintainer-gated.

## What I did (real execution)

Rebased design PRs #511 and #539 from their stale base `llm-65b0abe` (953 commits behind current `llm` at `eb64412d76`) onto current `llm`, and updated both PR bases from `llm-65b0abe` to `llm`. Both are now MERGEABLE (verified via `gh pr view --json mergeable`).

- **#539** (design: on-demand enlivenment via the closely-held OCapN network capability): force-pushed `e1f5435722` to `design/sturdy-refs-endor-syscall-followup`; base changed to `llm`; `mergeable=MERGEABLE`. README conflict resolved (the "Recently added or revised" index entry for `sturdy-refs-ocapn-enlivenment` replacing the withdrawn `sturdy-refs-endor-syscall` entry; summary table row already applied). All 5 review threads from kriskowal's 2026-06-26 CHANGES_REQUESTED were addressed in prior commits (`aa104684c`, `4537e4a5c`, `22923949b2`) and remain intact.
- **#511** (design: sturdy-refs pass-style + FinalizationRegistry-tracked worker retention): force-pushed `648a10e75a` to `design/sturdy-refs-via-finalization-registry`; base changed to `llm`; `mergeable=MERGEABLE`. README table conflict resolved (kept both the `pass-style-promise` and `sturdy-refs-finalization-registry` rows; updated the latter's revised date to 2026-06-26 per the cross-reference commit). Both review threads from kriskowal were addressed in prior commits (`5c363f9692`, `49591efc12`, `182d0449eb`).

No design doc content was modified — only README.md conflict resolution during rebase. The design docs themselves (`sturdy-refs-ocapn-enlivenment.md` 877 lines, `sturdy-refs-finalization-registry.md` 856 lines) are byte-identical to their pre-rebase versions.

## Code stack (unchanged, verified via gh at ~20:50Z)

- **#698** (bridge cut 1, bytes-preserving SturdyRef wire read): OPEN draft, MERGEABLE, 21/21 CI SUCCESS, zero reviews. Head `c19fdd96c`.
- **#700** (bridge cut 2, promote sturdyref URI codec + closely-held reveal): OPEN draft, MERGEABLE, zero reviews. Head `e0122dfd7`.
- **#541** (cuts 3-4, daemon SturdyRef read-side threading): OPEN draft, MERGEABLE, zero reviews, base `build/sturdyref-pass-style-ocapn-single`. Head `fd60a74b0`.
- **#871** (agent provide/accept surface, bar 2): OPEN draft, MERGEABLE, 21/21 CI SUCCESS, zero reviews. Head `c3fa894c9`.

## Blocker (unchanged)

The sole blocker remains the maintainer-gated #871 agent-surface gauntlet (`jobs/plan/endo-sturdyref-agent-surface-build-gauntlet`), parked with `gate: go-ahead` and `poisoned: true` since 2026-07-26 (4 days). The panel has never run. The last maintainer escalation was sent at 2026-07-30T07:21Z (~13h ago); no maintainer reply has arrived. This tick re-escalates.

## Confinement property statement

No project code behavior changed this tick — only design-doc rebases (markdown). The Distributed Confinement invariants stand as last exercised by the green CI heads: no-location (passStyleOf-opaque sturdyref; enliven mediated by the closely-held OCapN network capability per design #539), no-identification (unlinkable per-guest mints), opaque-and-unforgeable. #871 carries the agent-surface guard/escrow regression tests in its 21/21 CI rollup; #541 carries the daemon-side confinement suite (10/10: no readable locator/swiss number, no readable off-band id, no forged-token resolution, identity-keyed resolution). Not re-run locally this tick; bars rest on the CI evidence cited above.

## Follow-ups

- Next tick: watch for maintainer reply on the #871 gauntlet go-ahead. If promoted out of `jobs/plan/`, observe without colliding (the pool claims it).
- #511 and #539 are now mergeable onto llm but remain DRAFT with addressed-but-unresolved review threads; they need a maintainer re-review/merge decision.
- The bridge cuts #698/#700 and #541 are green and mergeable but unreviewed — also maintainer-gated for merge.
