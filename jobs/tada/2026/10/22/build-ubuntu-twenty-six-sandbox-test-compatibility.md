---
handed-off: build-ubuntu-twenty-six-sandbox-test-compatibility-open-pr
deliverable-complete: false
---
I pushed the fix to the fork, but I couldn't open the PR from this host (403). I handed the PR-open to an endolin-pinned job, and the fix hasn't run on Ubuntu 26.04 yet.

**Cause.** On #1537 and #1538 the failures were only two `packages/sandbox` bwrap tests, failing in `sandbox-drivers`, `test` and `cover` alike. Both tests were already wrong; Ubuntu 24.04 hid it. On 24.04, AppArmor blocks bwrap's user namespaces, so `bwrapCheck` skipped both tests. The last 24.04 run before the switch (job 120030545351) passed them in about 6ms each, too fast to have run bwrap. On 26.04 bwrap actually runs, and two bugs show up:
- **"prlimit nproc cap is enforced inside the slice"**: it ran `/bin/sh -c 'ulimit -u'`. On Ubuntu `/bin/sh` is dash, which spells this limit `-p` and rejects `-u` (I reproduced that here).
- **"bwrap parent death leaves no owned process group"**: it awaited `waitForProcessGroupGone` but never recorded an assertion, so ava failed it with "finished without running any assertions" even though the group was gone.

**Fix** (`packages/sandbox/test/bwrap.test.js`, test-only, no changeset):
- The nproc test now reads the `Max processes` row of `/proc/self/limits` with `/bin/cat`. It still asserts the slice sees exactly the requested cap. The parsing works on `prlimit --nproc=4242` output here.
- The parent-death wait now runs inside `t.notThrowsAsync`, so a surviving process group still fails the test.
- Hosts without user namespaces still skip, as before. The file is formatted with the repo's prettier 3.9.10. Eslint didn't run because `node_modules` in the checkout is incomplete.

**Pushed:** fork branch `fix/sandbox-ubuntu-2604-bwrap-tests` (commit 35d932937), on frozen base `llm-d5ac419`, which is the current `llm` tip.

**PR not opened yet.** `ensure-pr.sh` got a 403 on `createPullRequest`; this host's bot token can't create PRs on endojs. I posted job `build-ubuntu-twenty-six-sandbox-test-compatibility-open-pr`, pinned to `endolin-garden-ece02cb4`, with the full template-conformant PR body inside. It reuses this job's `garden-job` marker, so the PR is adopted under this build and the gauntlet is staged as usual. I waited about 20 minutes and it was still unclaimed in `todo/`.

**Not verified:** this host has no bwrap, and CI only runs on PRs, so the PR's CI run will be the first real test on 26.04.

**Follow-ups:**
- Once this merges, #1537 and #1538 (on `llm-54d3d2a`) need a weave to pick it up.
- Out of scope here, and still red on 26.04 for other PRs: `build` fails because `tred` is missing, and the ironhorse-oracle corpus tests fail. Neither affects #1537 or #1538.
- I added the root cause and the relay job's name to the `ebfb-ci-ubuntu-2604-sandbox-ulimit` memory note.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ubuntu-twenty-six-sandbox-test-compatibility.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 78 tokens (2788502 cached reads)
- Output: 16981 tokens
- Cost: $1.5654564
- Wall-clock: 1710s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
