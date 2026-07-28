scripts/jobs/fork-watch-provisioner.sh

Extend the dead-upstream guard to cover ALREADY-ARMED slugs, not just arm-time candidates.

Failure signature (recurring, every tick):
```
[ci-pr-source] WARN: gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro/pulls?state=open&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
[ci-watcher/kriscendobot-chrome-native-function-caller-arguments-repro] FATAL: ci PR source failed for … (rc=1)
```
`garden-comment-watcher@kriscendobot-chrome-native-function-caller-arguments-repro` is in the same `failed` state from the same cause.

Root cause: in the DISCOVER loop (`scripts/jobs/fork-watch-provisioner.sh:206`), the `upstream_exists` / auto-tombstone path is nested inside `if ! tip_has "repos/$slug" || ! tip_has "comment-repos/$slug"`. A fork armed in BOTH sets is never re-checked, so a fork DELETED OR RENAMED AFTER arming keeps its arming records forever and its per-repo watchers FATAL-flap indefinitely. The existing guard (added for the kriscendobot/garden 404-flap class) only closes the arm-time case.

Change: add a retirement pass that also runs `upstream_exists` for own-fork slugs that ARE armed, and on a definitive 404 reuses the existing `write_dead_tombstone` + `git rm` of `repos/<slug>` and `comment-repos/<slug>` (`fork-watch-provisioner.sh:180`, `:229-250`) via the same CAS `commit_and_push` loop. `repo-watcher.sh` then reconciles the removed arming records into unit teardown on its next tick.

Constraints, so this does not become a new failure mode:
- Keep the tri-state classification: rc 1 = definitive 404 → tombstone; rc 2 = inconclusive (network/5xx/rate-limit) → defer, NEVER tombstone. A transient blip must not retire a live watch set.
- Consider requiring N consecutive definitive 404s (or a short confirm re-check) before retiring an armed slug — retiring is destructive to a watch set, so it should be harder to trigger than declining to arm.
- Cost: this adds one `gh api repos/<owner>/<name>` per armed own-fork slug per tick (~16 slugs). If that is too much API traffic for the repo-watcher tick cadence, gate the armed-slug re-check to a slower interval (e.g. only when a `.last-upstream-check` stamp is older than an hour) rather than dropping it.
- Preserve idempotence and the peer race: skip any slug a racing peer has already tombstoned (`tip_has "watch-optout/$slug"`).

Also, as the immediate unblock for this specific slug (independent of the code change), land the tombstone by hand so the flap stops now:
- write journal `watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` (the auto tombstone shape: reason `upstream 404 (deleted or renamed fork)`),
- `git rm` journal `repos/kriscendobot-chrome-native-function-caller-arguments-repro` and `comment-repos/kriscendobot-chrome-native-function-caller-arguments-repro`,
- let `repo-watcher.sh` tear down the four `garden-{ci-watcher,comment-watcher,triager,dependabot-watcher}@kriscendobot-chrome-native-function-caller-arguments-repro` units,
- and remove the now-dead bare clone `worktrees/kriscendobot-chrome-native-function-caller-arguments-repro.git` (the tombstone note says to remove the tombstone only after the upstream exists again AND the stale clone is gone).

Add a regression test alongside the existing provisioner fixtures: a slug armed in both sets whose `upstream_exists` stub returns 404 must end up tombstoned with both arming records removed; the same slug with an inconclusive (rc 2) stub must be left untouched.

<!-- garden-reaped: 1 -->
