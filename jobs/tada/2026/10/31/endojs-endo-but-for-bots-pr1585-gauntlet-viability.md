**Viability report: endojs/endo-but-for-bots#1585**

PR #1585 is open, unmerged and in draft. It was opened 2026-10-31T05:10Z, against base `llm-9a14ddf`, with head `9915ffcd`. It has no reviews and no comments yet.

Deciding question: Does `llm` still run `test-ironhorse-oracle` on `ubuntu-latest` (now ubuntu-26.04, glibc 2.43) with the old exact pins for `stage3-math/054.js` and `055.js`, and has no other PR or base commit already fixed or replaced that drift? Yes.

Evidence:
- **Runner unchanged:** in `llm`'s `.github/workflows/ci.yml`, `test-ironhorse-oracle` still has `runs-on: ubuntu-latest` (line 1035). So the drift to ubuntu-26.04 / glibc 2.43 that caused this PR still applies.
- **Pins unchanged:** the last `llm` commit to touch `stage3-math/054.js` is `12bf30641a` from 2026-09-01. That predates the ubuntu-26.04 rollout, so the old exact pins are still there.
- **Base is current:** the PR's base `9a14ddf` is the current `llm` tip (0 commits ahead), so nothing newer has landed.
- **No competing PR:** I searched for "ironhorse-oracle", "asinh", "ubuntu-26.04" and "ubuntu-24.04". Several open PRs deal with the 26.04 move, but none touches the stage3-math cases, `math-corpus-libm.tsv`, or the oracle job's runner:
  - #1556 and #1582 pin only `browser-test.yml` and `depcheck.yml`.
  - #1542 and #1566 cover the bwrap and graphviz problems.
- **Known failure:** the shared memory note `ebfb-ci-ubuntu-2604-sandbox-ulimit` already lists the oracle corpus tests among the checks that fail on every PR under ubuntu-26.04. #1585 is the fix for that check, and other gauntlets that stopped on it (for example #1117) can be re-run once it lands.

Verdict: proceed. The PR has not been superseded, and the problem it fixes still exists on the current base.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1585-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (212526 cached reads)
- Output: 2174 tokens
- Cost: $0.4231212
- Wall-clock: 70s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
