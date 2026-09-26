Done. The ELib `elib/concurrency/` chapter is now fully ingested.

## Completion report

**Job `scholar-ingest-erights-10`: six ELib concurrency sub-hub child chapters — DONE.** The `elib/concurrency/` chapter is now FULLY INGESTED.

**Ingested (6 new sources, 1 section each):**
- The Four Layers of When children — `when-ref-when` (Layer 1), `when-reactors` (Layer 2), `when-catch` (Layer 3, the direct ancestor of `E.when`/`Promise.then`), `when-joiners` (Layer 4). All four upstream pages turned out to be unwritten stubs ("\*\*\* To be written"), so each section honestly records the layer's place in the four-layer map and its Endo lineage rather than fabricating page prose, with the content SHA-256 captured as a freshness anchor.
- EIO children — `eio-goals` (the requirements/preferences charter: non-blocking, InStream/OutStream fail-stop model, composability/backpressure) and `eio-obtaining` (the `obtain/5` primitive and its 2×2×3×2 = 24-cell input-operation taxonomy; LATER returns a vow = the ancestor of async-iterator pull). Both have real content (22 KB / 26 KB).
- All six re-fetched/re-confirmed via `fetch-source.sh`; SHAs matched the erights-9 anchors.

**Flips & index updates:** the two sub-hub map sections and two sub-hub source files flipped queued→ingested (child lists now link the new sources); hub map section + hub source note record the chapter as fully ingested; `sources/README.md` +6 rows; topic pages `e-language` +6 (38→44), `eventual-send` +6 (92→98), `streams` +2; `topics/README.md` counts reconciled.

**Gate & landing:** `library-link-check.sh --source-slug` passed (exit 0) on all six new clusters plus the three touched parents, run against a fresh worktree off the current tip. `regenerate-sections-index.sh` regenerated and landed `sections/README.md` (all six new slugs verified present). Every content file landed via `land-journal-edit.sh`; the stale live `journal/` worktree was used read-only, all authoritative reads via `git show origin/journal2`, shared indexes rebuilt from a re-fetched tip before landing.

**Notable:** the `streams` README count was badly drifted (13 vs an actual 35 rows); a peer scholar corrected it to 35 mid-cycle, and my +2 brought it to the true 37. I posted a `result` entry and a self-improvement `message` to the liaison proposing a deterministic topics-README-count reconciliation check (this drift recurs and was caught only by chance).

**Follow-ups (not this job):** no part-11 needed; the ~20 pre-existing dangling `--nav` links (endo-but-for-bots design cluster + polaris/powerbox/daemon-persistence) still warrant a separate library-link cleanup job; optional concept-axis growth carried forward unchanged.

Self-improvement: routed the topics/README count-drift reconciliation-check lesson to the liaison (scripts/ work, outside scholar scope) rather than landing it myself.
