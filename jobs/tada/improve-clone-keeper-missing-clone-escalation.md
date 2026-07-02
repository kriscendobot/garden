The job is already fully satisfied on `origin/main2`. No new work was required.

## Completion report

**Finding:** The exact work this job specifies was already landed in commit `05a261e5e` ("clone-keeper: self-heal a missing bare clone by deriving its URL from the dir basename"), authored ~27 min before my claim (likely a peer gardener or an earlier run of this same job). My worktree checked out off `origin/main2` already contains it; `HEAD == origin/main2` and the tree is clean.

**What the landed change does (job's preferred option (a) — self-heal):**
- `scripts/jobs/clone-keeper.sh` no longer just logs `WARN … skipping` and returns 0 forever on a missing clone. `keep_clone` now discriminates missing-vs-corrupt and, for a genuinely missing dir:
  - re-clones from an explicit URL/path source when the tracked row carries one (logs `REPAIRED`), and
  - when the source is a bare remote name (e.g. `origin`), **derives** the canonical upstream URL from the dir basename — `worktrees/<owner>-<name>.git` → `<GARDEN_CLONE_URL_BASE>/<owner>/<name>.git` (default `https://github.com`) — and provisions from it (logs `provisioned missing clone …`). This closes the endo case (`worktrees/endojs-endo.git`), which is tracked with a URL source and now hard-repairs instead of degrading silently.
  - Clone is bounded (timeout + backoff/retry, reaper-compatible); fetch refspec is set as `ensure-project-worktree.sh` prescribes; a present-but-corrupt dir is surfaced as `STALE` and never clobbered; underivable/offline falls back to WARN-skip (no re-clone loop).
- `scripts/jobs/test/clone-keeper-test.sh` covers the full missing-clone → heal/escalate matrix: RECLONE (URL source → `REPAIRED`), PROVISION (bare-name source → basename-derived `file://` URL, refspec set), MISSING+UNREACHABLE (bounded skip, no partial left), MISSING+UNDERIVABLE (WARN-skip), plus CORRUPT/DIVERGED/OFFLINE/FRESH/FF.

**Verification:** Ran `clone-keeper-test.sh` — **31 passed, 0 failed**.

**Changes by me:** none (nothing to commit or push — the deliverable was already present and verified). No follow-ups.
