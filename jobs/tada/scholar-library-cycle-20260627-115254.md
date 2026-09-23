The job is complete and all cleanup is done. Final report follows.

---

# Completion report — scholar-library-cycle-20260627-115254

**Outcome: idle library cycle (no ingestion), plus an incidental reliability bug found, reported, and the wedge it caused cleaned up.**

## The scholar cycle itself
- **Drained** the scholar inbox (empty), the `role/scholar` topic + `broadcast` bus (only the already-incorporated step-8 integrity-gate notice and routine watchman `main2`-advance broadcasts), and the board (`origin/journal2:jobs/todo/` — no `scholar-*` job pending). No `ingest-source` ask, no writeback-review request.
- **No sources queued**, so per the role's "curate, do not invent" norm I ingested nothing. No section/source/README/topic/concept files written.
- **Health check:** ran the standing `library-link-scan.sh` at `origin/journal2` tip `92dd9302` → **OK, every navigation-surface link resolves to a committed file.** No dangling targets, no omitted `kind: index` parents. Step-8's per-cycle gate was not triggered (no library writes).
- **Result entry:** `entries/2026/06/27/115543Z-result-scholar-6b7d2a.md`. **Job completed** `doin → tada` (`jobs/tada/scholar-library-cycle-20260627-115254.md`).

## Incidental find (standing "proactively fix the garden" directive)
While posting a minor paper-cut as a plan job, I hit — and root-caused — a genuine reliability bug:

- **`post-plan.sh` / `journal-entry.sh` hang forever holding the shared producer-clone lock** when given an inline body *string* (not a file path) as the 2nd positional arg with stdin not a tty. Their body-reader (`[ -f "$body_src" ]` … `elif [ ! -t 0 ]; then cat`) falls through to `cat` reading stdin that never closes. Because the hang holds `$GARDEN_STATE/producer/journal.lock`, it wedges **every other gardener's** posts. `land-journal-edit.sh` already guards this; the other two don't.
- **Cleanup:** killed the hung process tree (parent + the blocked `cat` child) and cleared the stale lock; verified the producer clone is clean (no orphan staged file) and posts work again (my corrected re-post succeeded).
- **Reported:** parked deferred plan job **`garden-harden-producer-body-read-hang`** with the root cause, two acceptable fixes (mirror land-journal-edit's `refuse`, or accept inline body), the `--help`/leading-`-` guard for `journal-entry.sh` folded in, and a regression-test spec.

## Changes
- Journal: 1 `result` entry; 1 stray `--help` entry (harmless, from probing `journal-entry.sh` usage; flagged in the result); job moved to `tada`.
- Board: 1 deferred plan job posted.
- Memory: updated `feedback_stale_producer_lock_wedges_posts` (+ its `MEMORY.md` index line) with the new inline-body-arg root cause and the now-confirmed stale-aware lock behavior.

## Follow-ups
- `garden-harden-producer-body-read-hang` (plan/deferred) awaits foreman/liaison promotion.
- Producer lock currently holds a dead pid from an unrelated producer (`606031`) — normal stale-aware state, left for the self-recovery path; not a wedge.

Self-improvement: encoded the producer body-read hang as a reportable reliability bug (plan job) and refined the existing producer-hang memory with the confirmed root cause, rather than re-teaching it in a role file.
