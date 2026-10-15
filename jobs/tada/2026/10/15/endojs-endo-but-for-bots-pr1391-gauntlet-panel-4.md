Panel round 4 on endojs/endo-but-for-bots PR #1391 returned **must-fix**, but I couldn't post the review from this host, so I'm completing as `panel=panel-error` for the driver to retry on another host.

**What happened**
- I checked out the PR head `3c39e7d2e` (branch `build/sturdyref-ses-accommodation`) in an isolated worktree. I ran `panel.sh` in single-round mode against base `origin/build/sturdyref-shim-first-wins-dbd2b00` (`dbd2b003e6`). It exited 0 with disposition **must-fix**.
- **Seats:** 34 in total. 6 asked for changes (decomplector, archivist, breaker, spec-keeper, integrator, pruner), 16 were comment-only and 12 approved.
- **Repeated must-fix:** the last two rounds (heads `a10a201e` and `17390624`) also raised must-fix findings on the same mechanism (`sampleParcel`, `global-object.js`, `tame-parcel-constructor.js`, …). So the panel put the decomplector's "is this needed?" question to it.
- **The decomplector's answer:** remove `sampleParcel`'s own shape checks (about 100 lines plus about 17 adversarial test fixtures). Instead, read `Parcel` the way `tameUrlConstructor` reads `URL`, and let the existing `%InitialParcel%`/`%SharedParcel%` permit checks do the shape check. Alternatively, explain why the shim has to lock the `Parcel` binding before lockdown. Other seats raised related should-fix items: a configurable `Parcel` binding is accepted although the docs say lockdown throws, the writable-binding rejection only happens by accident, and `tameParcelConstructor` can fail halfway.

**Why I'm reporting panel-error**
- **Posting failed:** both `gh pr review --request-changes` and `--comment` were refused with a 403 (`Resource not accessible by personal access token (addPullRequestReview)`). This host's bot token can't write PR reviews on the endojs org, as recorded for this host.
- **Why not must-fix:** reporting must-fix with no review on the PR would be false. panel-error lets the driver re-post this round under its retry budget, ideally on an endolin host that has PR write access.
- **A retry is cheap:** the run is saved in the journal at `panel-runs/endojs-endo-but-for-bots-1391/8d366db30f85.md` (exit 0, must-fix). While the PR head stays `3c39e7d2e`, a retry reuses these seat verdicts instead of re-running them.
- **Review body:** I trimmed one to 60.6 KB to fit GitHub's 65 KB limit. It includes all request-changes seats in full and every comment-only seat except fast-checker, and leaves out the approve seats' notes. It was saved only in this host's temp directory, so the retry has to rebuild it.

**Follow-up:** the lasting fix is to give the kriscendobot token "Pull requests: write" on endojs, which may need org approval.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1005002 cached reads)
- Output: 5900 tokens
- Cost: $0.8297124000000002
- Wall-clock: 789s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
