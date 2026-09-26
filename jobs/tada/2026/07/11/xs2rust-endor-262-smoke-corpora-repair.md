Inbox empty. The job is complete.

## Completion report

**Job:** Repair the two endor-compile corpus smoke tests broken by the corpora→cases retirement (PR #600, `endojs/endo-but-for-bots` branch `xs2rust-endor`).

**What I did (tests only — no compiler/runtime source touched):**
- Added a shared local helper `rust/engine/endor-compile/tests/corpus_cases/mod.rs` (a `tests/` subdir module, so it is not compiled as its own test binary). It mirrors endor-262's `corpora_programs()` / `case_source_line` / `collect_js` — walks `../endor-262/cases/**/*.js` (skipping `staging/` dirs and `_FIXTURE.js`), extracts each case's verbatim one-line program from its `  Source:` frontmatter line, and exposes `corpus_programs()` plus `CORPUS_PROGRAM_COUNT = 1711`. endor-compile cannot depend on endor-262 (circular), hence the carried helper.
- Repointed `corpus_parse_smoke.rs` and `corpus_scope_smoke.rs` from the deleted `../endor-262/corpora` `read_dir` to `corpus_programs()`. Both now assert the recovered count `== 1711` (catches a future `cases/` regression). Per-program assertions and test names/intent (parse smoke, scope smoke) are unchanged; error messages now name the case id instead of the corpus filename.

**Verification (evidence):**
- Oracle built: seeded `c/moddable` from sibling `project-wt-xs2rust-endor-stage5-fix6-verify` at the exact pin `23b4d6b0a65f` (moddable 8.3.1); never `git add`ed.
- Isolated run of the two repaired binaries (`--nocapture`): `corpus parse smoke: 1711 programs, 1711 oracle-compared` and `corpus scope smoke: 1711 programs, 1711 scoped, 0 early errors` — **both 1,711**, both `test result: ok`.
- Full workspace from `rust/engine`: `cargo test --workspace -- --test-threads=1` captured to `.workspace-test.log`, `$?` checked directly → **EXIT=0**. All 22 `test result:` lines show `0 failed` (grep for non-`0 failed` returned none); no `error`/`FAILED`/`failures:` markers.

**Landed:** committed only the three test files (explicit pathspecs; `c/moddable` gitlink left unstaged) as `69ec87becb`, pushed `origin HEAD:xs2rust-endor` with a rebase-CAS loop — git push exit 0 on attempt 1 (`194454363a..69ec87becb`); remote tip confirmed equal to HEAD. PR #600 left DRAFT; no PR comment; no maintainer messages.

**Follow-ups:** none. (Note: one hand-written regression case, `cases/regressions/regexp-backreference-out-of-range.js`, has no `Source:` line and is intentionally excluded — 1712 `.js` files → 1711 corpus programs, matching endor-262's own `corpora_programs()`.)
