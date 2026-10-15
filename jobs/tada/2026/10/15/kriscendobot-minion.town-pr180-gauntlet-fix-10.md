Fix round 10 on kriscendobot/minion.town#180 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0, and the one Actions run, "test (typecheck + vitest)", passed.

**Commit `1a8c9c6`** (`fix(git-remote): open partitions by retention key, not owner identity`), pushed to `design/git-remote-endo-binding` with `safe-push-pr-head.sh` (`f0d03b4..1a8c9c6`, fast-forward).

**Locksmith must-fix (anyone holding `git` could turn a public partition id into readwrite):**
- `POST /partitions` now returns only `{partitionId, retentionKey}`. The retention key is random, and the store keeps only its SHA-256 hash in the sidecar.
- `open` now requires that key. A durable pet name is the formula `E(git).open(<id>, <retentionKey>)`.
- The caplet's `create()` returns that data, not a partition object. `guest-control` binds `open(id, key)` once and no longer prints a recovery hint built from the id alone.
- The owner credential is now checked only on `create`, where it keys the per-owner cap. `mint` and `revoke` are gated by facet keys, `open` by the retention key.
- Side effect: rotating the control secret no longer strands retained partitions. A handle bound before the rotation still replays and gets facet keys under the new secret. This also covers the breaker's comment #6.

**Breaker should-fixes:**
- **#1:** a `create` refused at the cap now rescans the sidecars only when the partitions directory's mtime has changed.
- **#2:** live URLs per partition are now capped (`DEFAULT_MAX_TOKENS_PER_PARTITION = 256`).
- **#3:** added a test that an encoded path-traversal id is refused.
- **#5:** the design doc now says read holders can revoke each other's read URLs.

**Decomplector must-fix (is the HMAC key layer needed, given the `@sites` exo pattern?):** I kept the key layer and added the requested justification to the design doc's Deferred item 2. The partition store runs in the separate `minion-git-remote` process, so authority crosses a loopback HTTP boundary and has to be checked in plain code. The decomplector also asked for maintainer confirmation before another fix round. I didn't have that, so I sent the question to the maintainer with `message-user.sh`; it is not settled.

**Tests:** I updated `control.test.ts`, `git-caplet.test.ts` and `capability.test.ts`, adding tests for the retention key, the stale-credential case, the cap rescan, the token cap and the retention hash. Locally, typecheck is clean and the git-remote, root-host-socket and tool-name suites pass when run with the system `git`. The daemon integration test was skipped locally because `ENDO_CHECKOUT` isn't set, so its only run was CI's (passed). One test, "propagates a git failure", fails under the fleet's `git` wrapper because the wrapper exits 1 where real git exits 128. That is a local environment issue, not this change.

**Follow-ups:**
- The maintainer may still want the `@sites`-shape refactor; their reply on the PR decides it.
- The locksmith's comment-only note about the caplet using ambient `fetch` is still recorded as deferred.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (3696597 cached reads)
- Output: 31926 tokens
- Cost: $2.3011674000000006
- Wall-clock: 1608s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
