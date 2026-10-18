Panel round 1 for kriscendobot/endo PR #2 came back **must-fix**, and I posted the verdict on the PR.

**Setup**
- Pinned the PR at base `2708caccafa70a88dc70e900c781f59b20eb5fb3` and head `51deac396c51f5eb5fe606025dedd76c50e72f08` (branch `kriscendobot:cjs-module-analyzer-upstream-2.2`).
- Made an isolated checkout at `/home/kris/garden/scratch/project-wt-kriscen-e300c53a773f-b2299a9a`, detached at the head; `git rev-parse HEAD` matched.

**Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` passed with exit 0 and no output.

**Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 2 <base>` exited 0 with disposition **must-fix**. All 33 seats returned ok, and the run was recorded at `panel-runs/kriscendobot-endo-2/9d80553f3f95.md`. The two must-fix items:
1. **No changeset** for `@endo/cjs-module-analyzer`. The package is published (1.0.11), and the set of exports it detects changes: quoted export names, escape decoding, and the `strictReserved` filter removed. Six seats raised this: changeset-auditor, releaser, packager, curator, migrator and integrator.
2. **The PR body doesn't follow `.github/PULL_REQUEST_TEMPLATE.md`.** The deterministic template check flagged it, which forced the integrator seat and the must-fix result. Seven template headings are missing and four headings are not in the template.

The should-fix findings are mostly missing tests: an empty-string export name, two spellings of the same name collapsing to one export, and escaped names under `unsafeGetters`.

**Posting the review**
- This host's deployed `panel.sh` is older than `main2`. Commit 8c13456a5e7, where the script posts its own review, hasn't been deployed here, so the script posted nothing and I posted the aggregate by hand.
- The bot authored the PR, so GitHub won't accept a request-changes review from it. Following the new `main2` script, I posted a **COMMENTED** review headed `## Must-fix before merge` on the head commit: https://github.com/kriscendobot/endo/pull/2#pullrequestreview-5564824683
- The full aggregate is 74,814 characters, more than GitHub's 65,536-character limit for a review body. The review therefore holds a must-fix summary plus the first set of seat verdicts. The other seat verdicts went into a follow-up comment ("part 2/2"): https://github.com/kriscendobot/endo/pull/2#issuecomment-6254829399. Together they contain all 33 seat blocks.

**Follow-ups**
- The new `panel_submit_review` in `main2` posts the aggregate in a single `gh pr review` call. On a panel this large it would hit the same size limit and fail, so the stage would come back as panel-error. It needs to split the aggregate or link to it when it's too long.
- The PR is already out of draft (`isDraft: false`). Nothing was changed there.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-endo-pr2-gauntlet-20261007-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1012751 cached reads)
- Output: 5863 tokens
- Cost: $0.8081621999999999
- Wall-clock: 193s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
