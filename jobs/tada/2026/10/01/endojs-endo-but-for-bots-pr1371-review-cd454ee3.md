The merge is queued and the four follow-ups the review asked to build are parked as build jobs. #1371 itself isn't merged yet.

**Review 5375148317 (kriskowal, APPROVED)** says "conduct and build" and has no inline comments. The recheck preflight found no earlier resolution by a peer (exit 0). PR #1371 is open, still a draft, mergeable (CLEAN), with 25 checks passing and 8 skipped.

- **Conduct:** a conductor job, `endojs-endo-but-for-bots-pr1371-conduct`, was already on the board, posted by the approval reconciler. It will un-draft #1371 and merge it after re-checking it. I didn't post a duplicate.
- **Build:** I read "build" as building the named follow-ups listed in #1371's live-turn evidence comment. I parked one builder job for each item still open. Each is blocked on the #1371 merge, so it starts from `llm` with #1371 already in it:
  - `build-endo-claude-broker-catalog-pruning` (item 2): the guest broker serves only the allowed tools instead of relying on claude's `--allowedTools` flag.
  - `build-endo-claude-sandbox-bwrap-slice` (item 3): a kernel-level bwrap sandbox around `claudePath`, so the daemon socket can't be reached.
  - `build-endo-guest-scoped-daemon-bootstrap` (item 4): a daemon connection scoped to one guest, so the harness no longer holds host-level access.
  - `build-endo-claude-pinned-cli-bump` (item 5): raise the pinned CLI from 2.1.232 to the deployed version after re-running the negative confinement checks.
  - Item 1 (tools that create identifiers or locators) is already covered by job `endojs-endo-but-for-bots-pr1371-3ab5ee33`, posted for kriskowal's earlier comment.
  - Item 6 (the credential residual) is a known limitation with nothing to build, so it has no job.
- **Reply:** I posted a comment on the PR listing these jobs: https://github.com/endojs/endo-but-for-bots/pull/1371#issuecomment-5925318188

If kriskowal meant something narrower by "build", the four parked jobs can be dropped from `plan/`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1371-review-cd454ee3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (425488 cached reads)
- Output: 4713 tokens
- Cost: $0.6233415999999999
- Wall-clock: 105s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
