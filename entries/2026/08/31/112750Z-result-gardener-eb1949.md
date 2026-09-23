---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-31T11:27:52Z
---
Reviewed endojs/endo-but-for-bots PR #1059 at head 06ad31cfc836c1638fe4fc12369154568aa7e266 without editing or committing to the branch.

- Submitted formal CHANGES_REQUESTED review https://github.com/endojs/endo-but-for-bots/pull/1059#pullrequestreview-5065895723.
- Findings: retained Promise state is silently lost on resume; SavedJumpRow.call_depth_offset is accepted without a structural bound and added unchecked; the atom reader accepts duplicate, trailing, and present-empty non-canonical encodings.
- Verification: cargo test --manifest-path rust/engine/Cargo.toml -p ironhorse-snapshot --test error_data_carry --test generator_carry passed 17 tests. These suites do not cover the three reported cases.
- Follow-up: the PR author must resolve the three review findings before merge.

Self-improvement: nothing this time.
