Done. Report follows.

## Completion report: `improve-journal-remote-self-heal`

**Problem.** `journal_remote()` in `scripts/jobs/common.sh` FATAL-stormed the entire fleet when the journal worktree's `remote.origin.url` read came back *momentarily* empty (a git config lock held by the worktree-keeper, or a deploy window). On 2026-07-03 11:06–11:11Z ~every `garden-*` unit on this host died repeatedly with `FATAL: no JOURNAL_REMOTE set and no origin`, under systemd `Restart`, while the origin was intact seconds later — a fleet-wide crash-loop that floods the journal and buries real signal.

**What I changed (`scripts/jobs/common.sh`).**
- Added a per-host cache knob `JOURNAL_REMOTE_CACHE` (`$GARDEN_STATE/config/journal-remote`), living outside any reset-prone worktree.
- Added a best-effort `_cache_journal_remote()` helper that persists the last good value (change-only writes; never fails its caller under `set -e`).
- Reworked `journal_remote()` so that when both `$JOURNAL_REMOTE` and the worktree origin are empty, it falls back **in order**: (1) the cached file, (2) `git -C "$GARDEN_ROOT" config --get remote.origin.url` (journal2 and main2 share the same repo/remote) — each logging a **single WARN**, and only `die`s when all fail. Every successful resolution (worktree or root) is cached so a later empty read self-heals.
- The `JOURNAL_REMOTE` test hook still short-circuits first and writes no cache (verified).

**Tests (`scripts/jobs/test/journal-worktree-relink-test.sh`).** This test's UNREPAIRABLE case was already stale on HEAD — it predated the root-origin fallback added in the parent commit `cdd341056` and was 4-failing on pristine `main2`. I rewrote it to lock down the new self-healing contract: root fallback (no die, no FATAL), cache-ordered-ahead-of-root, cache-written-on-success, plus the two genuinely-unrecoverable `die` diagnoses (no-origin vs. broken-worktree naming the dangling gitdir). **25/25 pass**; `bash -n` clean.

**Committed & pushed** to `main2` (`origin/main2` now at `556103da2`).

**Follow-ups:** none required. Note that the previously-committed relink test was silently failing on `main2` since the root-fallback commit landed without updating it; this change repairs that as a side effect.
