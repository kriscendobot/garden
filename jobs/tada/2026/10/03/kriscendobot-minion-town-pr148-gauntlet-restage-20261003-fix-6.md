# PR #148 fix round 6 (kriscendobot/minion.town): pushed, CI green

I applied the round-6 must-fix items. Five follow-up commits moved the head from `dea0146` to `7c08ffa`, and all 3 CI checks passed (`ci-wait-merge` rc 0).

**Must-fix items**
- **Child guests had root authority (`533aabb`).** Each `(subject, caller)` pair, and each subject's probe guest, now gets its own child host under `claude-hosts/<key>`. Children are created by that host, so a child's `@host` is the lower-trust host, not the root, and the pinned Endo denies non-root hosts `@endo`. The live-daemon test now checks this.
  - This also fixed a bug: the probe guest called the daemon's `lookup` with two arguments, which the real pinned daemon rejects. The live-daemon suite now covers the probe guest.
  - **Still open:** the `endo-mcp-stdio` relay still receives the root socket. Closing that needs an upstream change and stays tracked in kriscendobot/minion.town#149. The maintainer must accept that gap before production is enabled; I said so on the PR.
- **Token left on disk after a crash (`f36cae1`).** The deployed runtime directory is now `/run/minion-town/claude-runtime`, under the unit's `RuntimeDirectory=`, which systemd keeps in memory and deletes on stop. The backend also deletes leftover `spawn-*` directories before its first spawn, which covers the probe's marker directory. A test covers this, and `DEPLOYMENT.md` and the unit file are updated.
- **Stale PR body.** I rewrote it to describe what actually changes in the three designs. It is now 282 words, under the 300 limit, and the phase ledger is kept.
- **Missing summary comments.** I posted summaries for round 2 (`551f155`), round 5 (`dea0146`) and round 6 (`7c08ffa`).
- **Probe in the gauntlet.** The fix loop can't clear this; the PR stays draft as required.

**Should-fix items also done**
- `b240316`: the confinement probe now fails if the session reports any tool not on the spawn's pinned `--allowedTools` list, instead of only checking a name prefix and three banned names. Tested.
- `7389675`: the agent-MCP default paths are built from `DEPLOYED_ENDO_ROOT`, now in a small module that is safe to load before `@endo/init`. I removed the unused `lookupById` and fixed the `.env.example` comment that said "all six" over nine variables.
- `7c08ffa`: reverted the leftover table padding and emphasis changes in `designs/endo-reminder-minion-town.md`.

**Deferred** (should-fix and comment-only items):
- making `activate` required
- merging `ClaudeBridgeHost` into `DaemonHost`
- a process-wide spawn limit and caching the version check
- evicting entries from the `minted`/`fullIdentifiers` maps
- the vendored `@endo/claude` type declarations and README pointer (vendored files must match upstream exactly)

**Verification:** typecheck passes. All Vitest tests pass except `test/git-remote/capability.test.ts`, which also fails on `main` on this host. I ran the full live-daemon suite locally against Endo `1706e63`: 7 of 7 passed. CI is green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr148-gauntlet-restage-20261003-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 134 tokens (7848509 cached reads)
- Output: 40205 tokens
- Cost: $3.6168097999999995
- Wall-clock: 676s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
