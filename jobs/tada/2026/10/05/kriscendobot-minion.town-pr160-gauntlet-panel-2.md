## Panel round 2 on kriscendobot/minion.town PR #160: must-fix

Single-round panel over `9ac858d..32f40bd`, run in an isolated project worktree. `panel.sh` exited 0 with disposition **must-fix**. The `stylist` and `integrator` seats each timed out once and succeeded on retry.

No seat gave a request-changes verdict. The foreperson still ruled must-fix because of three concrete should-fix findings:

1. **breaker:** `sweepBrokerDirectory` in `claude-guest-bridge.ts` deletes every entry under `brokerDirectory` at startup. It cannot tell a stale broker from one a live sibling process is still using, which can happen during a restart overlap or when two processes share `ENDO_CLAUDE_RUNTIME_DIRECTORY`.
2. **breaker:** `streamJsonArgv` in `cli-launch.ts` matches `--output-format` only as an exact token. It misses the `--output-format=json` form and appends a second pair instead of throwing.
3. **wire-watcher:** the per-guest broker socket is now the boundary between guests that share one unix user, but no test shows a confined session cannot reach another guest's socket. The fix is an in-code note deferring this to #162, or a regression test.

The remaining notes are comment-only, for example an assessor point about a window where closing and restarting a broker can overlap, and a stylist question about the `parentDir` abbreviation.

**Review posted:** https://github.com/kriscendobot/minion.town/pull/160#pullrequestreview-5419568531, as `COMMENTED` with a "must-fix" heading, at commit `32f40bd`.
- **Request-changes was refused.** GitHub rejects a request-changes review on your own PR, and kriscendobot owns this one. Earlier rounds on this PR posted the same way.
- **The body was trimmed.** The full aggregate is 76 KB, over GitHub's 65,536-character review limit. The posted review puts the three findings first, then the seat blocks that have notes, and lists the 20 approving seats with nothing substantial by name only.
- **Issue references were rewritten.** The `gh` wrapper refused bare `#N` references, so I wrote them out in full (e.g. kriscendobot/minion.town#162).

I made no fixes and did not un-draft the PR. The next gauntlet stage owns the fix loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1373524 cached reads)
- Output: 7520 tokens
- Cost: $0.9622807999999998
- Wall-clock: 1870s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
