Report:

## What I found

The job's two halves were already largely done by peers before I claimed it:

- **Code half**: the armed-slug liveness recheck landed on `main2` ~2h earlier as `bb971c9a39` ("fix: recheck liveness of armed fork watchers"), including a four-hourly per-host liveness stamp (the cost gate the job suggested) and regression cases H (armed fork 404s → tombstoned + disarmed) and I (inconclusive → untouched).
- **Manual unblock half**: the liaison had already landed the `watch-optout/kriscendobot-chrome-native-function-caller-arguments-repro` tombstone, `git rm`'d both arming records, and `repo-watcher.sh` had torn down all four unit families. Verified at the real `origin/journal2` tip via `gh api` (not the possibly-stale live worktree): slug absent from `repos/` and `comment-repos/`, tombstone present; `systemctl --user` shows no `*chrome-native*` units and zero failed units.

## What I did

**1. Closed the one gap the peer's fix left open** — the job's constraint that *retiring* an armed watch set should be harder to trigger than *declining to arm*. `bb971c9a39` retires on a single definitive 404. Added, on the armed path only (`scripts/jobs/fork-watch-provisioner.sh`):

- **Confirm re-check** — a first definitive 404 is re-probed once; anything but a second definitive 404 defers to the next tick. One extra API call, only on the rare 404 path.
- **Mass-404 breaker** — if every armed fork probed in a tick 404s and there are ≥2, that is a read-side failure (a token that lost `repo` scope reads a *private* fork as 404, not 401), so nothing armed is retired and `alert_maintainer` fires. A mixed tick — the ordinary one-fork-was-deleted case — still retires normally. The confirm re-check can't catch this class, since both probes ride the same broken credential.

Unarmed candidates keep the single-probe bar (declining to arm is cheap and reversible). Tri-state classification, idempotence, and the `tip_has "watch-optout/$slug"` peer-race skip are untouched.

**2. Regression test case J** in `scripts/jobs/test/fork-watch-provisioner-test.sh` (hermetic, no GitHub): unconfirmed one-off 404 → not retired, exactly one re-probe, no journal mutation; all-armed-404 tick → nothing tombstoned, records intact, warning logged; mixed tick → dead forks retired, live ones untouched. Suite is **43/43 passed**; the J assertions **fail 9-for-9** against the stashed pre-change script, so they aren't vacuous.

**3. Design doc** `designs/auto-provision-fork-watchers.md` § 2 records why retirement carries the extra bar.

**4. Removed the leftover dead bare clone** `worktrees/kriscendobot-chrome-native-function-caller-arguments-repro.git` (316K) — the last unfinished item of the by-hand unblock. Safe: its only registered linked worktree (`project-wt-browser-matrix-chrome-native-fn-caller-args-repro-0cf8586c`) no longer exists on disk, and the slug is tombstoned so the provisioner never re-materializes it.

Landed as `014d2838a5` on `origin/main2`.

## Follow-ups (messaged to the maintainer)

- Two sibling self-heal jobs for the same incident are still queued in `jobs/todo/` (`...-comment-watcher-...-upstream-404`, `...-dependabot-watcher-...-armed-fork-upstream-404-no-disarm`). Both are now no-ops; dropping them saves two gardener runs. I did not remove peer board entries unilaterally.
- The deployed root (HEAD `0d2e75298b`) predates both `bb971c9a39` and my commit, so the guards take effect on this host only at the next deliberate deploy. The flap itself is already stopped by the tombstone, so nothing is urgent.
