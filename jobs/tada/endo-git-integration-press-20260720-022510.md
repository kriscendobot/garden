## Press report — git-integration / M3 loop (2026-07-20 dispatch)

**Outcome: steady-state verification pass. The entire stack is green and unchanged since the 2026-07-19T13:05Z press; every next motion remains maintainer-gated. No code changes, no merges, no comments posted, no new jobs.**

**What I verified (all via `gh pr view` / `gh pr checks` against endojs/endo-but-for-bots):**

- **#705 (Phase 1, remote push tier)** — 22 checks, 0 non-pass (run 29559833899), un-drafted, `mergeStateStatus: CLEAN`, head `76371cb1a`. The merge-directive ask (liaison message `20260717T002451Z-cb5a1b`) **still sits in `inbox/maintainer/unread/`** — confirmed directly on the journal. Per standing instruction I did not merge and did not re-send.
- **#707 (Phase 3, worked loop — M3 exit criterion)** — 23 checks, 0 non-pass (run 29561062679), CLEAN. Its frozen base `build-agent-tools-git-remote-push-tier-76371cb` still exactly matches #705's head `76371cb1a`, so the snapshot invariant holds. Weave onto `llm` stays queued behind #705's landing.
- **#708 (exo-git QID/hash)** — 26 checks, 0 non-pass at head `ce58ad49` (run 29577536714); the occasionally-flaky guile-interop check is passing, no rerun needed.
- **#740 (endor CAS bindings design)** — 5/5 checks pass at `446f8da4`; panel passed, no open threads, nothing needs design settling — no designer sub-job warranted.
- **#626 (Phase 5 stack-surgery eval, DRAFT)** — the carryover CI-pending item is resolved: head `8e29c292` (the fairness follow-up stating the exact final stack summaries) is **22/22 pass**, run [29633950169](https://github.com/endojs/endo-but-for-bots/actions/runs/29633950169). The 2026-07-18T18:37Z press already posted this verification as a PR comment, so I did not re-post. Kept DRAFT. No fixer needed.
- **#691 (sequencing design, OPEN)** — head `36c1fc49b` (the 2026-07-19 weave onto `llm` addressing the sequencing feedback), all checks pass. No new comments since; the sequencing-policy comment is not the awaited merge directive.
- **#706** MERGED, **#645** merged into `llm` — both as recorded; no drift anywhere in the stack since the prior press.

No comments arrived on any of the six PRs since 2026-07-19; my job inbox was empty at start and finish; no live peer holds any of these branches (`inbox-list` shows only unrelated jobs). The moot parked jobs (`jobs/plan/weave-endo-but-for-bots-pr626-stack-surgery-eval`, the stale #707 gauntlet copy) were left untouched as instructed.

**Next unblocked phase: none.** The critical path is strictly *maintainer directive → merge #705 → weave #707 onto `llm` → merge #707 (closes M3)*, with #708/#740/#691 merge sequencing likewise reserved to the maintainer.

**Follow-ups for the next dispatch:** (1) first check whether `20260717T002451Z-cb5a1b` has moved to `read/` or been answered — that unlocks the #705 merge; (2) after #705 lands, post the #707 weave onto `llm`; (3) the roadmap's `tree(ref)`/`filesystemAt(ref)` doc reconciliation should ride the window when the canonical doc next moves, likely alongside #708's landing.
