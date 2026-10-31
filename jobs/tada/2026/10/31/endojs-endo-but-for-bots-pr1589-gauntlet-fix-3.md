I followed the job's rc→marker mapping (rc 4 → still-pending), but CI is not on track for green: one test leg has failed on a test this PR doesn't touch.

**Fix round 3 for endojs/endo-but-for-bots#1589**

I applied the must-fix items from the latest panel verdict, review 5723333895 (integrator and pruner, both request-changes). The head is now `e954254f08`, pushed as a fast-forward with `safe-push-pr-head.sh`.

- **Integrator #1, missing template headings (must-fix):** I rewrote the PR body so it has all seven template headings in order: Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade. The Description now says this PR is only the first slice of Phase 6, which also covers integrator comment #3.
- **Integrator #2, unrelated typography changes (should-fix):** a new commit `75958831cd` (`docs(designs): restore …`) puts the design file's `→` and `…` characters back. The design diff now holds only the Phase 6 checkbox and the progress entry.
- **Pruner #1–#7:** commit `e954254f08` (`docs(fae): drop comments that restate the README or the code`) makes these cuts:
  - The `provisionFaeWorkspaceTools` JSDoc keeps only the reason a remote is refused beside a read-only `Git`, plus the writer-scope note.
  - Removed two sentences from the `workspaceGitLocator` / `workspaceRemoteLocator` JSDoc.
  - Removed the first sentence of the workspace comment in `agent.js`.
  - Shortened the `spawnWorkerLoop` workspace JSDoc.
  - Deleted three test comments that only narrated the next line.
  - Deleted the `gitFacet` comment in `agent-tools/src/workspace.js`.
- **Not changed, integrator #5 (comment-only):** I kept the `gitFacet === 'reader'` ternary. `makeGitTool` would accept `'rewriter'` if the value were passed straight through, so the ternary is what keeps history rewrite out of the catalog.
- **Local checks:** Prettier is clean, eslint has 0 errors, and `ava test/workspace-tools.test.js test/subagent-loop.test.js` passed (32 tests).

**CI:** I ran `ci-wait-merge.sh --no-merge` for about 60 minutes in total. The first, background run was stopped at its 10-minute time limit, so I reran it in the foreground in chunks. It ended **rc 4** with 2 of 36 checks still pending: the `test (22.x, macos-15)` and `test (24.x, macos-15)` legs.

- **Failure:** `test (22.x, ubuntu-latest)` failed in `@endo/sandbox`, on the test `bwrap › bwrap timeout and repeated cancellation reap process groups`.
- **Likely not caused by this PR:** the PR doesn't touch `@endo/sandbox`, and the garden's notes record bwrap reds in CI as a known problem that predates this PR, with #1566 as the fix.
- **Not rerun:** the run was still in progress, so I could not rerun the failed job.
- **Follow-up:** whoever picks up the re-posted stage should rerun that failed leg once the run finishes, rather than change the PR.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1589-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2175810 cached reads)
- Output: 11288 tokens
- Cost: $1.227578
- Wall-clock: 3736s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
