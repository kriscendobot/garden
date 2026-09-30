**Panel round 1 on endojs/endo-but-for-bots#1390: must-fix. The verdict is posted on the PR.**

**What ran**
- I made an isolated checkout of the PR head (`endojs:build/pet-name-path-only` at `12c61653a6`) with `ensure-project-worktree.sh`.
- I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1390 8e53cc0f89…`, passing the PR's `baseRefOid` (frozen base `llm-8e53cc0`) directly rather than a branch name that could be out of date. It ran detached so a reap couldn't kill it.
- panel.sh exited 0 with disposition **must-fix** (`exit_code=0` in record-meta). All 33 seats finished with status ok. The run record is at `panel-runs/endojs-endo-but-for-bots-1390/79b711aef0cd.md`.

**Seats requesting changes (11):** typist, packager, prover, warden, saboteur, breaker, engine-realist, integrator, changeset-auditor, pruner, corner-prober. The main must-fix findings:
- Some call sites still pass a bare string to `lookup`:
  - `packages/floot/floot-factory-setup.js:316`
  - `packages/chat/chat.js:854` (`switchChannel`)
- **Untested backward-compatibility claim:** the changeset says old invitation records with a bare-string `guestName` still revive (the coercion in `manager.js` ~4558–4566), but no test covers it. Both prover and corner-prober raised this.
- **Changeset gaps:** it leaves out most of the private packages whose call sites changed, even though `privatePackages.version: true` is set.
- **`adopt`'s `edgeName`:** it breaks the rule the PR writes into the guard's doc, that every guarded argument goes through `namePathFrom`.
- **Stale PR description:** the Status paragraph cites head `065f1344ea`, five commits behind.
- **Agent-tools path splitting:** `toPetNamePath` in `agent-tools/src/code-mode/daemon.js` splits a model-supplied string on `/`. That brings back the ambiguity at the agent boundary that the PR sets out to remove.

**Posting the review**
- GitHub refused `--request-changes` because the bot can't request changes on its own PR, so the review went up as **COMMENTED** at 2026-09-30T13:50:02Z. It carries a `<!-- garden-panel-verdict: must-fix … -->` marker.
- The full aggregate is 93 KB, over GitHub's review-body limit. The review includes every request-changes seat, every seat with no verdict line, and most comment-only seats in full. Twelve seats (3 comment-only, 9 approve) are listed by name and verdict only.

Per the stage instructions I did not fix anything or un-draft the PR. The fix-loop stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-sweep-4-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1170132 cached reads)
- Output: 5924 tokens
- Cost: $0.9028103999999998
- Wall-clock: 643s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
