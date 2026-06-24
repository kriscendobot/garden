Every `gh` invocation in this session is being stopped by the permission gate (even read-only `gh pr list` / `gh api` / `gh auth status`). I can't perform the triage without reading the PR state from GitHub, and I've stopped retrying rather than hammer a denied call.

To proceed I need one of:

1. **You approve `gh` read access** (these calls are all read-only against `endojs/endo-but-for-bots`, the only in-scope, contributor-gated repo), and I'll re-run the triage end to end; or
2. **You paste the output** of:
   ```
   gh pr list --repo endojs/endo-but-for-bots --author kriscendobot --state open \
     --json number,title,isDraft,headRefName,updatedAt
   ```
   and I'll assess each PR (checks/draft-chain/feedback) and post the per-PR jobs via `scripts/jobs/post-job.sh`.

Everything else is staged and ready: gardener role brief read, `post-job.sh` interface confirmed (`post-job.sh pr-ebfb-<n>-<action> <body-file>`, idempotent on basename), scope locked to `endojs/endo-but-for-bots` per the monitoring-safety constraint.

Which would you like — approve `gh` reads, or hand me the list?

Note: I am holding the claimed job `triage-open-prs-20260624` (doin) open while blocked; it won't complete (move to tada) until the triage is actually done.
