---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
In scripts/jobs/triager.sh, the two cursor-get.sh guards added in 73c2432e89 (activity cursor around old_sha, failcount cursor around fail_state) only skip the tick with `exit 0` when `is_environmental_rc "$rc"` is true (rc 75). But cursor-get.sh's underlying sync_clone (scripts/jobs/common.sh) also `die`s with plain rc=1 (common.sh:5887, 5891) whenever a journal fetch fails and the stderr doesn't match `_fetch_stderr_is_offline`'s signature list — a real gap, since transport error text varies across git/curl/OpenSSH versions and the signature list is necessarily incomplete. That rc=1 path is NOT covered by is_environmental_rc, so triager.sh still hard-dies (observed: "FATAL: cursor-get.sh failed for activity/kriscendobot-endo-but-for-bots (rc=1)", garden-triager@kriscendobot-endo-but-for-bots, 2026-09-18 16:25:40, well outside the 04:50-05:16Z outage window the prior fix targeted).

Fix: at both call sites, treat ANY nonzero rc from cursor-get.sh as fail-open (WARN + exit 0), not just is_environmental_rc(rc). A cursor read is inherently best-effort — the existing comment above the activity-cursor block already establishes that a stale/unreadable cursor just re-triages next tick, never loses data — so there's no failure mode here that should hard-crash the unit. Drop the `is_environmental_rc` gate and the `die "cursor-get.sh failed ..."` fallback entirely for these two call sites; always WARN-and-skip on nonzero rc.
