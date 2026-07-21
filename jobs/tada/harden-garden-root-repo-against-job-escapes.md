All work is landed on `main2` (HEAD == origin/main2 == `bd13731c52`), tree clean. Writing the completion report.

---

## Completion report

**Job:** Harden the deployed garden root repo against job git-escapes (incident 2026-07-17 / 2026-07-21)

**Landed on `main2`** (commit `bd13731c52`, rebased cleanly over a concurrent peer fix — see note below).

### What I built — three coordinated defense layers

1. **Prevent the ascent (env).** `scripts/jobs/gardener.sh` (the shared worker spine — covers gardener, cleric, **and hermit**) now exports `GIT_CEILING_DIRECTORIES=$GARDEN_ROOT`. An un-inited fixture dir under the root now FATALs with "not a git repository" instead of ascending into `$GARDEN_ROOT/.git` (incident #1's mechanism). Legitimate work is unaffected — per-job worktrees, project checkouts, and the worker's own state clone each carry their own `.git`, and explicit `git -C <dir>` is exempt.

2. **Forbid it (prompt).** `scripts/jobs/handlers/worker-common.sh` `worker_worktree_note` (byte-identical across backends, so it hardens the xs2rust-endor press family and every other job) now states plainly: never run git in `$GARDEN_ROOT`; a stray `remote set-url`/`fetch`/`checkout`/`commit` there corrupts journal sync host-wide; run git only in your per-job worktree or an `ensure-project-worktree.sh` checkout; create+`git init` any scratch repo outside the root.

3. **Repair drift that slips through (timer).** New `scripts/jobs/root-repo-guard.sh` + `garden-root-repo-guard.{service,timer}` (~30m, `:22/:52`, **every host**, auto-enabled via the unit-derived enable-set). It asserts and losslessly repairs:
   - **Origin URL** must match the canonical production RE — repaired from an escape-proof source (a per-instance journal clone's origin), re-validated against the RE before writing.
   - **HEAD** must be detached at a `main2` ancestor — never on a branch (the `feature` escape), never at a fixture commit. Repaired by re-detaching onto the recorded deploy point (`deployed_sha`, respecting deliberate-deploy) or the `origin/main2` tip, preserving the prior HEAD as a `root-guard-backup/<ts>` ref. Deferred while the fleet is draining (a deploy owns the tree).
   - **Stalled-deploy watch**: alerts once-per-window when `deployed_sha` lags `origin/main2` past `GARDEN_DEPLOY_STALL_DAYS` (default 3), cleared on catch-up.

### Tests & docs
- `scripts/jobs/test/root-repo-guard-test.sh` — hermetic, **18/18 passing**: healthy no-op, origin-drift repair, HEAD-onto-a-branch repair with lossless backup ref, non-ancestor-HEAD repair, draining-defer, and the full stalled-deploy lifecycle.
- Verified no regressions: `enable-services-test` (37/0) and `completion-signal-test` (17/0) green; the `gardener-worktree`/`project-worktree-isolation`/`worker-spine-kinds` failures are pre-existing and identical on clean `origin/main2` (they need fake-claude/proc fixtures absent in this sandbox — my changes did not worsen them).
- `designs/root-repo-guard.md` (+ index row) and a CLAUDE.md § deploy pointer.

### Notes / follow-ups
- **Complementary peer fix already on main2** (`a0cd3eae13`, another kriscendobot instance): a read-time refusal in `journal_remote` that skips a foreign-github origin so a poisoned root can't propagate to fresh clones. It layers cleanly with mine (prevention + active repair at the source); my `guard_origin` already uses the same structural-refusal shape (it rejects a non-canonical repair candidate).
- **Live observation (not actioned — I was instructed never to edit the deployed root):** the root checkout at `/home/kris/garden` is currently on `refs/heads/feature` (HEAD `f570554e39`) — the exact incident-#1 corruption signature. Once this change deploys, the guard will re-detach it automatically; but since deploys have been stalled, a maintainer may want to repair it by hand sooner (`git -C /home/kris/garden checkout --detach --force <deployed-sha>`) or force a deploy. Flagging for the liaison/maintainer.
