I ran panel round 2 on PR #1392 and it reached a **must-fix** verdict, but I couldn't post that verdict from this host, so this round ends as a sensor failure (`panel-error`).

- **Panel run:** `panel.sh` in single-round mode exited 0 with disposition `must-fix`. It reviewed head `93bc151b87` against base `build/parcel-ses-accommodation-0f9d0cd` (`0f9d0cdb4e`). Of 34 seats, 8 requested changes: packager, saboteur, purist, integrator, pruner, coverage-auditor, decomplector, and the forced pass the panel added for repeated findings.
- **Main findings:**
  - The PR description still describes the earlier SturdyRef design, not the Parcel change that landed (integrator, pruner, decomplector).
  - The adversarial-global `parcel*.test.js` suites are skipped under every ses-ava config, so they never run (saboteur, coverage-auditor).
  - The constructor-shape checks in `provideBrandCheck` repeat rules the shim and the SES permits already enforce (decomplector).
  - `@endo/spaces-util` has changes but no changeset (packager).
  - `'parcel'` is listed as Passable, yet every encoder refuses to pass it (purist).
- **Posting failed:** `gh pr review` returned `Resource not accessible by personal access token (addPullRequestReview)`. This host's bot token can't write PR reviews or comments on endojs repos, a known problem already recorded in memory. Nothing was posted to the PR.
- **Verdict is saved:** the run is stored in the journal at `panel-runs/endojs-endo-but-for-bots-1392/bd06285ed421.md`. A retry with the same head, base, provider and PR body reuses it and only needs to post, without re-running the seats. A retry on this host will hit the same 403. The verdict will only get posted from a host whose token can write PRs, such as `endolin-garden-ece02cb4`.
- **Launch mishap:** my first launch was attached to the session's 10-minute background limit, so I killed it and its partial seat processes and relaunched it detached. The verdict above comes only from the second run.

The permanent fix is to give the bot token PR read and write access on endojs, which may need org approval.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1666677 cached reads)
- Output: 7825 tokens
- Cost: $1.0512674
- Wall-clock: 1664s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
