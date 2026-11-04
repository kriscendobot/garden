---
posted_at: 2026-11-04T06:23:18Z
role: builder
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the phase 4 agent factory PR on endojs/endo-but-for-bots

Repo: endojs/endo-but-for-bots. Relay from `build-api-key-agents-p4-agent-factory`: the oros-studio PAT gets a 403 on createPullRequest to endojs, so this host-pinned job only opens the PR. The code is already pushed, so write no code.

Head: `feature/api-key-agent-factory` (a46a836e92)
Base: `feature/api-key-provider-adapters-0b8d24a` (frozen snapshot of #1575's head 0b8d24a114)

1. Get a checkout with `ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-agent-factory` and run the next step from it.
2. Save the body between the markers below to a file and run:
   `ensure-pr.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-agent-factory feature/api-key-provider-adapters-0b8d24a --title 'feat(hosted-agent): add the agent factory for API-key guest agents' --body-file <file>`
3. In https://github.com/kriscendobot/minion.town/pull/244's body, replace "branch `feature/api-key-agent-factory` on endojs/endo-but-for-bots" in the Phase 4 row with the new PR's full URL.
4. Name the draft PR number in your report. If #1575 has merged or moved by then, still open against the frozen base; a later weave restacks it.

----- PR BODY -----
Refs: #1543, #1575

## Description

Adds the agent factory of `api-key-inference-providers-and-pinned-agents.md` phase 4, stacked on #1575's frozen head. It is the root-private coordinator that creates a Lal or Fae guest agent attached to one of its owner's providers, then changes its wake state, limits, or provider and deletes it. Each change is an idempotent operation record, and a reconciler resumes any that a crash interrupted.

Requests are closed and name what the agent receives, so the subagent-creation slot stays empty unless the request names it. The owner's inventory entry is the agent's mail handle, not its guest powers. A driver's `AgentInference` follows the record's current grant, so reattaching does not replace the reference the driver holds. The responder and the spawner are participants: phase 5 supplies the real responder, and tests here use a stand-in and a fake spawner.

To review first: `runOperation` and `STEPS` in `agent-factory.js`, where a fixed refusal before commit aborts and anything after commit only rolls forward.

### Security Considerations

Harnesses get an exact method list per profile with no formula-id lookups. Any name beginning with `@` is refused, because `@host` on these guests is the root host. A provider capability from another owner is refused with `provider-owner-mismatch` before any effect, and through the owner's directory a foreign id is the same `provider-not-found` as an unknown one.

### Scaling Considerations

Mutations run one at a time per factory, and model discovery and mail reads stay outside that queue. The reconciler sweeps every record once a minute by default.

### Documentation Considerations

The `@endo/hosted-agent` README describes the factory and its caplet's required names.

### Testing Considerations

`agent-factory.test.js` crashes at every boundary a clean run crosses, discovering them rather than listing them, and recovers by retry and by reconciler. `agent-factory-restart.test.js` covers confinement, unread mail, and rebinding on a real daemon.

### Compatibility Considerations

Additive. The registry gains `listGrants`, and `InferenceProviderUse` gains `describe`. Nothing creates a factory until a deployment does, and the minion.town companion keeps its surface behind a disabled flag.

### Upgrade Considerations

None; the factory's journal starts empty.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `api-key-inference-providers-and-pinned-agents.md` in https://github.com/endojs/endo-but-for-bots/pull/1543
Disposition: orchestrated-slice
Successor: orchestrate-build-api-key-agents-20261104
Phase 1: open | registry is in #1573, not merged
Phase 2: open | adapters are in #1575, not merged
Phase 3: partial | provider UI is in https://github.com/kriscendobot/minion.town/pull/229, draft
Phase 4: partial | this PR is the Endo half, https://github.com/kriscendobot/minion.town/pull/244 the UI; both tested against a stand-in responder and a fake spawner
Phase 5: delegated | build-api-key-agents-p5-pinned-responder owns the responder and mail processing
Phase 6: delegated | api-key-agents-canary-and-retirement owns the production canary
Phase 7: delegated | api-key-agents-canary-and-retirement owns legacy migration
Acceptance: open | launch acceptance needs phases 1-6 and real upstream turns, none of which this PR provides
<!-- /garden-phase-evidence-ledger -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-04T08:34:24Z
