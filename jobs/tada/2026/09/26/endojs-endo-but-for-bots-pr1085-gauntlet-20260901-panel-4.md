**Panel round 4, endojs/endo-but-for-bots PR #1085: must-fix**

This round's verdict is must-fix: four jury seats asked for changes, so the gauntlet stays blocked until they are fixed.

**What ran:**
- I checked out the PR head (`endojs/endo-but-for-bots@feat/mount-stream-glob-grep`, commit `3ddec2714f`) in its own isolated worktree.
- I ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`) against base `f109e8f4…`. That is the real merge-base and the same base round 3 used. The panel exited 0 with disposition **must-fix**, and the run is recorded at `panel-runs/endojs-endo-but-for-bots-1085/968a088f049e.md`.
- 33 seats reported. The round-3 code fixes hold: assessor, breaker, prover, curator, warden and saboteur all approve.

**Verdict posted:** comment review https://github.com/endojs/endo-but-for-bots/pull/1085#pullrequestreview-5327541553, marked `<!-- garden-panel-verdict: pr=1085 round=4 disposition=must-fix -->`. It is a comment rather than a request-changes review because GitHub doesn't allow request-changes on your own PR, which matches round 3. The full aggregate was 81 KB, too big for one review, so I put the blocking and comment-only seats first. Eleven blocks that approve with no findings were cut, and the review lists them by name.

**Must-fix items for the next fix stage:**
1. **changeset-auditor:** lines 11, 12 and 23 of `.changeset/daemon-mount-stream-glob-grep.md` each hold several sentences. They need one sentence per line.
2. **integrator** (should-fix): `designs/mount-stream-glob-grep.md` (lines 80, 189, 273, 379, 939) still says `streamGrep` reads "one file per pull". The code, changeset and help text say the limit is one *match* per pull, so the design doc needs to match them.
3. **scribe:** commit `aa15e2478632` (the maintainer's ask to make `streamGrep` take a list of files instead of doing its own glob) was only answered in an inline reply. It needs a top-level summary comment.
4. **pruner:** remove the design doc's new `## Status` section (lines 57–62), which repeats the metadata table.

The integrator also noted, without blocking, that the two merge commits and the trail of per-round fix commits should be squashed before the PR leaves draft.

**Not done:** I couldn't drain my inbox because the journal clone timed out (offline, rc=75). As this stage requires, I made no fixes, did not take the PR out of draft, and did not loop.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-gauntlet-20260901-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 6 on 2 host(s)
- Input: 84 tokens (2685011 cached reads)
- Output: 17660 tokens
- Cost: $2.7295667999999997
- Wall-clock: 1641s
- Model(s): claude-opus-4-8 ×5, claude-opus-5-5 ×1

<!-- garden-usage-end -->
