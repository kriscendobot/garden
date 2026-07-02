In `scripts/jobs/ci-watcher.sh`, harden the per-tick PR loop against the secondary-rate-limit cascade that blinded the whole 03:21–03:22 sweep (every one of ~150 bot PRs returned rc=1). Two parts: (a) Track consecutive unreadable rollup reads (the `*)` fallthrough) with zero successful reads so far this tick; once that count crosses a small threshold (e.g. 3), abort the remaining sweep with one loud WARN ("N consecutive rollup reads unreadable — aborting tick, likely GitHub rate limit") instead of continuing to fire `gh pr view` GraphQL calls at an already-throttled API and deepening the cooldown. (b) Reduce steady-state GraphQL pressure that trips the limit in the first place: activity-bound the enumeration using the 4th column (`updated_at`) the source already emits but the loop currently reads into a throwaway (see the loop comment at line ~184), skipping PRs untouched beyond a window (e.g. GARDEN_CI_ACTIVITY_WINDOW, default a few days) so a tick reads a handful of recently-active PRs rather than every open bot PR. This is the mirror of the default-list-limit lesson: there too few PRs were surveilled; here far too many are, and the fix is a bounded, paced sweep.

---
claim:
  host: endolinbot2
  gardener: 6
  claimed_at: 2026-07-02T03:52:11Z
