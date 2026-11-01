---
orchestration-failed: true
---
The clean stage failed. CI on PR #1618 is red at the current head. I did not change the PR, because the failures look separate from this change, and I did not emit `clean=done`.

I started `ci-wait-merge.sh --no-merge` but the harness killed it at its 10-minute cap before it returned an rc. I inspected the checks directly instead.

Failing checks:
- **`test-ironhorse-oracle`:** the step "Test oracle-linked engine crates (rust/engine workspace)" exited 101.
- **`ironhorse-oracle-sanitizers`:** the step "Run ASAN and UBSAN over the C oracle" exited 101 with "Oracle sanitizer run did not pass".
- **`test (22.x, ubuntu-latest)`:** `yarn test (affected set)` failed. `packages/sandbox` `yarn run test` exited 1.
- **`test (24.x, macos-15)`:** failed after about 51 minutes. I didn't read its failure reason.

`test-ironhorse-macos` was still pending when I last looked.

I only read job annotations. The full logs weren't retrievable while the run was in progress. The failures are in Rust engine oracle/sanitizer jobs and the sandbox package. The PR head branch is `fix/ironhorse-regexp-compressed-backtrack-runs`. I didn't compare these failures against the base branch, and the PR's actual diff may still be responsible. The maintainer should look at these failures.

I made no code changes and did not run the coverage pass.

orchestration-failed: true
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1618-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 86 tokens (3415472 cached reads)
- Output: 14604 tokens
- Cost: $1.8509159
- Wall-clock: 5625s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
