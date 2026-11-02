## PR #1503: woven onto llm-48d6f3e, and the daemon suite now runs and passes on all four legs

**#1566 has not landed.** It is still an open draft based on `llm-204ecd1`. But llm already has a fix for the test that broke #1503's CI: kumavis's commit `27705a4cdf` ("test(sandbox): fix Linux resource limit and cleanup assertions"). The current llm tip `48d6f3e08b` is green on CI. So I wove #1503 onto llm instead of copying the #1566 fix into it.

**Why the daemon suite never ran:** on the Ubuntu test legs, the `@endo/sandbox` bwrap test "bwrap parent death leaves no owned process group" failed with "Test finished without running any assertions". Turbo then stopped the rest of the test run with SIGINT, including the daemon suite, about 3.5 minutes in.

**What I did:**
- Rebased #1503's two commits from `llm-330cf99` onto the frozen `llm-48d6f3e`, which is the current llm tip.
- The only conflict was in `designs/README.md`. I resolved it so the PR's net change there is unchanged: just the `daemon-agent-network-identity` date bump to 2026-10-19. A range-diff against the old commits shows only context differences.
- Force-pushed the head `daemon-agent-network-registration` (a34ba053fb → `bad6730979`) and moved the PR base to `llm-48d6f3e`. It is still a draft.

**CI result (run 41406446338): passed.** Every job succeeded, including `test` on 22.x/24.x for both Ubuntu and macOS-15, `cover`, `viable-release`, `lint` and `sandbox-drivers`.
- **The daemon suite ran on all four test legs:** 293 tests in `endo ›` passed on each, with no ✘ lines.
- The PR's new test "agents register their keys only with the networks in their own @nets" passed, and so did the `networks-ocapn` tests, including "agent key registration discloses nothing through the peer entry point".
- The bwrap "parent death" test now passes (115–161 ms on Ubuntu).

**Follow-ups:**
- The base change cancelled an earlier CI run on the same head (41406445248). It left three `cancelled` entries (bare `test`, `cover`, `viable-release`) in the PR's check list. I re-ran that run so those entries clear. It was still in progress when I stopped, and I didn't wait for it because it repeats the run that already passed. The gauntlet's CI watch will pick it up.
- #1566 is no longer needed to unblock #1503. Its other changes (graphviz/tsort dependency-cycle check, floot offline routing test, longer bwrap timeouts) still stand on their own.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1503-gauntlet-fix-1-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2549884 cached reads)
- Output: 10840 tokens
- Cost: $1.3682647999999997
- Wall-clock: 3404s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
