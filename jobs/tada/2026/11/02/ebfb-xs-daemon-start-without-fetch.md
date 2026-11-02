I opened draft PR [endojs/endo-but-for-bots#1637](https://github.com/endojs/endo-but-for-bots/pull/1637). It adds a CI lane that runs the daemon's tests under endor's XS manager, and the lane passed on CI (30 tests). It is stacked on #1598, without which the lane would be red. Two unrelated checks on the PR are red.

**Part 1: the daemon starts on the XS manager.** `llm` had already fixed this in c13b771b13, after #1538's base was cut, so this PR changes no daemon code. That commit moved the `fetch` check out of plane construction and into the plane's `fetch()`. The decision, as stated in the PR:
- The `http` web-seed plane is always registered.
- Without `globalThis.fetch`, sourcing a locator still works.
- Loading a `ws` web-seed fails for that one source, and `loadContent` moves on to the next source or the in-band readable.

I confirmed on `llm` (48d6f3e08b) with a release `endor`: the daemon starts, but 6 of `content-store-gc`'s 9 tests fail with `extensible object` (resizable host buffers). The still-open #1598 fixes that, so the PR is based on a snapshot of #1598's head (`xs-manager-test-rust-840215a`). On that base all 9 pass.

**Part 2: the CI lane.**
- **`.github/workflows/ci.yml`**: a new `test-daemon-rust` job. It builds the release `endor` after generating the XS bundles (including the moddable submodule), then runs `yarn workspace @endo/daemon test:rust` on 8 files: `content-store-gc`, `cross-supervisor`, `floot-attachments`, `gateway`, `mail-lifecycle-help`, `marshal-publication`, `request-result`, `retention-paths`. Like the `test` job, it moves the checkout to a shorter path so the daemon's socket paths stay under the Unix limit.
- **`scripts/ci-changes.py`**: schedules the lane wherever `build-xsnap` runs, since both depend on the same inputs.
- **`scripts/test-ci-changes.py`**: a new test for that selection; all 39 tests pass.

How I sized it: one run of every daemon test file except `endo.test.js` under `test:rust` gave 1236 passed, 42 failed, 47 skipped across 117 files. The lane takes the files that start a daemon and pass in full. `channel` (about 8 minutes) and `endo.test.js` (about 35 minutes) also pass but are left out for length. The files that still fail on the XS manager are listed in the PR body.

**CI on #1637:** the new lane took about 9 minutes (build about 5, tests about 2.5). The pre-push gates passed. Two other checks failed:
- `test-ironhorse-oracle` fails on #1598 too.
- `sandbox-drivers` failed one bwrap timeout/cancellation test (`bwrap timeout and repeated cancellation reap process groups`), which this CI-only change doesn't touch. #1538 is working on bwrap cancellation. I couldn't re-run it while the rest of the run was still going, so whether it's a flake is unconfirmed.

**Follow-ups:**
- #1637 can't merge before #1598. After #1598 lands it needs a rebase onto `llm`.
- Once #1538 is rebased onto this, add its scratch-mount symlink test to the lane's `content-store-gc` coverage; it is already in that file, so it runs automatically.
- Getting the excluded files passing on the XS manager (restart durability, teardown, error traces, Floot journals, part of `git`/`git-remote`/`registry-endo`) is separate work, after which they can join the lane.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-xs-daemon-start-without-fetch.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 146 tokens (7788877 cached reads)
- Output: 32737 tokens
- Cost: $3.2554513999999997 (1 engagement(s) unpriced)
- Wall-clock: 13114s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
