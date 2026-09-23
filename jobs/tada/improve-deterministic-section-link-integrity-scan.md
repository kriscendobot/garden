Inbox empty. Work complete.

---

**Job done: deterministic, tip-synced section-link-integrity scan landed on `main2` (commit `fe1034b76`).**

**What I found first.** A sibling job, `improve-post-ingest-parent-index-resolution-gate` (gardener 36), had already landed a shared link-resolution core, `scripts/jobs/library-link-check.sh`, and its own inbox message + commit explicitly carved out *my* job as "the sync-tip-first wrapper that calls it." So I did **not** duplicate or clobber their resolver — I built the wrapper around it and hardened the shared core where my analysis exposed gaps.

**What I shipped (4 files, all tested):**
- **`scripts/jobs/library-link-scan.sh`** (new) — the thin standing scan. It `ensure_clone`+`sync_clone`s a dedicated read-only journal clone to the **current `origin/journal2` tip before resolving any link** (the stale-snapshot fix), then delegates to `library-link-check.sh --nav --quiet`. Never touches the live `journal/` worktree. Adds `--exists <path>` as the *re-verify-before-you-repoint* primitive. Both lessons are encoded in the script, not re-taught in `roles/scholar/AGENT.md` / `skills/library-lookup` (left untouched, as the job required).
- **`scripts/jobs/library-link-check.sh`** (3 surgical fixes to the shared core, all 13 of the peer's gate tests still pass): drop heading-line links and blank inline-code-span links before extraction (a *quoted* link isn't navigation); skip targets resolving **outside** the library (cross-tree `../../../skills/*` pointers aren't the library's to judge); and a new **`--nav`** scope that walks only the scholar-authored navigation surfaces, excluding leaf section bodies.
- Precision subtests added to the core test; a new wrapper test pins the **sync-freshness regression** (a target a peer commits *after* the clone exists must resolve).

**Why the fixes mattered.** A naive "wrapper over `--all`" emits **205 dangling on the live library — almost all false positives** (leaf section bodies carry verbatim-upstream links like `./errors.md`; abstracts quote links in backticks; the auto-generated `sections/README.md` embeds quoted links in `### From …` headings). With `--nav --quiet` the live scan now emits exactly **8 genuinely-dangling navigation links, zero false positives** — the recurring `endoclaw.md` parent-index pointers (7 source pages) plus one `lal-transcript-memory-management.md` reference.

**Follow-ups (not done here — library-curation judgment, not infra):**
- The 8 real findings want a scholar pass: create the missing `endoclaw.md` (and `endoclaw-network-fetch.md`, `lal-transcript-memory-management.md`) parent source-indexes, or de-link the children. The scan will keep surfacing them until repaired.
- Wiring `library-link-scan.sh` into a cadence (a `schedule`d standing scan, or the scholar's empty-inbox cycle) is a small next step; the script is cadence-ready and self-cleaning.

Cleanup: built in an isolated worktree off `origin/main2`, pushed `ec4b0494c..fe1034b76` clean, removed my obsolete first-draft standalone files from the live tree (they'd have blocked deploy-sync's fast-forward), and tore the worktree down. No peer message sent — gardener 36 has completed, so the durable record is the commit body.

Self-improvement: the lesson worth keeping is procedural — **before building a `scripts/jobs/` checker, grep `origin/main2` and drain the inbox for a sibling job's just-landed core**; here a peer had landed the resolver and named my job, so the right move was a thin wrapper + shared-core hardening, not a competing duplicate.
