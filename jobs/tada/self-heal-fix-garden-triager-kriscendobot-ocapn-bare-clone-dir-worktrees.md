This job was **already fully resolved on `main2`** by a series of commits that landed after it was posted. My worktree, checked out off `origin/main2` (HEAD `54ed2c98f0`), already contains every change the spec asks for, plus refinements. Nothing to commit.

## Completion report

**Finding:** The defect described in the job is already fixed in `origin/main2`. Every requested change is present, and the tests already cover the self-provision path. Working tree is clean — no new commit was needed.

**Verification against the spec's three asks:**

1. **Bare-clone directory default (`repos` → `worktrees`).** The `GARDEN_REPOS:=$GARDEN_ROOT/repos` default is gone. Both `triager.sh` and `comment-watcher.sh` now resolve the path through a single shared resolver, `bare_clone_dir()` (`common.sh:479-480`), which defaults to `$GARDEN_ROOT/worktrees` and still honors a `GARDEN_REPOS` override. This kills the drift the spec worried about (commits `118f7384fc`, `83e0eb0f41`). `triager.sh:46` and `comment-watcher.sh:326` both call it.

2. **Bare `die` → self-provisioning fallback (`triager.sh`).** The hard die is replaced (`triager.sh:73-115`) with the same `is_own_git_repo` / `derive_clone_url` / `bounded_clone` shared helpers clone-keeper uses, and goes further than the spec: self-provision is **opt-in** (`GARDEN_TRIAGE_SELF_PROVISION=1`; default is a benign clean skip so the clone-holding host triages); a present-but-corrupt dir is surfaced as `STALE` and never clobbered; unreachable/underivable sources skip cleanly and escalate to the maintainer inbox instead of crash-looping. The fresh clone gets `remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'` set as required (commits `2c76c8cd92`, `4c0e275b0b`, `372e5e7584`).

3. **`comment-watcher.sh` default + tests.** `comment-watcher.sh` now uses `bare_clone_dir` (worktrees default) while retaining its graceful gh-polling fallback. `ci-watcher.sh` never referenced `GARDEN_REPOS`, so it needed no change. Test coverage exists: `test/triager-test.sh` (68 assertions, all passing) covers the missing-clone default skip, opt-in provision success, unreachable/underivable escalation, the `worktrees`-not-`repos` default (case I), and the corrupt-dir path; `test/comment-watcher-test.sh` (213 assertions) also passes.

**Tests run (this HEAD):** `triager-test.sh` → 68 passed / 0 failed; `comment-watcher-test.sh` → 213 passed / 0 failed.

**Follow-ups:** None for the code. One operational note: the deployed garden root's `scripts/jobs/triager.sh` still shows the old `repos` default and bare `die` — that is expected, since the root checkout is a *deployed version* advanced only by the deliberate `deploy-garden.sh`, not a live fast-forward. This fix will reach live triagers on the next garden deploy; no action needed from me.
