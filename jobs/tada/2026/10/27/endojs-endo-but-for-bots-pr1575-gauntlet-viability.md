The gauntlet for PR #1575 can begin (`viability=proceed`). The PR is new and nothing else does its work: no merged change or newer PR covers phase 2, and the design it implements was confirmed by the maintainer today.

**Deciding question:** Is #1575 still the only implementation of phase 2 of the design in #1543 (Anthropic API-key issuer, provider policy and accounting, and the `brokered-messages` adapter for Lal and Fae), with that design still current?

Yes.

**Evidence:**
- **PR state:** #1575 is OPEN and a draft, not merged, opened 2026-10-27T07:03Z with no reviews yet. Head is `feature/api-key-provider-adapters` @ `2515a686`. Base is `feature/api-key-provider-registry-43bf47f`, the frozen head of the phase-1 PR #1573.
- **Stack below it:** phase 1 (#1573, durable inference provider registry) is also OPEN and a draft on `llm-844ce3d`. Neither PR has been merged, so nothing has displaced the stack.
- **Base code:** none of the PR's main files exist on `llm` (each returned 404): `inference-provider-registry.js`, `inference-provider-policy.js`, `anthropic-api-key-issuer.js` and `lal/providers/brokered-messages.js`. The latest `llm` commits (2026-10-22 to 10-26) are zizmor, parcel, floot, Lal retry and captp work, with no API-key provider accounting.
- **Motivating premise:** the #1543 design is still open, and the maintainer answered its open questions on 2026-10-27. Those answers were folded in at `069b429c169`. They include "Anthropic only in the first release" and "lal default, fae advanced", which match this PR's scope. #1543's own gauntlet halted after 6 rounds pending maintainer action, but the design itself is still being pursued, not withdrawn.
- **Neighbouring PRs:** a search for PRs referencing #1543 turned up #1574 (an API-key agent workbench design), #1558 and #1563. Those are separate designs or features; none implements this PR's phase. The PR's evidence ledger hands phases 3–7 to `claude-api-build-20261027`, so the work fits the current plan.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no changes to the garden or the project.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1575-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179747 cached reads)
- Output: 1903 tokens
- Cost: $0.4574094000000001
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
