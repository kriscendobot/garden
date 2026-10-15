**Clean stage for endojs/endo-but-for-bots#1391 is done: I added one missing test, and CI is green on the new head (33 checks, 0 failed).**

- **Coverage:** the PR adds `packages/ses/src/tame-parcel-constructor.js`. Its existing tests cover the absent, shimmed, accessor, arrow, impostor, misshapen, non-function, plain-function, reentrant, configurable and writable cases. No test reached the shared constructor's `TypeError('Parcel cannot be called or subclassed')` branch, and none checked its `name` or `length`.
- **Dead code:** none. The change leaves nothing unused.
- **Change:** I added a test named "the shared constructor refuses calls and subclassing" to `packages/ses/test/parcel-shimmed.test.js`. It checks that `name` is `Parcel`, that `length` is 2, and that both calling it without `new` and `class extends Parcel` inside a child compartment throw. All 6 tests in that file pass locally, and prettier and eslint are clean.
- **Push:** commit `67ab6031c8` ("test(ses): cover shared Parcel call and subclass refusal") went to `build/sturdyref-ses-accommodation` via `safe-push-pr-head.sh`, advancing it from `0f9d0cdb4e`.
- **CI:** `ci-wait-merge.sh --no-merge` returned rc 0. My first full-deadline wait ran into the tool's 10-minute limit and was stopped, so I polled the checks by hand until they were all done, then re-ran it with a short deadline to get the result.

The PR is still a draft; un-drafting happens later in the gauntlet. No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1283686 cached reads)
- Output: 5734 tokens
- Cost: $0.8285452
- Wall-clock: 4468s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
