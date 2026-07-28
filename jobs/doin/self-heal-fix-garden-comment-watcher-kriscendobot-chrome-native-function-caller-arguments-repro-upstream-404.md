Close the post-arming hole in the fork-watch dead-upstream guard, and disarm the one repo already stuck in it.

Failure signature: `garden-comment-watcher@kriscendobot-chrome-native-function-caller-arguments-repro` exits 1 every tick with
`[comment-source] WARN: gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro/{issues/comments,pulls?state=open,pulls/comments} failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)` → `FETCH INCOMPLETE ... exiting nonzero so the watcher freezes the cursor` → `FATAL: comment source failed`. Confirmed dead upstream: `gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro` → 404, `git ls-remote https://github.com/kriscendobot/chrome-native-function-caller-arguments-repro` → `Repository not found`.

1. `scripts/jobs/fork-watch-provisioner.sh`, DISCOVER loop (~lines 200–225): the `upstream_exists` liveness check currently runs only inside the `if ! tip_has "repos/$slug" || ! tip_has "comment-repos/$slug"` arm-time branch, so an own fork deleted *after* it was armed is never re-checked and its watchers FATAL-flap forever. Hoist the liveness classification so it also covers **already-armed** slugs: for each own-fork bare clone not already tombstoned, classify upstream; on a definitive 404 (`ur=1`) add the slug to `DEAD` regardless of whether it is already in `repos/`/`comment-repos/`. The existing §1a tombstone block already writes `watch-optout/$slug` and `git rm`s both arming records, so it handles the disarm once the slug reaches `DEAD`. Keep the inconclusive case (`ur=2`) a pure defer — never tombstone on an ambiguous check, and never on a transient network/rate-limit error.

2. Cost guard: the liveness check now runs for every own-fork clone on every tick (25 clones on this host), not just unarmed ones. Rate-limit it — e.g. only re-check an already-armed slug when its watcher is failing, or memoize per slug with a coarse interval (a `last-checked` stamp under the state dir, or check at most every Nth tick) — so a healthy 25-fork shelf does not spend 25 `gh api` calls per tick. Preserve the guarded-capture idiom already documented at the call site (`if upstream_exists ...; then ur=0; else ur=$?; fi`) — a bare call would `set -e` the tick.

3. Immediately disarm this repo so the flap stops without waiting on the fix: race a journal commit adding `watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` (use `write_dead_tombstone`'s wording — `reason: upstream 404 (deleted or renamed fork)`) and removing `repos/kriscendobot-chrome-native-function-caller-arguments-repro` and `comment-repos/kriscendobot-chrome-native-function-caller-arguments-repro`. Then stop the templated units for that instance on this host. Optionally prune the stale bare clone `worktrees/kriscendobot-chrome-native-function-caller-arguments-repro.git`, but the tombstone is what makes the unwatch durable against the reconciler.

4. Regression check: verify a slug that is armed in both sets *and* has a 404 upstream gets tombstoned and disarmed on the next `fork-watch-provisioner.sh` tick, and that a live fork with an inconclusive (non-404) `gh` error is left untouched.

<!-- garden-reaped: 1 -->

<!-- garden-productive-cycle -->
---
claim:
  host: ps23
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-28T05:03:29Z
