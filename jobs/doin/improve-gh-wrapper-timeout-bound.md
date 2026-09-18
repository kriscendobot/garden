---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/bin/gh
The fleet's single `gh` PATH chokepoint (`scripts/jobs/bin/gh`, prepended to PATH by every fleet entrypoint via common.sh) execs the real `gh` binary with no timeout bound at any of its three exit points (the pr-job-marker rewrite call, the comment-provenance rewrite call, and the final `exec "$real_gh" "$@"`). Individual callers bound their OWN gh calls inconsistently — `gh_api_retry` in common.sh (used fleet-wide by ci-watcher, comment-watcher, dependabot-watcher, approval-reconciler, issue-inbox-watcher, mirror-closer, etc.) runs `"$gh_bin" api "$@"` with zero timeout, while comment-watcher.sh's own self-test probe manually wraps its `gh api` call in `timeout --signal=TERM --kill-after=5s 10s` specifically to stay inside the unit's 20s TimeoutStopSec — an ad hoc per-caller pattern that most call sites (including comment-reactji-gh.sh and comment-reply-gh.sh's `gh_api_retry` and raw `gh api --paginate` calls) don't replicate. A hung `gh` invocation (stalled TCP connect, DNS stall, or blocked credential-helper prompt) runs as a foreground child, so no caller's EXIT/TERM trap can reap it until it returns — this matches the observed 2026-09-18 04:22 incident where `garden-comment-watcher@kriscendobot-garden.service` blew its 900s TimeoutStartSec, then required a hard SIGKILL after its 20s graceful-stop window also expired, despite the script's careful stop-budget engineering elsewhere. Add a default bound (e.g. `timeout "${GARDEN_GH_TIMEOUT:-60}s"` around the real-gh invocations in the wrapper, with `--kill-after` margin) at this single chokepoint so every fleet `gh` call — direct, via `gh_api_retry`, or via a handler script — gets hang protection without auditing every call site individually.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-18T04:54:50Z
