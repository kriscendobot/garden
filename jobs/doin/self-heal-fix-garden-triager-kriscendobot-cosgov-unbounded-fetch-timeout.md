In `scripts/jobs/triager.sh`, the watch-target fetch at line 117 (`git --git-dir="$BARE" fetch -q --all --prune || die "fetch failed for $slug"`) is the only remaining **unbounded** git fetch in the fleet, so a half-open/stalled connection hangs it until systemd's start-timeout SIGTERMs the unit — the exact captured signature (`Terminated` then `FATAL: fetch failed for kriscendobot-cosgov`, exit 1). Wrap this fetch in the same bounded discipline used everywhere else (`bounded_clone` at line 88, `_journal_git_fetch`, and `clone-keeper.sh`'s `bounded_fetch`): run it under `timeout --kill-after="$GARDEN_FETCH_KILL_AFTER" "$GARDEN_FETCH_TIMEOUT"` with `GARDEN_FETCH_RETRIES` bounded attempts (all three already defined in `common.sh:203–218`). On final failure, classify the error with `is_transient_git_error` (`common.sh:289`): if transient (rc 124/137, DNS/handshake/i-o-timeout), `log` a WARN and `exit 0` to skip the tick and retry next timer fire rather than `die`ing the service to exit 1; keep the loud `die` only for a structural failure (auth/refspec/repo-corrupt). This converts an ambient network hang into a bounded, retriable, self-classified skip and stops it from wedging the unit and re-triggering the self-heal responder.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 15
  worker_kind: gardener
  claimed_at: 2026-07-18T17:24:33Z
