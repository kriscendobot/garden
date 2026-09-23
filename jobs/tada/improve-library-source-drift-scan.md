Worktree removed, inbox empty. The work is complete and pushed to `main2`.

---

## Completion report: `improve-library-source-drift-scan`

**What I did.** Added a standing, tip-synced, offline corpus-wide source-freshness scan — the source-drift analogue of `library-link-scan.sh` — that moves per-source freshness auditing off the chance-encounter scholar (who only catches drift on the 2–4 sources a cycle happens to touch) and onto a deterministic cadence scan.

**Files added (all new — pushed to `main2` as `cd1026ce9`):**
- `scripts/jobs/library-source-drift-scan.sh` — the scan.
- `scripts/jobs/test/library-source-drift-scan-test.sh` — hermetic test (16 assertions, all passing).
- `scripts/systemd/garden-library-source-drift-scan.{service,timer}` — timer-driven oneshot, self-heal-wrapped.

**How it works, per tick:**
1. **Tip-first sync.** `ensure_clone` + `sync_clone` a dedicated read-only journal2 clone (`$GARDEN_STATE/library-source-drift-scan/journal`) to the current `origin/journal2` tip — never the live `journal/` worktree, exactly like `library-link-scan.sh`. A transient outage exits `75` (EX_TEMPFAIL), a clean skipped tick.
2. **Parse.** From `library/sources/README.md`, every row that pins a single path to an inline `file-commit \`<sha>\`` yields `(slug, repo, path, recorded-sha)`. Rows without an inline file-commit (the `{N files}` aggregates, repo-source rows) carry no sha to compare, so they're excluded by construction.
3. **Resolve + compare, offline.** For each row whose repo has a local bare clone under `worktrees/<owner>-<repo>.git`, resolve `git -C <bare> log -1 --format=%H -- <path>` and prefix-compare to the recorded (abbreviated) sha. Reuses the bare clones `clone-keeper.sh` keeps fresh; **never reaches the network**. A row whose repo has no local clone (e.g. MetaMask/ocap-kernel, kriskowal/cask) is **skip-and-logged**, never fetched.
4. **Post.** Each drifted source idempotently posts a low-priority `scholar-refresh-<slug>` job via `post-job.sh` (idempotent across todo/doin/tada; a cheap pre-check skips the post when one is already present).

**Verification.**
- Hermetic test: 16/16 passing — current, drift, idempotent re-run, skip-and-log of a clone-less repo, aggregate-row exclusion, and dry-run (exit 1 on drift / 0 when clean, posts nothing).
- Live read-only dry-run against the real corpus at tip `39339a17`: **49 sources audited, 40 current, 5 genuine drifts** surfaced (e.g. `marshal.js` recorded `da16a78e` vs upstream `c423ed37`), 4 rows skip-and-logged for missing clones. Exit 1, posted nothing (dry-run).
- Confirmed `install-units.sh`'s `garden-*` glob auto-discovers and enables the new timer (and treats the paired service as timer-driven) — **no edit to `install-units.sh` needed**.

**Scope.** Read-only reads of already-ingested upstream repos from local bare clones; posts jobs only. No agoric-sdk, no network, no live-worktree mutation. Built in an isolated worktree off `origin/main2` and committed with explicit pathspecs per standing garden-infra practice; worktree torn down.

**Follow-ups / notes.**
- The scan resolves the upstream path against the bare clone's `HEAD` (per the job spec's literal `git log -1 -- <path>`), which for the endo clone tracks `master` that `clone-keeper.sh` fast-forwards. The timer is offset to `OnActiveSec=20m` / `OnUnitActiveSec=1h` so the bare clones are fresh before the audit.
- An empty upstream resolution (a path renamed/deleted upstream) is treated as drift and surfaced/posted (logged distinctly) — a vanished source needs scholar reconciliation too.
- Once installed, the first tick will post up to ~5 `scholar-refresh-*` jobs for the currently-drifted endo sources; subsequent ticks are idempotent no-ops until those refreshes complete and the recorded shas are updated.
