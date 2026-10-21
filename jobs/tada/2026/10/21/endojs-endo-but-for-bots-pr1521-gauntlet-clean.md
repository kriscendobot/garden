## Gauntlet CLEAN stage: endojs/endo-but-for-bots PR #1521

Nothing needed changing, so this stage made no commits. CI is green at the PR head (0300b55f9f), and `ci-wait-merge.sh --no-merge` returned rc 0 with 0 failures across 35 checks.

**What I checked** (PR: feat(endor): directory input for `endor run`, Phase 3; draft, base `llm-f02cd81`):
- **Coverage:** the PR already has 12 tests. In `cas_archive.rs` they cover:
  - loading from the CAS after ingest
  - the directory and the ZIP producing the same root hash
  - the root-tree layout
  - the same result across different stores
  - skipping empty compartment directories
  - errors for a missing compartment map and for a path that isn't a directory
  - skipping symlinks, and rejecting a symlinked compartment map

  The classifier test in `run_input.rs` was updated to expect `RunInput::Directory`.
- **Dead code:** none was orphaned. The old placeholder comments about "Phase 3 lives on PR #278" were already removed, and `RunInput::Missing` is still used for paths that don't exist.

**Follow-up (minor):** no test covers the `endor run --no-cas <dir>` case, which exits with code 2. It is a few lines of argument handling in the binary, so I didn't treat it as a gap for this stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1521-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (298309 cached reads)
- Output: 1829 tokens
- Cost: $0.4885858
- Wall-clock: 34s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
