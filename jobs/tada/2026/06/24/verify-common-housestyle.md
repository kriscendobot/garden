Done.

**Job verify-common-housestyle — complete.**

Verified that v2 `roles/COMMON.md` (215 lines) genuinely folds in all four v1 house-style rules. Each is **stated outright**, not merely implied, in the § House style section (lines 206-215), with three of the four also restated in § Style (lines 38-46). I cross-checked each against its v1 skill body under `/home/kris/v1/skills/`; the COMMON.md statements carry the core rule of each. The full skill bodies are also retained in v2 under `skills/<name>/` and linked from COMMON.md for detail, so COMMON.md serves as the standing one-line statement and the skills as the reference.

**Per-rule status (all present, none weaker — no folding needed):**
- `em-dash-style` — **present** (line 42, 210): "avoid em-dashes in prose; rewrite as a period, parentheses, or a colon."
- `no-latin-shorthand` — **present** (line 44, 212): full token list (`cf.`, `i.e.`, `e.g.`, `etc.`, `et al.`, `vs.`, `viz.`, `ad hoc`); use the English equivalent.
- `relative-paths` — **present** (line 43, 211): within-tree relative, absolute reserved for the cross-tree case (captures the v1 cross-tree exception).
- `test-title-spec-spelling` — **present** (line 213): spell a spec-defined surface exactly as the specification does.

**Manifest correction** (`designs/v1-migration-manifest.md`): corrected the stale "COMMON.md not yet written" claim in both the four LEAVE_BEHIND skill rows and the closing Style-rule note. The note now records that COMMON.md is authored and folds in all four rules, and marks the four v1 copies under `/home/kris/v1/skills/` droppable by a future prune. Did **not** delete the v1 copies (out of scope for this job).

**Commit:** `172838df` on `main2`, bot identity (endolinbot), pushed to `origin/main2`.

**Follow-up:** a future prune-v1-legacy pass can now drop the four v1 skill copies under `/home/kris/v1/skills/{em-dash-style,no-latin-shorthand,relative-paths,test-title-spec-spelling}/`. No follow-up needed on v2 — the v2 `skills/<name>/` copies are intentionally retained as the detail backing COMMON.md's pointers.
