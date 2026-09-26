Job complete. Inbox is empty.

---

## Completion report — `improve-sections-readme-regenerator`

**What I built.** A deterministic regenerator for the ~3 MB auto-generated `library/sections/README.md` flat index, plus its test, plus the scholar landing-gate wiring. Landed on `main2` (commit `7d3519074`, pushed `a082bafa9..7d3519074`).

**`scripts/jobs/regenerate-sections-index.sh`** (new, 348 lines). The README has three parts; the script regenerates only the **middle** (the `## Current sections` auto-index) and preserves the **preamble** and the hand-curated **`## Historical ingest log`** byte-for-byte, splicing on the two `## ` anchors (refuses if either is missing rather than clobber hand content).
- It is **section-file-driven**, so the index is *complete by construction* — every `sections/*.md` appears exactly once. (I first tried driving it from the `sources/*.md` `## Sections` tables as the job's wording suggested, but those tables are too incomplete — 2985 of 5923 files were unreachable that way; the agoric-labs source page has no table at all. Grouping each section file by a filename-derived source-slug, nesting each `kind: index` parent's children from its own `Sections:` block, is what guarantees completeness and is what `library-link-check.sh` actually validates.)
- Modes: `--print` / `--check` (pure, no network) and `--land` (tip-sync + land via `land-journal-edit.sh`'s producer-clone sync+CAS path, reused exactly as asked). Idempotent; refuses to land an incomplete index (a `kind: index` parent whose child list points at a missing file fails with a `DANGLING` report — the same defect class the step-8 gate catches).

**`scripts/jobs/test/regenerate-sections-index-test.sh`** (new, hermetic, 12 assertions, all green): completeness incl. a table-less source page, `(index)` nesting, **parens-in-title parsing** (a real bug I caught and fixed — a child title like `Routers (not dumb pipes)` derailed greedy `(`-matching; fixed by splitting on the literal `](`), preamble/log preservation, idempotence, dangling detection, missing-anchor refusal.

**`roles/scholar/AGENT.md`** (the always-read procedure doc): step 6 now says *don't hand-edit `sections/README.md`*; step 9 runs the regenerator as the **final landing step**; the Done checklist matches. (Re-applied my hunks onto a clean `origin/main2` worktree because the file had drifted concurrently in step 4 — that drift is preserved.)

**Also fixed the current staleness** (the job's motivating symptom). The committed index was stale — 5840 listed vs 5934 actual. I ran `--land` once against live `journal2`: it indexed the 94 missing files, normalized top-level link text to canonical slugs, refreshed child titles, and lost **0** section entries. Verified afterward: `--check` reports current (idempotent) and the backstop (`library-link-check`) passes — every link resolves.

**Follow-up worth considering (not done — out of scope/needs deploy surface).** The gate wiring takes effect for scholars only after the next deliberate deploy advances the root checkout. A standing cadence safety net — `regenerate-sections-index.sh --check` on a timer that posts a regen job when stale, paralleling `library-link-scan.sh` / `library-source-drift-scan.sh` — would make "never left stale" hold even against non-scholar drift. I can post that as a job if wanted.
