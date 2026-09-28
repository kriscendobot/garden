Fix round 2 is done for kriscendobot/minion.town PR #86. I applied every must-fix from the round 2 panel review (5345127268) and pushed four follow-up commits (head 0f9633a → 17bb44d). CI is green: the gate returned rc 0 with all 3 checks passing.

**Must-fix items:**
- **Process crash on an early git exit** (saboteur, engine-realist): `git-backend.ts` now handles the "broken pipe" (EPIPE) error when `git http-backend` exits before reading the whole body. It also kills the git process when the client disconnects, and pipes the response with backpressure. A new protocol test sends a 16 MiB corrupt gzip body; against the old code it fails with an unhandled `write EPIPE`.
- **A push could undo a revoke made from another process** (breaker, wire-watcher): the content root now lives in its own file, `content-roots/<id>`, so the serving process never rewrites the token file. A new test pauses the server's write, revokes from a second store instance in the middle, then checks the revoke held. Against the old store the revoked token comes back.
- **`write` attenuation leaked read access** (purist): I took the reviewer's "defer it" option. Only `read` and `readwrite` can be minted now, and a stored `write` binding is refused. The design doc lists `write` as deferred, and why. The protocol tests that used a `write` token now use `readwrite`.
- **Content-root clearing had no test through a real push** (prover): git won't let a push delete the branch the repo serves, so that path can't happen. The new e2e test covers the reachable case instead: it seeds a stale content root, pushes a different branch, and checks the root is cleared. It fails if the old `if (result.contentRoot)` guard is restored.
- **`u` → `url`** in `capability.ts` (stylist).
- **Stale PR description** (integrator): rewrote the title and description to match the current head, including that it is built but not deployed and has only been verified in-process.
- **Invented quotation in the design doc** (integrator): removed; the doc now states the bounded scope as this PR's own decision.
- **Unmeasured token-index cache claim** (benchmarker): measured it and recorded the results in the design doc § Measurement. With 1,000 unknown tokens per run:

| Partitions | Cached miss | Full rebuild per miss |
| --- | --- | --- |
| 10 | 0.010 ms | 0.28 ms |
| 100 | 0.009 ms | 2.8 ms |
| 1,000 | 0.009 ms | 25.7 ms |

**Should-fix items I also took, since they were cheap:**
- Projections now run one at a time per partition, so an older push can't overwrite a newer one.
- Renamed the router's `Half` type to `GitService` (`"upload-pack" | "receive-pack"`).
- Renamed `d` → `describeWithGit` and `a`/`b` → `alicePartitionId`/`bobPartitionId`.
- Added the Phase 13 row to `DEPLOYMENT.md`.
- The runbook now says to run only one operator process at a time.

Before pushing, typecheck, the full `npm test` (618 passed, 8 skipped) and the garden's pre-push checks all passed.

**Left for later:**
- Several should-fix items are still open:
  - split the store so the request router can't mint or revoke
  - revoke by token hash instead of the raw token
  - validate the token file's contents
  - catch only "file not found" when reading it
  - cap push and blob sizes
  - reject non-UTF-8 paths
  - document the minimum git version
- The pruner's comment trims are also still open.
- Two operator processes minting or revoking at the same time are still not guarded against each other; it's documented, not fixed.
- I did not re-run the panel. The gauntlet driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (4263981 cached reads)
- Output: 35139 tokens
- Cost: $2.7518082
- Wall-clock: 639s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
