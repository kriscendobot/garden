Round-4 fix for kriscendobot/minion.town#120: I fixed the two code must-fix items and one should-fix, pushed them as commit `484cfc3`, and CI is green. The phase/evidence gate (item 1) is still open because no code change can clear it.

**What changed** (`src/endo/claude/agents.ts`):
- **Failed `create` rolling back a live child (item 2):**
  - A failed `create` now rolls back only if no concurrent `create` has already published the child and no teardown already owns it.
  - When it does roll back, it claims the key and removes the directory child before releasing the slot.
  - `create` no longer publishes a child while a teardown of that name is still running; it waits for the teardown to finish and cleans up instead.
  - The result: a failed `create` can no longer leave a live agent outside the pool cap and the grant's `maxChildren`.
- **`revoke` not stopping agents right away (item 3):** `ClaudeAgent.infer` now also checks that the grant is still live. Agents under a revoked grant stop working immediately, not only when teardown reaches them.
- **Should-fix:** `teardownNamespace` used to skip a child whose `dismiss` was still running. It now waits for that `dismiss` and then finishes the cleanup. A failed `dismiss` can no longer leave a slot taken while `revoke` reports `revoked`. I pulled the waiting loop out into a shared `awaitTeardown` helper that `create` also uses.
- **Tests:** I added four regression tests to `test/claude-delegation.test.ts`, one for each case. All four fail on the previous head `eaebbf9` and pass now. I also renamed the helper's `opts` parameter to `options`.
- **Local checks:** all 82 Claude tests pass and `tsc --noEmit` is clean. A bare `vitest run` also picks up two `tools/claude-harness/*.test.mjs` files and reports "No test suite found" for them; they are `node:test` files, not vitest. This diff doesn't touch them.

**PR activity:**
- I pushed with `safe-push-pr-head.sh` (`eaebbf9` → `484cfc3`).
- I posted a fix summary comment (issuecomment-5882370989), which also answers the scribe's request for one.

**CI:** The first run failed on one test in `test/endo-daemon-integration.test.ts` ("B2 tool layer: writeText -> readText -> restart -> read (self-healing)"). That is a live Endo-daemon restart test and doesn't touch the Claude code. I treated it as a flake and re-ran the failed job once. The re-run passed, and `ci-wait-merge` returned rc 0 (3 of 3 checks green).

**Follow-ups:**
- **Item 1:** The PR stays draft until endojs/endo-but-for-bots#1015 merges and the root, confinement, delegation and restart canaries run against a live deploy. This is the fourth round blocked on it, so panel-5 will bind must-fix again no matter what the code does. Someone needs to decide whether to keep cycling the gauntlet or park it until #1015 lands.
- **Should-fix items not done:**
  - log swallowed errors in `never-reject.ts`
  - a repeat `delegate` silently drops its new `canceled`
  - a separate revocable status facet for each grant
  - consistent "authority gone" results
  - rename the plain `DelegatedClaudeAgents` case
  - trim the `agents.ts` module header
  - tests for `canceled` and all-dot names
  - the PR description no longer matches the head

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1470414 cached reads)
- Output: 13761 tokens
- Cost: $1.2265188
- Wall-clock: 598s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
