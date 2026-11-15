I applied the round-7 must-fix items to PR #1588 and pushed them. CI hadn't finished at the one-hour deadline (`ci-wait-merge` returned rc 4), and three jobs had already failed. All three failures are in tests this PR doesn't touch.

**What I fixed, from the latest panel review (5910441712)**
- **curator, must-fix (duplicate types):** `@endo/http-confine` is now the one home for `Delay`, `FetchLike`, `FetchLikeRequestOptions`, `FetchLikeResponse` and `FetchLikeBodyReader`. `exo-http-client` re-exports them instead of declaring its own copies. I moved the response `type` field into the http-confine version, and one test call that now needs a `method` was updated.
  - Publishing the shared types this way failed CI at first: lint and viable-release could not build exo-http-client's type declarations (error TS2883).
  - Two attempts to fix that also failed in CI. The fix that worked copies `@endo/cancel`'s pattern: a tracked `types-index.types.d.ts` is the package's root types entry and re-exports `src/types.js`.
  - Lint and viable-release then went green, and a local pack of both packages succeeded.
- **migrator and changeset-auditor, must-fix (missing package):** I added a `@endo/daemon: patch` changeset. I checked `@endo/agent-tools` and it uses none of the changed API, so it needs no entry.
- **releaser (bump levels):** the changeset is now three files:
  - the two private new packages (`fetch`, `confined-fetch`) at `minor`;
  - the unreleased breaking changes to `exo-http-client` and `http-confine` at `major`, with a note that neither has been released and with the test-only advice removed;
  - the daemon patch.
- **saboteur:** four fixes in `confined-fetch`, each with a test added or updated where it applies:
  - each persisted binding in `policy.json` is now validated (origin, state, `decidedAt` and the other fields);
  - a parse failure now names `policy.json`;
  - only the snapshot's own missing-file error counts as first provisioning;
  - when cancellation wins the race, the response body that arrives later is closed, and a cancellation token that fulfills is rejected.

Locally, the type checks for the affected packages, the composite build, eslint, prettier and the package-uniformity check all passed. Tests pass: http-confine 30, exo-http-client 49, confined-fetch 28 and fetch 13.

**CI on head `0371beb31f`:** 31 of 36 checks passed, three failed and two were still running.
- `cover (22.x, ubuntu)` and `test (24.x, ubuntu)` failed on `@endo/sandbox`'s "bwrap timeout and repeated cancellation reap process groups" test. It failed on every head I pushed this round. The PR is based on the current `llm` tip, and the fixes for this test (#1566, #1591) are still open.
- `test (24.x, macos-15)` failed in daemon `http-content-plane.test.js` with `Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. That's the Node 24 undici and SES problem we've seen before, and the PR doesn't touch the content-plane code.
- `test (22.x, ubuntu)` and `test (22.x, macos-15)` were still running.

**Not done:** I left the should-fix and comment-only items that weren't cheap for the next panel:
- purist's `harden` and `@endo/errors` items (switching to `@endo/errors` would add a dependency and change `yarn.lock`);
- the three response-snapshot paths that could be merged;
- pruner's comment trims;
- the `.node-version` and workflow-pin changes, which the PR body already calls out.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 204 tokens (12532100 cached reads)
- Output: 45158 tokens
- Cost: $4.719012
- Wall-clock: 7857s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
