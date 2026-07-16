scripts/jobs/issue-inbox-watcher.sh
The source-failure block around line 476 (`if [ "$src_rc" -ne 0 ]; then … die "issue source failed for $REPO …"`) `die`s on ANY nonzero source rc, so a transient gh-api blip (5xx / HTML gateway page / rate-limit / DNS/TLS timeout) crash-loops `garden-issue-inbox`: the observed log shows `[issue-inbox] FATAL: issue source failed for kriskowal/garden (rc=1)` and `garden-issue-inbox.service: Failed with result 'exit-code'` on every single tick across the whole window, during the exact same sustained gh-api degradation that every comment/ci watcher rode out with a WARN-skip.

Fix: before the `die`, add the same transient degrade the sibling watchers already use, reusing the shared classifiers in `scripts/jobs/common.sh` — no new logic:

```
if [ "$src_rc" -ne 0 ]; then
  sed 's/^/  source: /' "$ERRF" >&2 || true
  if is_transient_net_error "$ERRF"; then
    log "WARN: issue source unreachable (transient network) — skipping tick (never guess)"
    exit 0
  fi
  if is_transient_gh_source_error "$ERRF"; then
    log "WARN: issue source hit a transient gh-api blip (5xx/HTML/rate-limit) — skipping tick (never guess)"
    exit 0
  fi
  die "issue source failed for $REPO (rc=$src_rc; see source stderr above)"
fi
```

This keeps the loud-on-structural-failure behavior (auth/404/malformed still `die`) that the existing comment about the 2026-06-24 silent-empty outage is protecting, while stopping a plain GitHub-overload window from marking the unit `failed` and spamming FATAL every tick. Mirror the wording and structure of the `comment-watcher.sh` block (lines ~1146-1167) so the three watchers stay uniform; confirm `is_transient_net_error`/`is_transient_gh_source_error` are in scope (they are sourced from common.sh, same as the siblings).
