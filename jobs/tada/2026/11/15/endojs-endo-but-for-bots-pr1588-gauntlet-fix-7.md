Fix round 7 for PR #1588 is done and CI is green on head `0371beb31f`. All 36 checks pass, with 0 failed.

**Which findings I fixed**
- The job carried no pre-pass block, so I used the latest review (2026-11-15 11:29Z). Panel-7 had judged the older head `0005e956ca2`.
- An earlier attempt of this job had already pushed the must-fix commits, so I pushed nothing new. These are the commits it pushed:
  - `b7db49febe` re-exports `Delay` and `FetchLike` from `@endo/http-confine` in `exo-http-client` (curator 1).
  - `a5ac912da4` splits the changesets, adds an `@endo/daemon` patch entry, and takes the two private new packages down from major to minor (migrator 1, changeset-auditor, releaser).
  - `2713dd33e0` fixes `confined-fetch`:
    - validates persisted bindings (saboteur 1);
    - names `policy.json` in the JSON parse error (saboteur 2);
    - treats only the snapshot's own ENOENT as first provisioning (saboteur 3);
    - closes the body when cancellation wins the transport race (saboteur 4).
  - `25ea35ee4b` and `0371beb31f` publish the shared `http-confine` types so `exo-http-client` can emit its declarations.
- I ran `pre-push-gates.sh --no-auto-fix` against the PR base `48d6f3e08b`. It exits 0, with only an advisory comment-concision note on `packages/confined-fetch/index.js:4`.
- I did not apply the non-blocking items:
  - Purist items: missing `harden()` on exports and raw `throw`s where `@endo/errors` is the convention.
  - Pruner items: duplicated-comment trims.
  - Migrator's `agent-tools` cascade check.
  - Migrator's check that no in-repo caller drops the promise from the now-async mutators (`revoke()` and the rest).
  - Curator 2 and 3 (overlap between `exo-http-client` and `confined-fetch`, and the `@endo/fetch` wrapper).
- Panel-8 will decide whether any of these need fixing.

**CI**
- The first full run was red on three jobs, none attributable to this PR:
  - `test (24.x, ubuntu-latest)` and `cover (22.x, ubuntu-latest)` failed the `@endo/sandbox` test "bwrap timeout and repeated cancellation reap process groups".
  - `test (24.x, macos-15)` failed `http-content-plane.test.js` on the Node 24 undici `ClientDestroyedError` ("Cannot assign to read only property 'message'").
- I reran the failed jobs, and `ci-wait-merge.sh --no-merge` then returned rc 0 (GREEN).
- The next panel round should expect the bwrap and `ClientDestroyedError` flakes to recur on this repo.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1588-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 268 tokens (15064017 cached reads)
- Output: 55317 tokens
- Cost: $5.402709700000001
- Wall-clock: 11674s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
