---
handed-off: endojs-endo-but-for-bots-pr288-weave-shepherd-conduct-orch-20261019
deliverable-complete: false
---
I didn't open a new draft PR, because the package already exists in an open PR. The remaining work is handed off to an orchestration that is now on the board.

**The existing PR:** https://github.com/endojs/endo-but-for-bots/pull/288 (`feat/cbors-package` → `llm`) implements the `cbors` design. The package is now called `@endo/cbor-frame`, after the rename in #738.
- It covers the head, encode and decode code, the frame reader and writer, tests, README, changeset and composite tsconfigs.
- It also switches the `@endo/ocapn` test-only TCP netlayer to CBOR framing.
- It already went through panel review and fixes. kriskowal approved it with "Please rebase, shepherd, and conduct. If necessary, weave, shepherd, then conduct."

Opening another PR would have duplicated it. Neither the PR nor any project code was changed by this job.

**What's blocking it:**
- The branch is 2,600 commits behind `llm` and points at the moving `llm` branch rather than a frozen `llm-<sha>` snapshot. That is why the 2026-10-07 gauntlet stopped and asked for the merge base to be pinned.
- One CI check, `test (24.x, ubuntu-latest)`, was failing on head `152ecdac`.

**What I posted:** a serial orchestration, `endojs-endo-but-for-bots-pr288-weave-shepherd-conduct-orch-20261019`, which stops if any step fails. It follows the maintainer's request in order:
1. `endojs-endo-but-for-bots-pr288-weave-20261019` (weaver): snapshot `llm`, rebase onto it, resolve conflicts and move the PR base. This one is already in `todo/`.
2. `endojs-endo-but-for-bots-pr288-shepherd-20261019` (shepherd): get CI green, including the failing Node 24 check. Parked until step 1 finishes.
3. `endojs-endo-but-for-bots-pr288-conduct-20261019` (conductor): merge after re-confirming the approval still applies to the new head. Parked until step 2 finishes.

The remote `journal2` branch shows all four records.

**Follow-up:** design PR #711 (moving the daemon from netstring to cbor-frame) is still an open draft and depends on #288 landing.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-cbors-byte-string-framing.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (655796 cached reads)
- Output: 4777 tokens
- Cost: $0.6093712000000001
- Wall-clock: 91s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
