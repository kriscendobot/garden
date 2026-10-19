**Viability report for endojs/endo-but-for-bots#1503:** `viability=proceed`

**PR facts:** The PR is open, unmerged and a draft. It was created today (2026-10-19) and has no comments or reviews yet. Title: "feat(daemon): register agent keys with the networks in each agent's @nets". Base is the frozen `llm-330cf99` (330cf996c0), head is `daemon-agent-network-registration` @ 4491104e23.

**Deciding question:** Does live `llm` still lack per-agent network key registration (`registerAgentKey`/`unregisterAgentKey`), with the "Network registration" step of `designs/daemon-agent-network-identity.md` still open?

**Evidence:**
- **No newer base history.** The live `llm` tip is 330cf996c0, the same commit as the PR's frozen base. A compare of `llm-330cf99...llm` returns `ahead_by: 0`, so nothing newer can have displaced this PR.
- **Not implemented elsewhere.** A code search for `registerAgentKey` across the repo finds it only in `designs/daemon-agent-network-identity.md`, as the proposed interface. No implementation exists under `packages/`.
- **The motivating step is still open.** On `llm`, the design's Status is "In Progress". Items 1 and 2 are marked *(Done)*, and item 4, "Network registration.", is not. That is the step this PR builds.
- **No competing PR.** No other PR (open or closed) targets network or agent-key registration.
- **The open design PR doesn't displace it.** #138 (per-agent `@transports`) is open and undecided, and the PR body explains how this change fits #138's key-routing direction. If #138 later retires `@nets`, only where an agent's network list comes from would change; the network-side registration interface would stay the same.

Both claims hold: the PR has not been superseded, and the need it was built for is still open. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1503-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (178542 cached reads)
- Output: 1474 tokens
- Cost: $0.42510040000000004
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
