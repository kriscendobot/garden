The review is posted. Panel round 3 is complete with disposition **must-fix**.

Panel round 3 for endojs/endo-but-for-bots PR #989 ("design(worker): embargo outbound until a worker quiesces after delivery") complete.

**What I did:**
- Set up an isolated project worktree of the PR head (`design/worker-quiescence-embargo`).
- Ran the design panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against diff base `origin/llm`. Seven seats reported (critic, skeptic, decomplector, ergonomist, copyeditor, pedant, novice).
- Aggregate disposition: **must-fix**.
- Posted the aggregate verdict to PR #989 as a review with the `garden-panel` stage marker.

**Verdict:** must-fix. Recurring request-changes findings converge on two unresolved design gaps: (1) the **Node liveness / unbounded-quiescence** hazard — the default-on embargo turns a merely-slow Node worker into a fully-wedged one with no supervisor bound, deferred to a test-catalog hedge rather than a Decision; (2) the **crank-identity overload** — "crank" is defined one-to-one with an inbound envelope in the glossary but Decision 4's "envelope-free crank" braids in a second meaning, breaking the pure-function invariant and the meter-report test assertion. Plus config-naming parity (`quiescence_embargo` vs the deliberately-chosen `bufferOutboundUntilQuiescence`), undefined load-bearing terms (admission control, budget, hard_limit, CapTP/OCapN), and several prose/heading/citation nits.

**Note:** request-changes was rejected by GitHub (the bot authors the PR — "cannot request changes on your own pull request"), so the verdict was posted as a COMMENTED review. The must-fix disposition is explicit in the body header and the `disposition=must-fix` marker for the next-stage heuristic.

**Follow-ups:** None from this stage — I ran exactly one round and stopped (no fix, no un-draft) per the staged-gauntlet contract.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr989-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 25 tokens (628982 cached reads)
- Output: 3795 tokens
- Cost: $0.8491540000000001
- Wall-clock: 291s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
