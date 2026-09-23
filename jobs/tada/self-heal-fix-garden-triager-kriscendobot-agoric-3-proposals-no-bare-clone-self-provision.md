The already-landed triager test passes 62/62 in the worktree, and the worktree is clean.

## Completion report

**Finding: the job was already fully resolved on `origin/main2` before this run.** My job worktree is checked out at `4c0e275b0b`, which already contains the fix — delivered by peer commits `2c76c8cd92` ("fix(triager): self-provision a missing bare clone instead of never triaging") and `4c0e275b0b` ("fix(triager): make self-provision opt-in (default skip), reconcile case I").

The landed implementation satisfies both problems the job named, and refines problem 2:

1. **Wrong clone root** — `GARDEN_REPOS` now defaults to `$GARDEN_ROOT/worktrees` (the canonical standing-clone location clone-keeper maintains) in **both** `triager.sh` and `comment-watcher.sh`. ✓
2. **Self-provision instead of die** — the hard `die` at old line 32 is gone. A clone-less host is a **clean skip** by default (the host that holds the clone triages); an opt-in `GARDEN_TRIAGE_SELF_PROVISION=1` derives the URL via the shared `derive_clone_url` + `bounded_clone` helpers and provisions under `worktrees/`, logging `provisioned missing bare clone …`. Unreachable or underivable sources **escalate to the maintainer inbox** (throttled) and exit 0 rather than crash-looping. This opt-in/skip model is a deliberate improvement over the "always provision, die on failure" behavior the job originally specified.
3. **Test coverage** — `scripts/jobs/test/triager-test.sh` already exists and covers (a) an existing clone under `worktrees/` being found, (b) a missing clone self-provisioned via a stubbed `GARDEN_CLONE_URL_BASE`/`bounded_clone`, plus the failed-provision and underivable-slug escalation paths, and the case-I default-root regression. It passes 62/62.

**What I changed: nothing in main2.** No commit or push — there was no gap to close. The worktree is clean.

**Process note / correction:** I initially, mistakenly, reimplemented the fix against the *deployed garden root* (`/home/kris/garden2`, which lags behind `origin/main2` and still shows the old `die`), before realizing origin/main2 already had a superior implementation. I reverted my stray edits to the deployed root's `triager.sh` and `comment-watcher.sh` (`git checkout --`) and removed the test file I added there, leaving that checkout's unrelated pre-existing uncommitted changes (`garden`, `clone-keeper.sh`, `common.sh`, untracked `bin*` dirs — none of them mine) untouched. The deployed root will pick up the real fix through the normal deliberate-deploy path.

**Follow-ups:** None required for the fix itself. Optionally, whoever owns the deployed root may want to note it carries uncommitted local edits to `clone-keeper.sh`/`common.sh`/`garden` that predate this job.
