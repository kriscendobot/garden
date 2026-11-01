**Viability report for endojs/endo-but-for-bots PR #1627**

- **State:** open, still a draft, not merged. Head is `a5b9c94a87`. Base is `build/exo-agent-factory-durable-inference-driver-5842e0c`, a frozen snapshot of #1626's head. The PR was opened 2026-11-01T18:40Z.
- **What it changes:** test files only. It adds the caplet `packages/exo-agent-factory/test/_daemon-crash-maker.js` and one test in `test/daemon.test.js`. The test covers the design's crash point inside `infer` on a real daemon (`designs/endo-child-agent-factory.md` § Verification).

Deciding question: Is there still no real-daemon test anywhere on `llm` or in the open #1558→#1626 stack for a crash inside `infer` after a tool effect, and does that stack, which the test needs, still exist and remain unmerged?

Evidence:
- **No PR has replaced it.** A search of PRs in every state for "crash infer daemon exo-agent-factory" finds only #1627 and its own stack (#1558 design, #1560, #1563, #1625, #1626). All of them are open.
- **`llm` has nothing that covers this.** `packages/exo-agent-factory/test` does not exist on `llm` yet (the API returns 404), so no test there covers this crash point.
- **The reason for the PR still holds.** #1626's report said real-daemon crash tests were not done, and #1563's in-memory ledger tests only cover a fake host.
- **The base is close to current.** #1626's head (`7a1feb30`) is exactly 1 commit ahead of the frozen base `5842e0c`. That commit is a formatting change to `adapters.test.js`, which does not touch `daemon.test.js`. Compared with its base, the PR adds exactly 1 commit touching only its 2 files.
- **Follow-up after #1626 lands:** the PR will need to be retargeted to a new base. That is expected for a stacked PR and does not affect viability.

Verdict: proceed. No clean, panel, fix, or CI budget was spent.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1627-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (237732 cached reads)
- Output: 1820 tokens
- Cost: $0.44902639999999994
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
