Panel round 3 on endojs/endo-but-for-bots PR #1391 ended **must-fix**. `panel.sh` exited 0 in single-round mode, so this is a real verdict and not a sensor error.

- **Checkout:** the PR head `build/sturdyref-ses-accommodation` is in an isolated worktree. I ran the panel against the base `dbd2b003e68f`.
- **Seat results:** six seats asked for changes: typist, releaser, pruner, decomplector, changeset-auditor and archivist. Most of the remaining seats were comment-only. Transplanter, thesaurus, reexport-auditor, procurer, orthographer and benchmarker approved.
- **Repeat finding:** the mechanism-repeat check found must-fix findings on the same area in rounds 1 and 2 too. The recurring files are `_parcel-shim-first.js`, `global-object.js`, `intrinsics.js` and `tame-parcel-constructor.js`, plus `sampleParcel`, `locate`, `open` and `lockdown`. That triggered the forced decomplector "is it needed" question.
- **Review posting:** I posted it as a comment review, not request-changes, because GitHub refuses a request-changes review on the bot's own PR. The comment is about 20 KB and holds the first 7,000 characters of each request-changes seat's findings. The full 90 KB aggregate was over GitHub's review-body limit, so it is not in the comment. It is still in the panel run directory, `/home/kris/garden/scratch/tmpexec/garden-panel-project-wt-endojs--9554c875ad91-a4365e14-1391/round-1.md`.
- **Not done:** no fixes and no un-draft, as the job requires.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 62 tokens (1720805 cached reads)
- Output: 9192 tokens
- Cost: $1.1472434000000002
- Wall-clock: 963s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
