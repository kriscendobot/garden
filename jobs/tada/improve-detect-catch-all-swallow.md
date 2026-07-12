Inbox is empty. Work is complete and pushed.

## Completion report

**Job:** `improve-detect-catch-all-swallow` — encode the `catch-all-error-swallow` prevention-gap the prosecutor flagged on endojs/endo-but-for-bots #678 / #653 as a deterministic gardening detector.

**What I did** (all committed as `45c57ae9da`, pushed to `origin/main2` on the first CAS attempt):

- **`scripts/jobs/gardening/detect-catch-all-swallow.sh`** (new) — a no-LLM detector modeled exactly on `detect-banners.sh`. Scopes to ADDED diff lines in CODE files only (js/ts/jsx/tsx/mjs/cjs); no resolvable base → clean & quiet (exit 1). It walks the diff with awk, accumulates each added `catch (...) {` block's body by brace depth across contiguous added lines, and flags any block whose body carries **none** of the SAFE signals (rethrow `throw`/`reject(`, class narrowing `instanceof`, error-property inspection `.code/.name/.errno/.status/.message`, or a log call `console`/`.error(`/etc.). Subcommands `check` (exit 0 = swallow added, 1 = clean) and `lines` (prints `<path>: <catch opener>`). Favors false positives, saboteur juror as backstop.
- **`scripts/jobs/handlers/catch-all-swallow-claude.sh`** (new) — conditional fixer modeled on `banner-sweep-claude.sh`; hands the offending openers to `claude -p` to narrow/rethrow, best-effort and quiet on a clean tree.
- **`scripts/jobs/gardening/garden-pr.sh`** — wired `DETECT_CATCH_ALL_SWALLOW` + env-defaulted `GARDEN_CATCH_ALL_SWALLOW_FIXER` + a `run_if ... check ... -- fixer` line, right after the existing banner detector (the lines 70–82 pattern).
- **`scripts/jobs/test/detect-catch-all-swallow-test.sh`** (new) — 12 hermetic cases mirroring `detect-banners-test.sh` (single-line/empty/multi-line swallows hit; rethrow/instanceof/.code/log clean; added-lines-only; markdown not scanned; no-base quiet). **All 12 green.**
- **`skills/saboteur-adversarial-review/SKILL.md`** — added a "Catch-all error swallow (fail-open)" attack-class section pointing at the new deterministic gate, making the cross-reference bidirectional (spec also satisfied via in-code references to `skills/saboteur-adversarial-review` and `skills/adversarial-tests`).

**Verification:** new test 12/12 pass; `detect-banners-test.sh` still 9/9 (no regression); `garden-pr.sh` passes `bash -n`; shellcheck on the new files is clean except the same benign SC1091/SC2034(`GARDEN_TAG`) findings the existing `banner-sweep-claude.sh` already carries by convention.

**Follow-ups (none blocking):** the detector deliberately scopes to the try/catch statement form and contiguous-added bodies; promise `.catch(cb)` swallows and catches whose body is pre-existing code remain the saboteur juror's territory (documented in the header and the skill note).
