All 27 checks green at the current head `15a84eb9da6`, no other/pending/failing. The clean stage is complete.

**Clean stage — endojs/endo-but-for-bots PR #1085 — DONE (CI green)**

Coverage pass on the touched packages (`packages/daemon`, `packages/platform`, `packages/exo-stream`):
- **daemon `src/mount.js`** — all PR-added statements covered by the new `mount-stream-search.test.js`; only 2 defensive `deniedSegments === undefined` ternary branches uncovered (mounts always define them — contortion, not worth a test).
- **platform `src/fs/search.js`** — added code 94.98% lines; residual uncovered items are a symlink-cycle edge under trailing `**` and the batch-full flush (volume/adversarial, out of scope per coverage-driven-testing).
- **exo-stream `reader-from-iterator.js`** — closed a real gap: the newly-added `once: true` reader latch (second `stream()` rejects) was exercised only cross-package by the daemon suite. Added a focused test (`once-only reader rejects a second stream()`); re-ran coverage → all added statements and branches now covered.

Dead code: none — the change is additive (only 2 lines replaced in-place), nothing orphaned.

Commits pushed to the PR head `feat/mount-stream-glob-grep`:
- `bd6ecdac2c` — `test(exo-stream): cover the once-only reader latch`
- `15a84eb9da6` — `chore(daemon): prettier-format the mount stream-search test` (fixed a `lint:prettier` RED from an over-long `streamGrep(...)` line in the PR's own test file)

CI: two test legs (`test (22.x, macos-15)`, `test (24.x, ubuntu-latest)`) went RED on a **CI-infrastructure flake** — `Exiting due to SIGINT` cascading across PR-untouched packages plus a runner-level `.../externals/node24/bin/node ... No such file or directory`, while their sibling matrix legs passed the identical suites. I re-ran the two failed jobs (`gh run rerun 33851027497 --failed`); both passed on re-run, confirming the flake. **Final rollup at head `15a84eb9da6`: 27/27 green.**

Follow-ups: none. (Note: GitHub API was under heavy fleet-wide secondary rate-limiting during this run, which slowed CI polling.)

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1085-streamgrep-incremental-walk-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (1 unmetered)
- Input: 174 tokens (7628612 cached reads)
- Output: 41195 tokens
- Cost: $7.5725672500000005 (1 engagement(s) unpriced)
- Wall-clock: 6175s
- Model(s): claude-opus-4-8 ×4

<!-- garden-usage-end -->
