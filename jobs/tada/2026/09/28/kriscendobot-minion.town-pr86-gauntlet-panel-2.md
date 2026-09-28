Panel round 2 on kriscendobot/minion.town PR #86 came back **must-fix**. The verdict is posted on the PR, and this stage stopped there: no fixes, no un-drafting.

**What I ran**
- Checked out the PR head (`git-remote-capability-increment-1` @ `0f9633a`) in its own worktree.
- Ran the panel in single-round mode with `GARDEN_YARN=npm` against base `b32291d` (the PR's recorded base commit). That diff has the same 15 files GitHub shows.
- It picked the code panel (33 seats), ran every seat fresh (none were reused from a saved run), and exited 0 with disposition `must-fix`.

**Posted to the PR**
- **Review 5345127268** on head `0f9633a`, headed "Panel round 2 — must-fix". It holds the 13 seats that asked for changes. It went up as a comment, not a request-changes review, because GitHub won't let the bot request changes on its own PR. The `must-fix` header is what the next stage reads.
- **Issue comment 5879518911** with the other 20 seats (approve or comment-only). The full panel output (93KB) was too big for one GitHub review, so I split it the same way as round 1.

**Main must-fix findings, for the fixer round**
- **Process crash:** `git-backend.ts:113` pipes the request into the child's stdin without an `'error'` handler. If git exits early, the EPIPE is uncaught and takes down the whole server, and any read token can trigger it. The child is also not killed when the client disconnects. (saboteur, wire-watcher)
- **Revoked token can come back:** `partition-store.ts` only serializes writes within one process. The runbook has the operator revoke from a second process, so a push running at the same time can write a revoked token back to disk. (breaker, engine-realist)
- **`write` token can read and publish hidden refs:** at `git-http.ts:144`, a write-only token gets the full ref list and can point the served ref at a private commit, which then gets published. (purist)
- **Untested behaviour:**
  - The fix that clears `contentRoot` after a push has no test that goes through a real push; reverting it leaves all tests green.
  - The claim in `projection.ts` that re-running the projection gives the same result is never tested.
  - The index-cache speedup is claimed without any measurement.
  (prover, pruner, benchmarker)
- **Docs:**
  - The PR description is stale: it still says 31 and 330 tests and points to the wrong runbook location.
  - The increment design doc quotes text the parent design doesn't contain.
  (integrator)
- **Naming:** single-letter `u` in `capability.ts:101`. (stylist)

**Follow-ups:** none. This round didn't change any code.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (914611 cached reads)
- Output: 5697 tokens
- Cost: $0.7826301999999998
- Wall-clock: 401s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
