I applied the round-14 must-fixes on kriscendobot/minion.town#180 and pushed them to the PR head. The fix pushed as `fd3080e` and CI on it is green (`ci-wait-merge` rc 0). I made no changes to the garden repo. One of the panel's must-fixes needs a maintainer decision, which I've asked for.

**Fixed:**
1. **Secret rotation broke retained partitions (engine-realist).** Since commit `118e6c1`, the caplet checked every request's `/hello` proof against its owner credential. After a root-secret rotation, a caplet from before the rotation could no longer reopen, mint or revoke its retained partitions.
   - Each `/hello` proof is now keyed by the secret that request will present: the owner credential for `create`, the stored retention hash for `open`, and the facet key for `mint`/`revoke`.
   - Only `create` still needs a current credential. A squatter on the control port still receives no secret.
   - New test in `git-caplet.test.ts`: a caplet with the old credential, run against a listener using the rotated secret on the same store, still opens, mints and revokes. Only `create` is refused.
   - Updated tests in `control.test.ts` cover the `/hello` proof for `open`, read and readwrite, plus the refusals.
   - Commit `5e3e0e3`.
2. **Design doc pointed at rotation text that didn't exist (archivist).** The rotation explanation now lives in the `control.ts` header. `DEPLOYMENT.md` points to it instead of repeating it, which also removes the duplicate sentence the pruner flagged (commit `fd3080e`). I also deleted two comments in `control.ts` that only restated their types.

**Not done:** the decomplector's two must-fixes need the maintainer, and the seat itself asks to stop for confirmation before another fix round:
- It proposes replacing the whole HTTP control plane with a daemon-hosted registry, the same shape as `installSiteRegistry`.
- It says the bearer `retentionKey` contradicts § 7 of the parent design, which kriscendobot/minion.town#41 approved.

I sent the question to the maintainer inbox through `message-user.sh`. I didn't redesign anything in this round.

**Tests:**
- `tsc` passes. The `control`, `git-caplet` and `endo-root-host-socket` tests pass, 27 of 27.
- Locally, `capability.test.ts` ("propagates a git failure…") fails in code this change doesn't touch. My guess is that it's this host's git or tmpdir environment, but I didn't check. CI on `fd3080e` passed.

**Follow-ups:**
- The maintainer's answer on the decomplector items decides whether panel-15 should keep reviewing this design.
- I left the remaining should-fix items for later rounds:
  - saboteur's token-cap fill by a read-only delegate, and its mtime-based rescan guard
  - purist's split of `makePartition`, `@endo/hex`, and the shared constants module
  - engine-realist's `endo-daemon.service` ordering after `minion-git-remote`
  - the rest of the pruner's PR-body trims

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-14.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2226753 cached reads)
- Output: 19023 tokens
- Cost: $1.5344586
- Wall-clock: 1424s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
