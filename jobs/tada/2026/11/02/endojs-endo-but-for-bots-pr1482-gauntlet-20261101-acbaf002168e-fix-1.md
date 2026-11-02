---
orchestration-failed: true
---
Writing the completion report: the fixes are pushed, but CI came back red on bwrap tests that this change doesn't touch.

orchestration-failed: true

# FIX round 1 — endojs/endo-but-for-bots PR #1482: fixes pushed, CI red on tests outside this change

I applied the panel's must-fix items and pushed them, but CI finished red (`ci-wait-merge` returned rc 3). The failing tests are bwrap sandbox tests in another part of the repo, not anything this change touches.

## What I did
There was no pre-pass block in the job, so I worked from the latest panel review (5730907615, "Must-fix before merge").

I used an isolated checkout of `endojs/endo-but-for-bots` on branch `build/ocapn-noise-session-reconnect-crossed-hellos`. One follow-up commit, **`ac167c2f8b`**, was pushed with `safe-push-pr-head.sh` in advance mode (acbaf00216 → ac167c2f8b).

**Pruner items 1–6:**
- **Repeated tie rule:** cut "and exactly one side did" from the JSDoc in `crossed-hellos.js` and deleted the matching comment in `reconnect.test.js`.
- **Repeated test sentence:** deleted the second copy of the held-dials sentence in `reconnect.test.js`.
- **Backoff comment:** cut from four lines to one.
- **`types.d.ts`:** the `ReconnectOptions` JSDoc no longer restates the README paragraph; it now points to README § Session reconnect.
- **`network.js`:** deleted the comment that described the branch below it ("Either side redials…").
- **PR body:** removed "Documentation Considerations", cut "Testing Considerations" to one sentence, and merged Description bullets 1 and 2 into one. Bullet 3 (why `settle` cannot arbitrate) stays.

**Decomplector #1:** I kept the deference mechanism and did not redesign it. The finding allows this if the PR body explains why "first valid dial wins, plus backoff" is not enough. I added a section, "Why deference rather than first-valid-wins", making three points:
- Design § 3 steps 3–4 say the winner refuses the inbound dial before attaching anything.
- With symmetric timing, first-valid-wins leaves each side attached to a different transport instance, and the retries cross again.
- The time bound on deference and accepting any later epoch both still need a maintainer ruling (this also covers decomplector #3).

Not changed:
- Decomplector #2 and #4 are should-fix and comment-only.
- Pruner #7 was marked "acknowledge", so the design doc's "Settled" paragraph is unchanged.

## CI result: red (rc 3)
Five jobs failed: test 22.x and 24.x on ubuntu, cover 22.x and 24.x, and sandbox-drivers. They all fail in the same two bwrap tests:
- `bwrap › prlimit nproc cap is enforced inside the slice`, with `/bin/sh: 1: ulimit: Illegal option -u`
- `bwrap › bwrap parent death leaves no owned process group`, which reports "Test finished without running any assertions"

This commit changes only comments and docs, and every ocapn-noise test passed in the same run, including all the crossed-hellos and reconnect cases. The previous head (acbaf00216) was green on 2026-10-17, so the bwrap failures most likely come from a change in the CI runner environment since then. That matches a known pre-existing bwrap failure whose fix is PR #1566.

## Follow-ups
- These bwrap reds will block every PR until #1566 (or an equivalent) lands. After that, rerun CI here; this PR shouldn't need further changes.
- The decomplector's main objection, deference versus first-valid-wins, needs a maintainer ruling before any more work on this mechanism.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1482-gauntlet-20261101-acbaf002168e-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1719658 cached reads)
- Output: 10430 tokens
- Cost: $1.1289315999999998
- Wall-clock: 2413s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
