The message is delivered. This job's requested work is already complete on main2, and I've surfaced the actual remaining action (a deploy) to the maintainer.

---

## Completion report

**What I found:** The self-heal behavior this job asks for is **already fully implemented on main2** and is not a code gap. Two prior commits landed it:
- `1bfbc1087` — "clone-keeper: repair a genuinely-missing tracked bare clone by re-cloning"
- `05a261e5e` — "clone-keeper: self-heal a missing bare clone by deriving its URL from the dir basename"

Both are ancestors of origin/main2 (HEAD `f7dccc82d`), so my worktree already contains them.

**What the current code does** (`scripts/jobs/clone-keeper.sh`, `keep_clone` at 172–214):
- A genuinely-**missing** clone dir is re-created via a bounded `git clone --bare` (`bounded_clone`, 151–168) wrapped in `timeout GARDEN_FETCH_TIMEOUT` with the same backoff/retry as `bounded_fetch`, returns 0 on failure so one clone never aborts the loop, then sets the fetch refspec and falls through to the normal fetch + fast-forward.
- The clone URL is either the tracked `<remote>` field when it's a URL/path (the built-in endo entry uses `https://github.com/endojs/endo.git`, so it re-clones as `REPAIRED`), or **derived from the dir basename** (`derive_clone_url`, 134–143) so even a bare-name remote self-heals (`provisioned missing clone`).
- `WARN`/skip is retained only for the truly-unrecoverable cases (bare name + underivable basename, or re-clone unreachable); the **exists-but-not-a-git-repo corruption case** is surfaced as `STALE` for a human, never clobbered.

This is a design equivalent-or-superior to the job's proposed optional 4th `<clone-url>` field: rather than requiring the field, it derives the canonical GitHub URL, so bare-name-tracked clones self-heal too. All functional requirements are met.

**Verification:** Ran `scripts/jobs/test/clone-keeper-test.sh` — **31 passed, 0 failed**, including the exact scenarios this job targets (RECLONE, PROVISION-from-basename, CORRUPT→STALE, MISSING+UNREACHABLE, MISSING+UNDERIVABLE).

**What changed:** Nothing — no commit was warranted. Manufacturing a redundant change would have been dishonest.

**Root cause of the observation & follow-up:** The endolinbot2 symptom (`worktrees/endojs-endo.git` re-warning every ~30m) is a **deploy lag, not a code gap**. This host's deployed root (`/home/kris`) has `clone-keeper.sh` at `63b1837ab`, which predates the self-heal work (0 occurrences of the self-heal functions). The fix already exists on main2; it just hasn't been deployed here. **Follow-up (liaison, out of gardener scope):** deploy current main2 to endolinbot2 via `deploy-garden.sh` / the deploy-on-upgrade Monitor — that is what will actually stop the warnings and re-form the missing clone. I messaged the maintainer with this diagnosis and follow-up.
