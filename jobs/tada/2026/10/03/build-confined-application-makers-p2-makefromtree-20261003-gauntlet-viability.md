I checked PR #1419 and it can go ahead into the gauntlet. It was opened today, and nothing on `llm` has replaced it or made its reason for existing obsolete.

Deciding question: Is Phase 2 of `designs/agent-confined-application-makers.md` (the daemon-side `node_modules` capture plus the `layout`/`entry` options on `makeFromTree`) still missing from the `llm` branch, with nothing else building it?

Evidence: Yes, still missing, and nothing else is building it.
- **PR state:** #1419 is open, unmerged and a draft. It was created 2026-10-03T06:19Z, has no comments or reviews yet, and its head is `19328f0d28`.
- **Design is approved:** the design was merged to `llm` through #1340 and lives at `designs/agent-confined-application-makers.md`. Its status reads "Proposed", and it describes this daemon work as Phase 2.
- **Not yet on `llm`:**
  - `packages/daemon/src/tree-layout.js` does not exist there.
  - `makeFromTree` in `host.js` has no `layout` option.
  - `manager.js` has not changed since 2026-09-22.
- **No competing work:** a search for "confined application makers" finds only #1417 (Phase 1) and this PR. No other PR implements Phase 2.
- **Stack order:** #1417 (Phase 1, `makeTreeReadPowers`) is still an open draft. Its head `0bdf8951cb` matches #1419's frozen base `llm-confined-application-makers-p1-0bdf895`, so the stack is consistent.
- **Merge order matters:** #1417 has to land before this one. The later stages should respect that.

I made no changes and opened no PRs.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (172198 cached reads)
- Output: 1573 tokens
- Cost: $0.4181556
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
