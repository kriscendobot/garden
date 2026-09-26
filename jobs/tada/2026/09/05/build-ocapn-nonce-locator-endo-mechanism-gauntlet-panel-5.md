Panel round 5 complete. Report follows.

---

**Gauntlet PANEL round 5 — endojs/endo-but-for-bots PR #1124**

**What I did:**
- Resolved the PR head (`kriscendobot:build/ocapn-nonce-locator-mechanism`, head `f10247fd2`) and got an isolated project worktree.
- Ran the 29-seat code panel in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). The first two attempts hit a transient API outage (mass empty verdicts) / were killed by recurring host-churn reaps (garden-reaped reached 4) mid-run; I switched to foreground polling to keep the session active and drove a fresh run to completion — **all 29 seats returned, disposition `must-fix`**.
- Composed a faithful round-5 digest and posted it as a `gh pr review --comment` (2026-09-05T08:55:30Z). Used COMMENTED, like all four prior rounds, because reviewer and PR author are both `kriscendobot` and GitHub forbids request-changes on one's own PR; the `must-fix` disposition is carried in the body and the `<!-- garden-panel-round: 5 disposition=must-fix -->` marker the next-stage heuristic reads.

**Verdict: must-fix** — 19 request-changes, 4 comment-only, 6 approve/no-must-fix.

**Dominant blocking finding (raised independently by 7 seats, and I verified it directly in code):** this round's own fix `f10247fd2` ("make the session locator's verified key reachable") is a **regression** — `prepareOcapn` gained a 4th `peerPublicKey` param (`index.js:611`) but only 2 of its 3 call sites were updated; the **default** `op:start-session` path at `handshake.js:256` still passes 3 args, so `context.peerPublicKey` is `undefined` on every in-tree netlayer (including the PR's own tcp tests), which `checkJs` misses (stale callback JSDoc) and the suite misses (no test reads the field). Other must-fixes: the "usable directly as `locator`" doc names the inert configuration and breaks the live `endo-peer-entry` swissnum; concurrency/non-oracularity claims have no (and one falsifiable) test closure; the cited design's well-known bootstrap swissnum is foreclosed and unreconciled.

**Follow-ups:** This is a single stage — I did not fix, un-draft, or loop, per spec. Next gauntlet stage is the fix loop. Note: the review worktree carries 3 untracked seat-scratch `zz-*probe.test.js` files (no tracked-file edits, so the reviewed diff was clean); they vanish with worktree teardown.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ocapn-nonce-locator-endo-mechanism-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s)
- Input: 100 tokens (3424034 cached reads)
- Output: 28419 tokens
- Cost: $4.574521
- Wall-clock: 1672s
- Model(s): claude-opus-4-8 ×5

<!-- garden-usage-end -->
