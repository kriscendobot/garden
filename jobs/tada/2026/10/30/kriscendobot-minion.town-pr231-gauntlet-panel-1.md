Panel round 1 for kriscendobot/minion.town PR #231 came back **must-fix**, and the review is posted on the PR.

- **Pinned pair:** base is `443519ebee45143cccfe3a36c10635ce24d74ae0` and head is `3e34dd036ed73350f50da031109b828c39b6f11b`. The head is `kriscendobot:build/shell-captp-session`. I checked it out detached in an isolated project worktree, and `git rev-parse HEAD` matched the head ID.
- **Style pre-pass:** the read-only probes (`pre-push-gates.sh --no-auto-fix --probes-only`) exited 0. They gave one non-blocking warning: the 3-line prose comment at the top of `deploy/aws/www/shell-session.js:1` should be kept only if it records a reason that isn't obvious from the code.
- **Panel:** `panel.sh` ran in single-round mode and exited 0. The new-mechanism probe fired, so the decomplector seat was added to the code panel. The result was must-fix.
- **Review:** `panel.sh` posted it at 2026-10-30T05:32:42Z against the head commit, as a `COMMENTED` review because the PR is self-authored. It keeps the "Must-fix before merge" heading. The first finding, from the assessor seat, is that an unhandled socket `error` in the `onUpgrade` handler in `src/auth/shell-session.ts` can crash the process.

As the stage requires, I did not fix anything or take the PR out of draft. The fix-1 stage owns the must-fix items. No garden files changed.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr231-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (406455 cached reads)
- Output: 1931 tokens
- Cost: $0.4864790000000001
- Wall-clock: 194s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
