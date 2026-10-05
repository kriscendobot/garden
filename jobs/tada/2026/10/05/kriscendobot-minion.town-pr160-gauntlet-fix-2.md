**Fix round 2 for kriscendobot/minion.town PR #160 (`kriscendobot-minion.town-pr160-gauntlet`): all three must-fix items are applied and CI is green at head `ae967c4`. I pushed no commits of my own; another job's commit already covered all three.**

The "Gauntlet panel — round 2" review (5419568531, at head `32f40bd`) asked for three fixes:
1. **Broker directory sweep** (`claude-guest-bridge.ts`): the startup sweep deletes every entry, so it could delete a live broker that another process is still using. Fix by stating what guarantees a single owner, or by checking the socket is dead before deleting.
2. **`streamJsonArgv`** (`cli-launch.ts`): it missed `--output-format=json`. Handle that form and add a test.
3. **Socket isolation between guests:** no test shows a confined session can't connect to another guest's socket. Add a note that this is deferred to kriscendobot/minion.town#162, or add the test.

**What happened:**
- A second gauntlet is running on the same PR (`build-minion-town-claude-guest-scoped-mcp-gauntlet`). Its fixer, `…-gauntlet-fix-4`, was working at the same time, so I messaged it to split the work. I wrote fixes and tests for all three items; tsc, vitest (48 tests) and prettier were clean.
- When I rebased, that fixer had already pushed `ae967c4`, which covers all three items:
  - It states the single-owner guarantee: in production the broker directory sits under the `minion-mcp` unit's own systemd `RuntimeDirectory=`.
  - `streamJsonArgv` now checks every `--output-format` occurrence, including the `=` form, with tests.
  - It adds the #162 deferral note.
  - It also fixed its own panel's items: `launchClaude` now resolves an error instead of rejecting, and there's a note that `parentDir` is the upstream parameter name.
- Pushing my versions on top would have been redundant churn, so I aborted the rebase and dropped them. That includes my stronger sweep fix, which checks that a socket is dead before deleting its directory. The panel accepted either approach.
- **CI:** `test` passed. The two "Claude harness" jobs (amd64 and arm64) were cancelled with no runner assigned and no steps run, which looks like GitHub runner starvation, not the code. I re-ran the failed jobs twice. amd64 then passed, and arm64 ran and passed. `ci-wait-merge` now returns rc 0, all 3 checks green.

**Follow-ups:**
- PR #160 has two gauntlets running at once, which makes fixers collide. Someone should retire one of them.
- The liveness-checking sweep could still be added later if the single-owner assumption turns out to be weak.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr160-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3072971 cached reads)
- Output: 16617 tokens
- Cost: $1.6609342000000002
- Wall-clock: 4486s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
