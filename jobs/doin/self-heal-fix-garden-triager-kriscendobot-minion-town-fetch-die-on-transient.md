In `scripts/jobs/triager.sh`, the existing-clone fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) dies loud on ANY fetch failure, including transient connectivity blips (GitHub outage, DNS, TLS/read timeout, killed connection). On a systemd `Restart=` unit this detonates a FATAL restart storm for the whole outage window — observed here as a single-line self-heal blob: `<3> [triager/kriscendobot-minion.town] FATAL: fetch failed for kriscendobot-minion.town` preceded by `Terminated`.

Harden it the same way `ci-watcher.sh` (~line 254) and the triager's own missing-clone branch (lines 95–103) already handle transient connectivity: capture the fetch stderr to a temp file (the current `-q` suppresses it, so classification has nothing to read), and on failure classify with `is_transient_net_error`/`is_transient_gh_source_error` from `common.sh`. If transient → `log "WARN: fetch for $slug hit a transient network/gh blip — skipping tick (never guess)"` and `exit 0`. Only a structural failure (matches neither classifier) should keep the loud `die "fetch failed for $slug"`, so real breakage (deleted fork, wrong owner/name, auth) is still surfaced. Mirror the exact WARN+exit-0 shape and the stderr-capture (`ERRF`) idiom already used in ci-watcher.sh so classification lives in one place; add/extend a triager unit test asserting a transient-signature fetch stderr yields exit 0 (skip) while a structural one still dies 1.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: cleric
  claimed_at: 2026-07-18T06:14:40Z
