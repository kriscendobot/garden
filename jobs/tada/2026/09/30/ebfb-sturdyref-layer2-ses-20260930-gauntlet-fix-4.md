---
orchestration-failed: true
---
Round-4 fixes are pushed to PR #1391 (head `2a14a08e3fe`), but CI came back **red** (`ci-wait-merge` rc 3). One of 33 checks failed, and it looks like an unrelated flake.

**What I changed, for the three reviewers who requested changes:**
- **changeset-auditor:** the `ses` changeset now says `major` instead of `minor`. It also says outright that a `lockdown` that used to succeed can now throw, which is why this is a breaking change. Commit `2a14a08e3`.
- **scribe** (and the same accessor point from breaker, saboteur, purist, engine-realist and corner-prober): `assertSturdyRefShape` in `packages/ses/src/intrinsics.js` now reads `globalThis.SturdyRef` once through its property descriptor and refuses a getter. So no getter runs, and the value it checks is the same value lockdown later captures. Commit `54760f44c`.
  - New `sturdyref-accessor.test.js` uses a getter that returns a valid-looking constructor on the first read and a different function after. It fails on the previous head and passes now.
  - New `sturdyref-non-function.test.js` covers `globalThis.SturdyRef = 42`, a case corner-prober and breaker noted had no test.
- **pruner:** I rewrote the PR description from 411 words down to 200. It isn't on the PR yet (see the handoff below).

**Local checks:** the 13 related `ses` tests pass, and `eslint`, `prettier --check` and `yarn lint:types` are clean on the files I touched.

**The PR description and completion comment are handed off.** This host's bot token gets a 403 on PR writes to endojs. I posted job `ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4-prwrite`, pinned to `endolin-garden-ece02cb4`. It will replace the PR description and post the round-4 summary comment. That comment lists each fix and each item I declined, with reasons:
- **breaker #1** (`new.target` check): belongs to the constructor in `packages/sturdyref`, which is layer 1 (#774), not this PR.
- **integrator #1** (regroup the commits): left for a clean-up before this goes upstream.
- **purist #1:** the different binding shape in the start compartment is the intended design from layer 1.
- **Other comment-only items:** left as follow-up candidates.

**CI:** 32 of 33 checks passed. The one failure is `test (22.x, macos-15)`, in `@endo/daemon` `test/endo.test.js`: an unhandled `Error: Termination requested`, which looks like a race when the daemon shuts down. The daemon code doesn't touch the `SturdyRef` shape check, and the other test jobs passed. I tried to rerun just that job, but the token here can't rerun Actions (403), so the retry needs a capable host or a maintainer.

I didn't re-run the panel, as the job instructs. My attempt to read my inbox timed out because this host's journal clone is slow, so any messages sent to me went unread.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3112275 cached reads)
- Output: 15969 tokens
- Cost: $1.7003949999999997
- Wall-clock: 4781s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
