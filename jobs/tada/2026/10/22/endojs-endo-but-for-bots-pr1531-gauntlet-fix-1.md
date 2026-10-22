---
orchestration-failed: true
---
orchestration-failed: true

# Fix round 1 for PR #1531: fixes pushed, CI red only from the known ubuntu-26.04 runner breakage

I applied the panel's three must-fix items and three of its should-fix items, then pushed to the PR head. CI watch exited rc 3 (red). All five red checks fail in `packages/sandbox` bwrap tests (`ulimit: Illegal option -u`, "bwrap parent death leaves no owned process group"). That is the runner breakage seen on every PR since ubuntu-latest moved to 26.04 today, not this diff.

**Where the findings came from:** the posted review cuts each finding off mid-sentence. I read the full findings from the panel's run directory instead (`scratch/tmpexec/garden-panel-…-1531/round-1.{archivist,integrator,wire-watcher}.md`). Only those three seats returned must-fix.

**New head:** `34ec4ef12`, pushed with `safe-push-pr-head.sh --mode rewrite` (old head `b4aa3d1cb`).
- **Dropped the CI commit and its revert** (`6e1d6eb62` and `b4aa3d1cb`), per the integrator's should-fix. The two cancel out exactly (I confirmed the diff between them is empty). The branch is now the base PR #1521's commit, then `14af3028a`, then three new commits:
  1. `fix(endo): verify CAS content against its hash on read` (wire-watcher must-fix).
     - `ContentStore::fetch` re-hashes what it reads and rejects a mismatch.
     - `store` replaces an existing entry whose bytes don't match its hash.
     - `fetch` and `has` refuse anything that isn't 64 lowercase hex digits, so a hash can't name a path outside the store.
     - New tests cover planted content, a truncated blob, repair of a planted entry, and path-shaped hashes.
  2. `fix(endo): load nested compartment modules from flat CAS trees` (wire-watcher should-fix).
     - `load_archive_from_cas` used to drop modules below a compartment's top level, such as `lib/util.js`. It now finds them.
     - Only a missing file is still tolerated; an integrity or I/O error now fails the load.
     - The directory test now checks that `lib/util.js` loads.
     - The doc comment no longer claims hard links are excluded.
  3. `docs(endor-run-expanded): …` (archivist must-fix items 1 and 2, plus integrator should-fixes).
     - § CLI changes now lists all the `run` flags and gives `--cas-dir` its real default (`endor-cas` in the system temp directory).
     - § Cross-PR coordination with Phase 3 is marked historical.
     - Design decision 5 records that `--entry` is deferred.
     - § Status says "PR #282" where it said "this PR", and notes the new CAS read check.

**Local checks:** all 391 `cargo test --lib` tests and the bin tests pass. rustfmt (1.91.1) is applied, and clippy reports nothing in the changed files. To compile, I had to init the `c/moddable` submodule and create empty placeholders for the gitignored generated JS bundles; neither is committed.

**CI:** 35 checks.
- **Passed:** build-xsnap, lint, viable-release on 22 and 24, familiar-bundle, zizmor, and test on macos-15 for 22 and 24.
- **Failed:** test and cover on ubuntu-latest for 22 and 24, and sandbox-drivers. All five are the runner breakage above.

**Follow-ups:**
- No fix job for the 26.04 runner breakage is on the board, and it blocks every endo-but-for-bots gauntlet. I messaged the maintainer recommending a fixer job that either pins those lanes to ubuntu-24.04 or makes the two tests work on 26.04.
- This host's bot PAT can't edit endojs PRs, so the PR body line "Only the top commit is new" is now stale. I sent the maintainer the corrected wording.
- Comment-only items I left alone: the `usage:` / `Usage:` casing split in `endor.rs`, and `parse_run_form` counting a flag's value (for example `--cas-dir --dir`) as a form flag.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1531-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 120 tokens (5802881 cached reads)
- Output: 22722 tokens
- Cost: $2.6323522
- Wall-clock: 2811s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
