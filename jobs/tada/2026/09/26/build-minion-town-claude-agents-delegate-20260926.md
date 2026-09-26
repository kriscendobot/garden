## Completion report: build-minion-town-claude-agents-delegate-20260926

I opened draft PR https://github.com/kriscendobot/minion.town/pull/120. It closes the gaps between the root-endowment design landed by #97 and the shipped Claude-agents wiring. Its base is a frozen branch `main-c815041` (the merge of #97), because `ensure-pr.sh` requires a pinned base. CI passes (test, Claude harness amd64 and arm64). Locally, `npm run typecheck`, `npm run build` and `npm test` all pass (495 passed, 7 skipped). Everything stays behind `ENDO_CLAUDE_ENABLED=1` with the same fail-closed production defaults, and the PR stops at draft.

**What I found and fixed:**
- **Children held the root's full factory.** `agentsFor(subject, anyGuest)` returned the root's full factory for any guest, and the wiring test used it as a child's facet. A child's facet now comes from a new `childAgentsFor()`, which has no delegation verbs. `agentsFor` gives only the root guest the full factory (`RootClaudeAgents`).
- **`delegate(label, { maxChildren, canceled? })`** is implemented on the root's factory only. It gives the peer:
  - its own delegation namespace;
  - the shared credential and pool, under a required `maxChildren` cap checked together with the pool cap;
  - a status-only view of the account.

  A repeat call with the same label returns the same grant. `listDelegations()` and `revoke(id)` are also root-only. Revoking, or settling `canceled`, tears down every child created through the grant, including children created through forwarded copies and grandchildren, and frees their quota. After that, any held copy is inert: `create` returns `needs-auth` and its agents return `unavailable`.
- **Result shapes:** `create` now returns `{ type: "created", agent }`, and `agent-limit-reached` now says whether the subscription pool or the delegation cap was hit (`scope`).
- **`dismiss` is recursive:** it tears down the child and everything beneath it and frees each slot.
- **Never-reject boundary:** the code comments promised one, but it didn't exist, so a provisioning fault made `create` reject. Every method that changes state now resolves `unavailable` on failure, and `list`, `models` and `listDelegations` return `[]` instead of failing.
- **Other fixes:**
  - `accountStatusFor` now answers only for root subjects, so a non-root guest holds neither name.
  - `ClaudeAccount` is renamed `RootClaudeAccount`, matching the design's naming.
  - A quota comment that said "monotonic clock" now says wall-clock, as the design specifies.
- **Inbox-watch driver** (`inbox-watch.ts`, from the design's Meeting arc item 2). It runs one inference per arriving message, is opt-in per child, and has a per-child rate cap that drops a sustained flood.
- **Root identity** (`ENDO_CLAUDE_ROOT_SUBJECTS` → `config.rootSubjects`, empty by default) already matched the design, so it is unchanged.

**Tests:** two new files, `test/claude-delegation.test.ts` (12 tests) and `test/claude-inbox-watch.test.ts` (3 tests). They cover the design's acceptance items for root-only delegation, delegation limits, per-root isolation, and rate-limited inbox watching. I updated the existing wiring and quota tests to the new result shapes.

**Gaps left open (all listed in the PR body with reasons):**
- **Needs a design decision:** bad `delegate` arguments resolve `unavailable`, because the design's result type has no invalid-argument case. A dedicated tag would take a small design amendment.
- **Waiting on endojs/endo-but-for-bots#1015:**
  - Delegation records are kept in memory, so they don't survive a daemon restart and a demoted root can't revoke after a redeploy.
  - Tearing down a child doesn't stop an inference already running on it. That needs a cancel method on the provider, and I did not invent one.
  - The mail-attach/`adopt` hand-off and the inbox feed into the watcher are daemon pieces that don't exist yet.
  - The design doesn't define a verb for the root to turn on a watcher for a child.

**Follow-up:** the PR needs **run the gauntlet #120** to move out of draft.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-agents-delegate-20260926.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3642376 cached reads)
- Output: 53260 tokens
- Cost: $3.0122751999999995
- Wall-clock: 791s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
