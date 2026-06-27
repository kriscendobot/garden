All done. Here is my completion report.

---

## Completion report: `garden-fix-comment-classifier-misroutes-directive-to-rebase`

**Root cause confirmed.** The comment-watcher ambiguity fallback (`scripts/jobs/handlers/comment-claude.sh`) forced `claude -p` to pick one token from `rebase|retcon|refresh|shepherd|gauntlet|attention|skip`. With no "change the code" verb available, the model guessed the closest mechanical one — classifying the #405 feature directive ("hide empty groups; regroup the inventory…") as `rebase`. The upstream deterministic table (`comment-watcher.sh` `classify()`) had correctly returned *ambiguous* and deferred to the fallback, so the bug was squarely in the fallback's prompt, not the table.

**What I changed** (committed `af201c3e8`, pushed to `main2`; built in an isolated worktree off `origin/main2` per garden-infra discipline):

1. **Hardened the fallback prompt** — it now states the five mechanical verbs are reserved for their *literal* git/CI operation only, and that any behavior/UI/output/code/feature/design directive is `attention`. Explicit line: "a feature request is `attention`, never `rebase`"; and "when torn, choose `attention`."
2. **Made token extraction robust** — prefer the model's *last* non-empty line so a disobedient model that reasons about a mechanical verb before answering `attention` isn't misread by a whole-output first-match. Also guarded each grep substitution with `|| true` so unparseable output resolves to `skip` instead of aborting the handler under `set -euo pipefail` (a latent bug the test surfaced).
3. **Added a `GARDEN_COMMENT_CLAUDE` testability seam** (mirrors `GARDEN_FOLLOWUP_CLAUDE`) so the classify/extract path can be driven deterministically.
4. **Extended `test/fake-claude.sh`** with optional `FAKE_CLAUDE_PROMPT_OUT` prompt capture (backward-compatible), and **added `test/comment-claude-fallback-test.sh`** — 8 assertions using the PR #405 body as fixture: feature directive → `attention`; misroute-reasoning still resolves to `attention`; prompt-hardening text present; comment body embedded; mechanical path still passes through; no-token → `skip`. **All 8 pass.**

**On job item #2 (upstream verb table):** No change needed. `classify()` already returns ambiguous for this comment and defers to the fallback, so once the fallback steers correctly the default is `attention`. Changing the deterministic table would add risk without benefit.

**Verification:** new test 8/8 pass; `bash -n` and shellcheck clean on all three files (the two shellcheck notes on `comment-claude.sh` are pre-existing, on untouched lines); the shared-helper consumer `empty-output-classifier-test` still passes 14/14.

**Follow-up (out of scope, pre-existing — not introduced by me):** `comment-watcher-test.sh` has 2 failures on a clean `origin/main2` checkout — "review 9001 not surfaced" and "APPROVED review 7001 not surfaced" (the review-surfacing path). I confirmed these are identical (82 passed / 2 failed) in a pristine worktree before my change. Worth a separate gardening job.
