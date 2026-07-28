scripts/jobs/fork-watch-provisioner.sh
Extend the dead-upstream guard to slugs that are ALREADY armed, moving a hand-repair off the liaison and into the reconciler that already owns arming. The provisioner's `upstream_exists` / `write_dead_tombstone` machinery (§ dead-upstream guard, around lines 147–250) only runs inside the discovery branch gated on `! tip_has "repos/$slug" || ! tip_has "comment-repos/$slug"` — so it classifies a slug MISSING from a watch set, and never re-checks one present in both. A fork armed while alive whose upstream is later deleted therefore flaps forever.

That is exactly what happened: the maintainer deleted `kriscendobot/chrome-native-function-caller-arguments-repro` on 2026-07-27/28 (`gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro` → 404, verified). All four watcher families armed since 2026-07-17 — `garden-triager@`, `garden-comment-watcher@`, `garden-ci-watcher@`, `garden-dependabot-watcher@` — FATAL-flapped against the 404 every tick, and that single slug accounts for essentially the entire `journalctl -p warning` tail for the window on `endolin-garden-ece02cb4`, driving continuous systemd restart churn. The liaison tombstoned it by hand at 2026-07-28T01:08:09Z; the tombstone body at `journal/watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` diagnoses precisely this gate as the cause.

Change: add a liveness reconciliation pass over the ALREADY-armed own-fork set (owner in `config/fork-owners`, not already tombstoned), reusing `upstream_exists` unchanged — 404 → auto-tombstone via the existing `write_dead_tombstone` + arming-record removal path in § 1a; inconclusive (rc=2) → defer, never tombstone on an ambiguous check. Throttle the liveness probe (a cheap read-only `gh api repos/<owner>/<name>` per armed slug, not per tick — e.g. once per slug per hour, or only for slugs whose watchers have recently FATAL'd) so the reconciler does not add a per-tick API call per watched repo. Preserve the existing CAS/retry shape around `commit_and_push` so racing peers collapse onto one tombstone.

Also confirm the disarm is complete end to end: removing `repos/<slug>` and `comment-repos/<slug>` must cause the per-host unit reconciliation in `scripts/jobs/repo-watcher.sh` to stop and disable the corresponding `garden-{triager,comment-watcher,ci-watcher,dependabot-watcher}@<slug>` units. If that reconciler only ever adds units, the tombstone silences the journal record while the flapping units survive, and the fix is incomplete.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: gardener
  claimed_at: 2026-07-28T07:17:08Z
