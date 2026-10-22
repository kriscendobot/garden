# Clean stage report: endojs/endo-but-for-bots#1525 (endor tui Phase 1)

**Result:** CI is green at the new head `187ec74172`. `ci-wait-merge.sh --no-merge` returned rc 0 (37 checks, 0 failed).

**What was wrong:** When I claimed the job, the `format-ironhorse` check was red. It failed at the "Verify shared IronHorse dependency resolutions" step, where `intl-profile.py` reported that the root and engine ICU dependency graphs disagree.
- **Cause:** the PR's new `ratatui` dependency pulled in `instability 0.3.14`, which brings `darling 0.24` and with it `syn 3.0.9`.
- **Effect:** with two `syn` versions in the root `Cargo.lock`, the ICU derive crates' bare `"syn"` entries get a version attached. That changes the root ICU graph digest, so it no longer matches `rust/engine/Cargo.lock`.

**Fix (one commit, lockfile only):** `fix(endo): pin instability 0.3.12 so syn stays single-versioned` pins `instability` to 0.3.12, which still uses `darling 0.20` and `syn 2`. `Cargo.toml` is unchanged. I pushed it with `safe-push-pr-head.sh` as a fast-forward from `f14943228e` to `187ec74172`.

**Checks run locally:**
- `intl-profile.py`, `check-lockfile-agreement.py` and the other dependency-resolution scripts from that step pass.
- `cargo test -p endo --lib tui`: all 26 tests pass, covering `bus`, `state`, `ui` and `mod`. Building them needed the `c/moddable` submodule and empty stand-ins for four generated xsnap JS bundles; those stand-ins exist only in the local checkout and were not committed.

**Coverage and dead code:** The new tui modules already had a test module each, so I added no tests. The `endor` build gave no warnings for the new module, so there was no dead code to remove.

**Follow-up for the next stages:** The pin exists only in `Cargo.lock`. A later `cargo update` could move `instability` back to 0.3.14+ and turn the check red again, so reviewers may want an explicit `instability = "=0.3.12"` constraint or a note to that effect.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1525-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1579477 cached reads)
- Output: 7854 tokens
- Cost: $1.0005834
- Wall-clock: 2474s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
