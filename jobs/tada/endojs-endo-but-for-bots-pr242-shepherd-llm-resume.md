Shepherd complete. PR #242 is rebased onto live `llm`, base unfrozen, and CI is fully green.

**What I did**
- Re-fetched live PR #242 state: base `llm-b1c3f4d` (frozen), head `feat/syrups-ocapn-framing`, open/mergeable.
- Rebased the PR's commits from the frozen snapshot `llm-b1c3f4d` onto live `origin/llm` (`2b2e3200`, which carries the bucketed `scripts/eslint-repo.sh` lint-ceiling fix), and **unfroze the PR base to `llm`**.
- Resolved the one semantic conflict in `packages/ocapn/test/python-test-suite/index.js`: kept the PR's `framing: 'syrup'` (matching the syrups-framing test-suite SHA `89e80d70…` that `ci.yml`'s auto-merge preserved) while adopting `llm`'s `22_046` underscore-numeric lint style. The `test(ocapn)` port commit dropped as an empty duplicate of `llm`'s own reviewed port; the composite-tsconfig regen commit was skipped (`build:types:gen` confirmed zero drift on `llm`'s graph).
- First CI pass came back with `lint` red — but **not** the eslint ceiling (eslint was 0 errors). Root cause: `scripts/check-security-md.sh`. The rebased SECURITY.md commit had pinned `bytes/SECURITY.md` to the frozen-base canonical, but on live `llm` the canonical had moved and `bytes` was already canonical there — so the commit was now a regression. I dropped it.
- Verified locally: `check-security-md.sh` exit 0, `build:types:check` green, prettier clean, eslint 0 errors. Force-pushed the corrected 2-commit head (`bb85932b6`).

**Outcome (verified)**
- Head `bb85932b6`: all CI runs completed **success**; `gh pr checks` shows **25/25 pass** (including the `lint` job and `test-ocapn-python`). `mergeStateStatus: CLEAN`, `mergeable: MERGEABLE`.

**Changes on the PR head**
- Final diff vs `llm` is 3 files: `.github/workflows/ci.yml`, `packages/ocapn/test/python-test-suite/{index.js,README.md}` — the PR's actual substance, cleanly on top of live `llm`.

**Follow-ups**
- None for this PR; it's green and merge-ready (no comment posted — nothing actionable to say). The lint-ceiling resume for the `llm` half is discharged.
