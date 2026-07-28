role: fixer
# fork-watch-provisioner never re-checks liveness for an ALREADY-ARMED slug, so a
# fork deleted after arming FATAL-flaps its watchers forever

Maintainer directive (kriskowal, 2026-07-28). Fix in the garden repo itself
(`main2`, DIRECT push, NO PR per CLAUDE.md § Conventions).

## The defect

`scripts/jobs/fork-watch-provisioner.sh` § DISCOVER gates its dead-upstream check
behind a slug being MISSING from a watch set:

    tip_has "watch-optout/$slug" && continue
    if ! tip_has "repos/$slug" || ! tip_has "comment-repos/$slug"; then
      ... upstream_exists → rc 1 (404) → DEAD+=("$slug") → auto-tombstone
    fi

A slug already armed in BOTH `repos/` and `comment-repos/` therefore never reaches
`upstream_exists` again. If its upstream is deleted LATER, nothing re-checks it: all
four per-repo watcher families (`garden-triager@`, `garden-comment-watcher@`,
`garden-ci-watcher@`, `garden-dependabot-watcher@`) keep firing on cadence and each
exits FATAL on `gh: Not Found (HTTP 404)`. The comment-watcher additionally freezes
its cursor by design ("never advance past un-enumerated comments"), so the failure is
permanent, not self-limiting. `self-heal-run.sh` throttles its responder and gives up.

This is why the auto-tombstone fired for `kriscendobot/garden` (partially armed, so it
re-entered the branch) but NOT for `kriscendobot/chrome-native-function-caller-arguments-repro`
(fully armed on 2026-07-17, upstream deleted 2026-07-27). The latter flapped for a day
and was tombstoned BY HAND during a liaison bring-up; see journal commit 7851e2f and
`journal/watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro`.

## The fix

Re-verify upstream liveness for EVERY own-fork bare clone the provisioner walks, not
only ones missing from a watch set — then feed a 404 into the existing `DEAD[]` /
auto-tombstone path (§ 1a), which already drops both arming records and writes the
tombstone in one CAS'd commit. Constraints:

- Preserve the existing rc contract of `upstream_exists`: rc 0 = live, rc 1 = 404
  (tombstone), rc 2 = inconclusive (defer — NEVER tombstone on a network/auth blip).
  Keep the guarded-capture idiom (`if upstream_exists ...; then ur=0; else ur=$?; fi`);
  a bare call is a `set -e` exit.
- Respect `tip_has "watch-optout/$slug" && continue` first — a tombstoned slug must
  never be re-probed or re-armed.
- Mind the API cost: this adds one `gh api repos/<owner>/<name>` per own-fork clone
  per tick. The clone shelf is large, so do NOT probe every armed slug on every tick.
  Rate-limit it — e.g. only re-probe an already-armed slug when its watchers have
  recently failed, or on a slow cadence (once per N ticks / a staleness stamp in
  journal state). Choose the cheapest approach that still self-heals within hours, and
  say in the report which you picked and why.
- The disarm must also stand the units down (or leave them to the existing unit
  reconciler) so the timers stop, not merely drop the journal records. Verify which
  is true today and close the gap if the reconciler does not retire them.

## Definition of done

- An own fork armed in both watch sets whose upstream starts 404ing is auto-tombstoned
  and disarmed without human intervention, within a bounded number of ticks.
- An inconclusive upstream check never tombstones a live fork (regression-guard this
  explicitly — a false tombstone silently unwatches a healthy repo).
- Tests under `scripts/jobs/test/` covering: fully-armed + 404 → tombstoned; fully-armed
  + rc 2 → untouched; already-tombstoned → never re-probed; live fork → untouched.
- CI-equivalent checks run locally BEFORE pushing (a CI failure is an automation defect,
  not something to discover in CI).
- Direct push to `main2`. Report which rate-limiting strategy you chose.
