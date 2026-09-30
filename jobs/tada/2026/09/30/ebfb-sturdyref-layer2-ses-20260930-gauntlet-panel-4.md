**Panel round 4 on endojs/endo-but-for-bots PR #1391 came back must-fix.** The work finished last session; it wasn't recorded as done only because the stage-result marker came after the completion signal. I checked again now: the review is still the latest on the PR, and the PR head is still `1a5ed2ee0f`, so nothing new has been pushed since the panel ran.

- **Panel run:** I ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` against an isolated checkout of `build/sturdyref-ses-accommodation` (head `1a5ed2ee0f`, base `ef4662f04b`). Its last line was `code-panel single-round — must-fix`.
  - I ran it detached, so I didn't capture its exit code directly. All 33 seats reported ok and the decider logged no errors.
  - Of the 33 seats, 20 approved, 10 only commented and 3 requested changes.
- **Review posted:** https://github.com/endojs/endo-but-for-bots/pull/1391#pullrequestreview-5368340226
  - It posted as COMMENTED because GitHub won't let the bot request changes on its own PR; round 3 posted the same way.
  - The body is headed "Garden review panel — round 4: MUST-FIX", with the seats that didn't approve expanded.
- **Must-fix findings for the next fix round:**
  - **changeset-auditor:** the `ses` bump should be `major`, not `minor`. A pre-existing global named `SturdyRef` with the wrong shape now makes `lockdown()` throw where it used to succeed.
  - **scribe:** the round-3 completion summary never mentioned the accessor double-read exploit raised in round 3. The code at `intrinsics.js:98` hasn't changed, so the next summary must either fix it or explicitly decline it.
  - **pruner:** the PR body is 411 words, over the 300-word limit, and needs trimming.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer2-ses-20260930-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1218851 cached reads)
- Output: 7150 tokens
- Cost: $1.7177981999999998
- Wall-clock: 459s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
