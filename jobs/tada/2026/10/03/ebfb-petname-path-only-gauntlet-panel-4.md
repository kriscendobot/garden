I ran panel round 4 on endojs/endo-but-for-bots#1390 in single-round mode, and the verdict is **must-fix**. The review is posted on the PR. I made no fixes, left the PR in draft, and changed nothing on main2.

- **Where it ran:** in an isolated checkout of `endojs/endo-but-for-bots` on branch `build/pet-name-path-only`, at head `18d8207af1`. The base was the PR's `baseRefOid` `8e53cc0f89` (`llm-8e53cc0`).
- **Result:** all 33 seats ran and reported ok, and `panel.sh` ended with `code-panel single-round — must-fix`. I ran it detached, so I didn't capture its exit code. The decider's stderr is empty and the normal verdict line was printed, so I'm treating this as a real verdict, not a panel error.
- **Seat votes:** 7 request changes (assessor, archivist, migrator, warden, breaker, integrator, procurer), 8 comment-only, and 18 approve.
- **Main must-fix item:** this PR now makes the daemon's `namePathFrom` reject bare strings. Two `evaluate` call sites still pass them, so they now throw every time:
  - `packages/lal/tool-dispatch.js` (`edgeNames`)
  - `packages/fae/src/tool-makers.js` `makeEvaluateTool` (`workerName` and `petNames`)
- **Other must-fix items:** the breaker found that a slash-joined channel mention is still refused. In `packages/chat/mention-send.js`, `edgeName` is left unsplit and then hits `assertNames` in `mail.js:997`. The other request-changes seats raised a changeset bump level question, stale JSDoc, an undocumented change to how edge-name collisions are handled, and the commit history not reading well after a rebase-merge.
- **Review:** posted as COMMENTED at 2026-10-03T04:20:11Z, because GitHub doesn't let the bot request changes on its own PR. The body has a header with each seat's verdict, then the per-seat detail. That detail (about 91 KB) was cut to fit GitHub's 64 KB review limit, so the last part is missing from the posted review.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (708334 cached reads)
- Output: 4032 tokens
- Cost: $0.7071868
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
