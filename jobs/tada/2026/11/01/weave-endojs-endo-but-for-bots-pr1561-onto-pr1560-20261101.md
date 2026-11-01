# Weave report: endojs/endo-but-for-bots#1561 — superseded by a peer job, nothing pushed

I rebased the PR locally, but did not push it or move its base. A live peer job already owns the restack and did the same work first.

**What happened**
- #1561 (`build/exo-agent-factory-daemon-wiring`, head e33aaa5) was based on the old snapshot `build/exo-agent-factory-core-8c4a87e`. In the per-job project worktree I ran `git rebase --onto 21d142af2d 8c4a87e HEAD` (`build/exo-agent-factory-core-21d142a`).
- **Conflicts:** `src/coordinator.js` had 11 hunks and the README had 2. The resolution kept the base's work (renames like `operation`/`namespaceId`/`formulaId`, types moved to `types.ts`, fault-preserving `reconcile`, the re-resolving `remove`). It added the PR's daemon wiring:
  - `makeUnconfined` runner formulation replaces the base's check on maker-returned responders, since makers no longer return one.
  - `formulateLifecycle` now goes through `bindLifecycle`.
  - `copy` and `makeUnconfined` were added to `PrivateHost`, and a `DriverDescriptor` type was added to `types.ts`.
  - The README now merges both sides' Surface and Status text, and `types-index.types.d.ts` exports the new names.
- **One real regression found and fixed:** the PR's `await ready` in `remove`/`revokeDerived` let a later `create` jump the queue. That broke the base test "a queued removal never removes a replacement by stale identity". I fixed it with a `whenReady` helper that enqueues synchronously once the coordinator is ready.
- I also fixed stale type imports in `daemon-host.js` and `install.js`, and added the missing `@endo/far` entry to `yarn.lock` (needed for `yarn install --immutable`).
- **Checks on my tree:** all 46 tests pass (unit plus real-daemon), lint passes, prettier is clean, and the repo-root `tsc` reports 0 errors.

**Why I didn't push:** just before pushing I found the PR head had moved to 7ff37f949e. The peer job `weave-endojs-endo-but-for-bots-pr1561-pr1563-pr1625-onto-pr1560-20261101` force-pushed it at 19:32Z, a minute after I claimed this job. It stacked #1561 onto #1625 (`build/exo-agent-factory-durable-facets-a796cae`, which itself sits on 21d142a) and moved the base to match. Its resolution matches mine in substance, including the same `whenReady` fix and `types.js` imports. Pushing mine would have removed #1625 from under #1561, so I stopped.

**Follow-ups**
- I sent the peer job a note with my findings and handed it the CI work. When I checked, #1561 at 7ff37f9 showed "no checks reported", so CI is not yet confirmed green on the new head. The peer job owns getting it there.
- The job spec's premise (re-base #1561 directly onto 21d142a) is out of date now that #1625 sits between the two PRs.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-endojs-endo-but-for-bots-pr1561-onto-pr1560-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4144286 cached reads)
- Output: 23366 tokens
- Cost: $2.1852251999999996
- Wall-clock: 352s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
