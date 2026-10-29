Panel round 1 for endojs/endo-but-for-bots PR #1565 ("feat(exo-git): structured Git.diff with a diffText porcelain sibling", still a draft) came back **must-fix**.

- **Pinned pair:** base `9a14ddf660912ed624e2d9047671d43e3a2f0cec`, head `42a99067d448afed450e853b901dfad61b5c256e` on `endojs/build-daemon-git-next-steps-structured-diff`. I checked out the head in an isolated worktree (`/home/kris/garden/scratch/project-wt-endojs--57ff1a3acf13-5b0c216e`); `git rev-parse HEAD` matched the retained head.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. Its only output was a non-blocking warning: the pruner seat should check the 6-line prose comment at `packages/exo-git/src/git.js:680`.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0 with a must-fix result. It added the decomplector seat because a new mechanism was detected, and pointed the pruner at the PR description. The bot authored the PR, so panel.sh posted the aggregate as a COMMENTED review (2026-10-29T09:02:37Z) under the "Must-fix before merge" heading.
- **Packager findings visible in the review:**
  - The changeset leaves out `@endo/floot` (its system prompt changed) and possibly `@endo/agentry` (an eval scenario changed).
  - The major bump on `@endo/exo-git` and `@endo/git` has no migration guidance. Callers need to be told to use `diffText` for the old string output, and custom `GitBackend` implementers need to know `diffText` is now required.

I did not fix anything or un-draft the PR; the gauntlet's fix stage takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (292113 cached reads)
- Output: 1860 tokens
- Cost: $0.4604146
- Wall-clock: 213s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
