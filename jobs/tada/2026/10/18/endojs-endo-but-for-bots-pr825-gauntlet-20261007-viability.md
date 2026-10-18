Checks are done: PR #825 is open, and nothing on `llm` has replaced it. Writing the verdict now.

## Viability verdict: proceed with the gauntlet for endojs/endo-but-for-bots PR #825

**Deciding question:** Is the persistent sorted-store work (Phase 4 of the daemon persistent-stores design) still missing from the base, with no newer implementation or design replacing it, while that design still calls for `SortedMapStore` and `SortedSetStore` inside `@endo/daemon`?

**Answer:** Yes.

**Evidence:**
- **The PR is live.** It is open, not merged and not a draft. The head is `daemon-store-phase4-sorted` @ `686d8b98`. The base is the frozen `daemon-store-phase3-weak-ertp-74931b9`, which is the Phase 3 PR #823, still open.
- **Nothing has replaced it.** A search for `SortedMapStore` across the repo's PRs finds only #825. The default branch `llm` has no `packages/daemon/src/collection-store.js`. Code search finds sorted stores only in the design doc. Recent daemon commits on `llm` (through 2026-10-01) don't touch collection stores.
- **The reason for it still holds.** `packages/daemon/designs/daemon-persistent-stores.md` is still on `llm`, marked "Status: Not Started". It still specifies `sorted-map`/`sorted-set`, `makeSortedMapStore`/`makeSortedSetStore` and the sorted-key SQLite index. The rest of the stack (#811 Phase 1, #822 Phase 2, #823 Phase 3) is all still open, so this PR is pending, not orphaned.
- **The placement question is settled.** dckc asked whether this belongs in the daemon package. They then concluded themselves that "making a new formula type" plus "synchronous I/O" mandate staying in the daemon, and the bot agreed. Their later review comment was addressed at `686d8b98`, and CI was fully green (21/21) on that head as of 2026-07-29.
- **Caveat for later stages:** the head is 3106 commits behind `llm`, and the PR sits on top of three unmerged PRs. Later stages will likely need a weave or restack, but that doesn't count against viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr825-gauntlet-20261007-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (261814 cached reads)
- Output: 2466 tokens
- Cost: $0.4579708
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
