Fix round 7 for kriscendobot/minion.town#210 is pushed and CI is green at head `83e1017`. The one must-fix from panel-7 is still open, because it needs a maintainer decision.

**Still open: the decomplector's must-fix.** It says the stamps should live on the daemon's guest exo rather than at the app's two seams with a DynamoDB partition. A fix stage can't settle that. Rounds 5 and 6 already asked the maintainer to choose among the three options: stamp in the daemon, use a dedicated table, or keep the current design. Neither message has a reply yet, so I didn't send a third. Panel-8 will probably raise it again until the maintainer answers.

There was no pre-pass block this round, so I worked from the latest panel review (5600110714).

**Fixed (should-fix items):**
- **Hung lookups** (breaker #1, saboteur #1): `flush` could hang, and `pending` could keep growing, when the daemon's agent lookup never settled. That lookup now runs under the same timeout as the write. In the MCP wrapper, a lookup that times out is now dropped from the identity cache instead of cached forever (new option `identifyTimeoutMilliseconds`). Commit `2507f1e`.
- **Tool calls failing on a stamping error** (assessor #2): a synchronous throw from `identityKey` could fail a tool call. It now goes to `onError` instead. Same commit.
- **Stale cache concern** (assessor #1): I added a comment saying why the identity cache can't go stale. The guest's pet name comes from iss and sub alone, so an identity always resolves to the same agent.
- **Overstated IAM claim** (breaker #2): `DEPLOYMENT.md` now states the `ReturnValuesOnConditionCheckFailure` caveat, matching `deploy-waitlist-store.sh`. Commit `83e1017`.
- **Wording and trims** (archivist, pruner #1–#7): fixed the in-memory store's label, and removed the doc comments and test-header text that repeated names, plus the duplicate caveat and the long log line in `deploy-accounts-store.sh`.
- **Not applied:** purist #1 (a separate type for the key), purist #2 (moving test-only API out of production) and decomplector #2 (a dedicated table). They depend on the maintainer's choice.

**Checks:** I added three tests: a key that never resolves, a lookup that never settles, and an identity that throws. The guest-agent-activity test files pass (41/41) and `tsc --noEmit` is clean. The repo has no ESLint config, so nothing was linted. I pushed with `safe-push-pr-head.sh`, and `ci-wait-merge.sh` returned 0 (green). I posted the per-item breakdown on the PR: https://github.com/kriscendobot/minion.town/pull/210#issuecomment-6317306631

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr210-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1698719 cached reads)
- Output: 14491 tokens
- Cost: $1.3104758
- Wall-clock: 1106s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
