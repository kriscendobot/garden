---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
issue-inbox-watcher.sh:386 reads its poll cursor as a bare command
substitution under `set -euo pipefail`:

    last_seen="$("$HERE/cursor-get.sh" "$CURSOR_KEY" | sed -n 's/^last_seen:[[:space:]]*//p' | head -1)"

cursor-get.sh's sync_clone `exit`s non-zero on any journal-fetch failure
(GARDEN_OFFLINE_RC=75 on an outage, or plain rc=1 per b320648e47's finding
that the offline-signature grep in sync_clone is incomplete). Under
pipefail that non-zero rc trips this script's own `set -e` and kills the
whole tick with NO log message (die() would log "FATAL: ..." first; this
crash produces none), which matches the captured failure: the tail shows
exactly one line — "loaded 8 maintainer(s) from journal:maintainers/allowlist"
— then nothing, exit 1.

Commits 73c2432e89 and b320648e47 (yesterday) already fixed this identical
call shape in triager.sh: capture the rc via `if out=$(...); then rc=0;
else rc=$?; fi`, and on any nonzero rc, `log "WARN: ..."` and `exit 0`
(the tick retries next cycle; a stale/unreadable cursor is best-effort and
never loses data) instead of falling through to set -e.

Apply the same rc-capture-and-fail-open pattern at:
- scripts/jobs/issue-inbox-watcher.sh:386 (the one that just crashed)
- scripts/jobs/comment-watcher.sh:423 (identical unguarded pattern, not yet observed failing)
- scripts/jobs/mention-watcher.sh:83 (identical unguarded pattern, not yet observed failing)

Mirror triager.sh's final (b320648e47) form exactly — WARN + exit 0 on ANY
nonzero rc, no is_environmental_rc gate, no die fallback.
