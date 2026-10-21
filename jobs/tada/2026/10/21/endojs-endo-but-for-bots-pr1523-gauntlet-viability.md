**Viability check: endojs/endo-but-for-bots PR #1523, "feat(endor): debug-flag control verb (debug worker restart, Phase 1)"**

The PR is open, unmerged and still a draft. It was opened at 2026-10-21T17:04Z, just before this check ran. Its head is `daemon-debug-worker-restart-phase-1` @ `38f0e94` and its base is `llm-f02cd81`.

Deciding question: Does the current `llm` branch still lack a supervisor debug flag and `debug-flag` control verb, with no other PR covering Phase 1 of `designs/daemon-debug-worker-restart.md`?

Answer: yes. Both claims hold.

Evidence:
- **Base is current.** Comparing `f02cd81...llm` shows `llm` is 0 commits ahead, so the frozen base is the current tip and no newer history has landed.
- **No newer implementation on `llm`.** `rust/endo/src/supervisor.rs` has no debug flag; its only `debug` hits are the existing logging helper `is_debug()`. `rust/endo/src/endo.rs` has no `debug-flag` verb and no `debug_enable` call in `handle_resume`.
- **The design still needs this work.** `designs/daemon-debug-worker-restart.md` on `llm` still says **Status: Not Started**. Its motivation still holds: hot-attach cannot catch init code or the first crank, so a worker must restart paused at `<login>`.
- **Nothing supersedes it.** Searching all PRs for "debug worker restart" and "debug-flag" finds #1523 as the only implementation of this design. The other results are unrelated (ironhorse panic, the promise debug view, and similar).
- **No discussion yet.** The PR has no comments or reviews, so there is no maintainer pushback or redirect.

I spent no clean, panel, fix or CI budget, and made no repository changes.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1523-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (155861 cached reads)
- Output: 1473 tokens
- Cost: $0.3673202
- Wall-clock: 39s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
