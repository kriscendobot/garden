Pushed to `main2` (commit `33825c2551`). Job complete.

## Completion report

**What the job asked:** the fleet's single `gh` PATH chokepoint (`scripts/jobs/bin/gh`) exec'd the real `gh` with no timeout at any of its exit points, so a hung invocation (stalled TCP connect, DNS stall, blocked credential-helper prompt) ran as an unbounded foreground child that no caller trap could reap — the 2026-09-18 04:22 comment-watcher incident (blew 900s `TimeoutStartSec`, needed a hard SIGKILL past its 20s stop window). Add a default timeout bound at this one chokepoint.

**What I changed** (`scripts/jobs/bin/gh`, one file):
- Added a `_gh_timeout` command-prefix array, built once after `real_gh` is resolved: `timeout --signal=TERM --kill-after="${GARDEN_GH_KILL_AFTER:-10}s" "${GARDEN_GH_TIMEOUT:-60}s"`. It is **empty** (a no-op) when `timeout` is unavailable or when disabled with `GARDEN_GH_TIMEOUT=0`, so opt-out behavior is unchanged.
- Prepended that prefix to **every** real-gh invocation — not just the three exit points named in the spec but also the identity token lookup (`gh auth token`), which is exactly where a blocked credential-helper prompt hangs:
  1. token resolution (`env -u GH_TOKEN … auth token`)
  2. the pr-job-marker rewrite exec
  3. the comment-provenance rewrite exec
  4. the final `exec "$real_gh" "$@"`

**Why this shape:** bounding here — the single PATH chokepoint every fleet `gh` call crosses — gives direct calls, `gh_api_retry`, and handler scripts hang protection without auditing every call site (the inconsistent ad-hoc `timeout` wrapping the spec described). `timeout` returns 124 on expiry (137 if the kill-after SIGKILL was needed), which callers already treat as a gh failure; a hung read degrades through the existing warn-and-fallback path.

**Verification:**
- `bash -n` clean; shellcheck shows only the four pre-existing SC1091 source-follow infos, none from this change.
- Stub-`gh` end-to-end tests confirmed: normal read passes through; a hung `gh api` is reaped at the bound (rc 124, elapsed = timeout); `GARDEN_GH_TIMEOUT=0` opt-out leaves normal calls working; a hung `gh auth token` lookup is bounded and degrades to the read-only warn path within the timeout.

**Follow-ups:** none required. The 60s default is generous for the fleet's `gh` usage (no `--watch`/long-poll gh calls exist; the longest are `--paginate` comment fetches, well under 60s in practice) and is tunable per-call via `GARDEN_GH_TIMEOUT`/`GARDEN_GH_KILL_AFTER` if a genuinely long call ever appears. Takes effect fleet-wide on the next deploy of `main2`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gh-wrapper-timeout-bound.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (747279 cached reads)
- Output: 8665 tokens
- Cost: $1.0555535
- Wall-clock: 148s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
