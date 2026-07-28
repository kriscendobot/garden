Close the dead-upstream gap for ALREADY-ARMED own forks, and disarm the concrete dead slug `kriscendobot-chrome-native-function-caller-arguments-repro`.

Failure signature (recurring, all four per-repo watchers for this slug):
  [ci-pr-source] WARN: gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro/pulls?state=open&per_page=100 failed (definitive, rc=1); not retrying: gh: Not Found (HTTP 404)
  [dependabot-watcher/kriscendobot-chrome-native-function-caller-arguments-repro] FATAL: dependabot PR source failed ... (rc=1)

Verified state: `gh api repos/kriscendobot/chrome-native-function-caller-arguments-repro` 404s and no renamed successor exists under `kriscendobot`; the bare clone `worktrees/kriscendobot-chrome-native-function-caller-arguments-repro.git` still points at the dead URL; the slug is armed in journal `repos/` and `comment-repos/` (auto-provisioned 2026-07-17) with no `watch-optout/` tombstone; `garden-ci-watcher@` and `garden-comment-watcher@` for the slug are in `failed`, `garden-dependabot-watcher@` restarts.

Root cause: `scripts/jobs/fork-watch-provisioner.sh` runs its `upstream_exists` dead-upstream guard ONLY inside the DISCOVER branch, i.e. for slugs missing from `repos/`/`comment-repos/` (see its own comment near the `upstream_exists` definition: "Already-armed forks never reach this check"). It covers "never arm a fork that is already dead" but not "disarm a fork that dies after it was armed". `scripts/jobs/dependabot-watcher.sh:161` and the matching path in `scripts/jobs/ci-watcher.sh` treat a definitive repo-level 404 as structural → `die`, which is correct for a real bug but makes a permanently-deleted repo a perpetual restart storm.

Do two things:

1. Reconcile armed forks. In `scripts/jobs/fork-watch-provisioner.sh`, add a throttled dead-upstream sweep over own-fork slugs that ARE armed (in `repos/` and/or `comment-repos/`, owner in `config/fork-owners`), reusing `upstream_exists` and its exit contract (0 exists / 1 dead / 2 inconclusive → defer, never tombstone on inconclusive). On a definitive 404, take the SAME action the DISCOVER path already takes for dead candidates: `write_dead_tombstone` to `watch-optout/<slug>`, `git rm` `repos/<slug>` and `comment-repos/<slug>`, and push via the existing `commit_and_push` retry/backoff loop. Throttle so this does not become one gh call per armed fork per tick — e.g. a journal/state cursor that re-checks each armed slug at most once every ~24h, or sweep a small rotating slice per tick. Say in the log line what was swept and what was deferred.

2. Stop the flap locally. Disarming in the journal must actually take the per-repo units down on hosts: make sure the per-repo watcher reconciler that installs `garden-{triager,comment-watcher,ci-watcher,dependabot-watcher}@<slug>` timers also STOPS+DISABLES instances whose slug has left the watch sets / gained a `watch-optout/` tombstone, and clears their `failed` state (`systemctl --user reset-failed`). If no such teardown exists today, that is the real reason a tombstone alone would not have quieted this host.

Also consider (secondary, do not let it block the above): in `dependabot-watcher.sh` and `ci-watcher.sh`, distinguish a definitive REPO-level 404 (`gh api repos/<owner>/<name>/...` Not Found) from other structural failures, and on that specific signature log one loud WARN naming the slug and exit 0 instead of `die` — the repo's disappearance is now handled by the reconciler above, and a flapping unit adds nothing but noise. Keep auth/malformed/partial-list failures dying loud; the "never mistake a broken enumeration for no open PRs" guarantee must survive (exiting 0 here must not post or close anything, just skip).

Extend the existing harnesses rather than adding new ones: `scripts/jobs/test/fork-watch-provisioner-test.sh` already has case G (a not-yet-armed fork whose upstream 404s is tombstoned) and drives the check hermetically via `GARDEN_FORKWATCH_UPSTREAM_CHECK` — add the mirror case: an ALREADY-armed fork whose upstream 404s is tombstoned and has both arming records removed, plus an inconclusive-check case that changes nothing.

Finally, garbage-collect the concrete instance: after the reconciler lands (or as a one-shot in the same job), ensure `watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` exists on `journal2` with `repos/`+`comment-repos/` entries removed, stop/disable/reset-failed the four `@kriscendobot-chrome-native-function-caller-arguments-repro` units, and remove or clearly mark the stale bare clone `worktrees/kriscendobot-chrome-native-function-caller-arguments-repro.git` so a future DISCOVER pass does not re-litigate it.

---
claim:
  host: ps23
  gardener: 1
  worker_kind: gardener
  claimed_at: 2026-07-28T01:06:22Z
