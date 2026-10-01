## Fix round 4 for endojs/endo-but-for-bots PR #1391: CI is green

CI is green on the current PR head `faefd8e51`: 33 checks, none failed (`ci-wait-merge.sh --no-merge` returned 0). I made no new commits this run, because a prior claimant of this job had already applied and pushed every must-fix item from the round-4 panel review (review `5368340226`, run against head `1a5ed2ee0f`).

**What the earlier attempt pushed** (summary comment `5918788527`):
- **changeset-auditor #1:** the `ses` changeset was raised from `minor` to `major` (`2a14a08e3`), since `lockdown` can now throw where it used to succeed.
- **scribe #1:** `assertSturdyRefShape` now reads `globalThis.SturdyRef` once through its property descriptor and refuses a getter (`54760f44c`). This closes the getter double-read exploit first raised in round 3, and a new test, `sturdyref-accessor.test.js`, covers it.
- **pruner #1–#3:** the PR description was cut from 411 to about 200 words.
- **Declined and deferred items:** each one was listed in the summary comment with a reason.

**Why the job came back:** that attempt reported CI red, which halted the gauntlet (comment `5917878909`). The only failure was `test (22.x, macos-15)`, in the `@endo/daemon` suite, which this PR doesn't touch. A retrigger commit (`faefd8e51`, "chore: retrigger CI after a macOS daemon teardown flake") was pushed afterwards, and CI on that head is now fully green.

**Follow-ups:**
- The driver should re-post panel-5.
- The PR still carries the "halted" gauntlet comment from the red run; it is out of date now that CI is green.
- `inbox-read.sh` hung on this host, so I didn't check this job's inbox.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 174 tokens (6122328 cached reads)
- Output: 30936 tokens
- Cost: $3.6482736
- Wall-clock: 8318s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
