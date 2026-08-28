**Clean stage complete for endojs/endo-but-for-bots PR #1069.**

- **Idempotence check:** PR #1069 ("ci: move Ironhorse fuzzing out of PR CI into a continuous garden service") is a CI-config/docs/Rust-toolchain-only change touching `.github/workflows/ci.yml`, `rust/engine/README.md`, and `rust/engine/ironhorse-fuzz/fuzz/{Cargo.toml,rust-toolchain.toml}`. No JS/TS package source is touched, so there is no coverage surface to run and no dead code the change orphaned. No follow-up commits were needed.
- **CI:** All 26 checks COMPLETED / SUCCESS.
- **Outcome:** The PR is now `MERGED` (un-drafted, state MERGED). CI green at the merged head satisfies the clean-stage exit condition.

No follow-ups.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1069-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 32 tokens (895318 cached reads)
- Output: 4419 tokens
- Cost: $1.0270579999999998
- Wall-clock: 353s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
