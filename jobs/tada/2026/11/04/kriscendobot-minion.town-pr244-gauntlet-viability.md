Viability is `proceed`: PR #244 is open and unmerged, nothing has displaced it, and its motivating need still holds. I spent no clean, panel, fix, CI-wait or un-draft budget and changed nothing.

**PR facts:** #244 is an open draft, not merged, at head `e9d0a15af3`. Its base is `feat/claude-api-provider-ui-637a9a0`, a frozen snapshot of #229's current head `637a9a0885`. The PR is one commit ahead of #229 and zero behind. It has no comments or reviews yet.

Deciding question: As of 2026-11-04, does #244 remain the only implementation of the phase 4 API-key agent step and detail view, with that phase still required by a live, maintainer-approved design? Yes.

Evidence:
- **The need still holds:**
  - kriskowal approved design endojs/endo-but-for-bots#1543 on 2026-11-04 with "conduct the design and build the implementation".
  - `orchestrate-build-api-key-agents-20261104` is still running, with phase 4 among its children, and #244's job marker is that phase 4 child (`build-api-key-agents-p4-agent-factory`).
  - The commit is from 06:17Z today, and `main` (tip `9196892`, #234) has moved only on unrelated MCP and probe work since.
  - The tracker, kriscendobot/minion.town#227, is still open.
- **Not superseded by base or sibling PRs:**
  - `src/auth/agent-endpoint.ts`, `src/endo/agent-service.ts` and `src/auth/inference-provider-endpoint.ts` do not exist on `main`.
  - A search of the repo's PRs for "API-key agent" found no other implementation.
  - None of the recently active open PRs I checked (#241, #240, #239, #236, #231) touch the agent or provider files.
  - #229, which this PR stacks on, is still open at the same head. Its gauntlet ended held-draft with the code panel passed, so the stack is intact.
- **Not superseded by the related designs:**
  - #238 (the workbench design) builds on the same factory and detail view rather than replacing them, and #244 leaves the spawner to it.
  - #228 (the chat Clip design) is also a companion that sits on top of this work.
- **Not superseded on the Endo side:**
  - The factory branch `feature/api-key-agent-factory` (`a46a836e92`) is a separate piece, and #244's phase ledger lists it as the other half of phase 4. Its PR is not open yet; `build-api-key-agents-p4-agent-factory-open-pr` is queued to open it.
  - The older `exo-agent-factory` PRs are a different, general child-agent coordinator, not this UI.

Points for later stages (none affects viability):
- The older parked job `claude-api-p4-agent-factory` covers the same work under the earlier orchestration. It could produce a duplicate build if it is ever promoted.
- The maintainer decided on 2026-11-03 (on #227) that endowments are a step in the guest-creation dialog. #244 offers only the **Can create subagents** box, and the design's open question 5 in #238 is still undecided. The panel should check this gap, but it does not displace the PR.
- #244's ledger keeps it an orchestrated slice, so un-draft may be withheld at the end, as happened with #229.
- This host's PAT can't read `statusCheckRollup`, so I did not check CI status. Viability doesn't depend on it.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr244-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (286392 cached reads)
- Output: 5295 tokens
- Cost: $0.6365223999999999
- Wall-clock: 155s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
