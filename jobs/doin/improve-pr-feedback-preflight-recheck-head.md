Add a deterministic preflight helper `scripts/jobs/gardening/pr-feedback-preflight.sh` (model it on the existing `scripts/jobs/scholar-preflight.sh`) that a PR-feedback consumer runs BEFORE making any edit. Given `<repo> <pr> <comment-id> [<reviewer-login>]` it: fetches the PR branch HEAD, greps recent commit messages and `pulls/<pr>/comments` inline replies for the triggering comment id (or `Addressed @<reviewer>` / `@<reviewer>'s review`), and exits non-zero (no-op signal) when a peer's resolution citing the same comment is already present. Then reference it from `comment-watcher.sh` `write_job_body` on the non-mechanical (review/attention) path — and from `mention-watcher.sh`'s attention path — so the job body instructs the gardener to run the preflight and no-op cleanly instead of discovering the duplicate at push-time CAS. This moves the unreliable "remember to re-check the live thread" responsibility (today only an agent self-improvement note generalizing `feedback_recheck_thread_before_pushing_queued_infra` to the read side) into a script that runs every time.

---
claim:
  host: endolinbot2
  gardener: 91
  claimed_at: 2026-06-30T04:22:06Z
