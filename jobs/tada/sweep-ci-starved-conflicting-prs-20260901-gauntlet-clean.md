This is a docs-only PR — it adds `designs/relative-routing.md` and modifies `designs/README.md`, touching no code packages. All CI checks are SUCCESS at the current head (`9dc920ea4307977132d3ed42698cbfe8e5521a3f`). There is no code change, so the coverage-driven-testing pass and dead-code sweep have nothing to act on.

Per step 1 (idempotence), the PR is already the right shape: CI is GREEN at the current head. This stage is a NO-OP.

## Completion report

**Stage:** clean — endojs/endo-but-for-bots PR #1013 (`design: relative routing for CapTP/OCapN locator hints`)

**What I did:**
- Checked PR shape via `gh pr view`. The PR is docs-only: it adds `designs/relative-routing.md` (+725) and edits `designs/README.md` (+7/-1). No source packages are touched.
- Confirmed all CI checks are terminal GREEN at the current head `9dc920ea4307977132d3ed42698cbfe8e5521a3f`: `browser-tests`, `lint`, `build`, `zizmor`, and `test` all `SUCCESS`.

**Result:** Because the change touches no code, coverage-driven-testing and dead-code removal have nothing to act on, and CI is already green at the current head. The clean stage is a no-op — nothing to push.

**Changed:** nothing (no follow-up commits to the PR head).

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/sweep-ci-starved-conflicting-prs-20260901-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 7 on 2 host(s)
- Input: 6 tokens (86616 cached reads)
- Output: 1598 tokens
- Cost: $0.35152800000000006
- Wall-clock: 45s
- Model(s): claude-opus-4-8 ×7

<!-- garden-usage-end -->
