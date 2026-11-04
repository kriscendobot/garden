---
posted_at: 2026-11-04T08:01:02Z
role: builder
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Open the phase 5 pinned responder PR on endojs/endo-but-for-bots

Repo: endojs/endo-but-for-bots. Relay from `build-api-key-agents-p5-pinned-responder`: the oros-studio PAT gets a 403 on createPullRequest to endojs, so this host-pinned job only opens the PR. The code is already pushed, so write no code.

Head: `feature/api-key-agent-responder` (52d32b7790)
Base: `feature/api-key-agent-factory-a46a836` (frozen snapshot of the phase 4 factory branch's head a46a836e92)

1. Get a checkout with `ensure-project-worktree.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-agent-responder` and run the next step from it.
2. Save the body between the markers below to a file and run:
   `ensure-pr.sh <this-job-base> endojs/endo-but-for-bots feature/api-key-agent-responder feature/api-key-agent-factory-a46a836 --title 'feat(hosted-agent,lal,fae): add the pinned responder for API-key guest agents' --body-file <file>`
3. In https://github.com/kriscendobot/minion.town/pull/245's body, replace both mentions of "branch `feature/api-key-agent-responder` on endojs/endo-but-for-bots" with the new PR's full URL.
4. Name the draft PR number in your report. If the phase 4 PR has opened by then, still open against the frozen base; a later weave restacks it.

----- PR BODY -----
Refs: #1543, #1575

## Description

Adds the pinned responder of `api-key-inference-providers-and-pinned-agents.md` phase 5, stacked on the phase 4 agent factory branch's frozen head. It generalizes minion.town #165's guest-pinned inbox responder: each message runs one bounded turn on the agent's own Lal or Fae harness through its `AgentInference`, and is dismissed only after the reply is durably sent. Its cursor and one effect record per message in flight commit as one snapshot, so restart and replayed delivery do not repeat a recorded effect.

A refused turn follows the design's dispositions. Concurrency and rate refusals back off from a minute, doubling to an hour. Budget refusals wait for the next UTC day. Other fixed codes, such as `provider-retired`, are marked refused. The eighth transient refusal, or 72 hours from the first, gives `retry-exhausted`. Deferred messages run oldest first and before new mail, and the sender is told nothing. The agent summary gains the deferred and refused messages, and the directory gains `retryMail`.

Attend to these, because each goes beyond a literal reading of the design:

- **Admission refusals change code.** The registry threw `inference-request-refused` for every admission refusal, which the design treats as terminal. It now throws the specific reason it already recorded, such as `agent-rate-limited`. Request-shape refusals keep `inference-request-refused`. The registry tests are updated to match.
- **The daemon terminates any worker holding a reference to a formula it collects** (`packages/daemon/src/residence.js`). So a launcher that held responders killed the shared worker hosting the factory on the first deletion, and deleting an agent that had never received mail did the same through the factory's reference to its guest. That second case is a latent defect in the phase 4 branch. Rather than change the daemon, this PR adds:
  - A provisioner caplet in the agent's own worker formulates the per-agent formulas and returns plain data.
  - Each responder registers a control object, which is not a formula, with the launcher.
  - Releasing a guest empties its mail and sets the formula aside until the next daemon start, when `purgeReleased` removes it. An empty guest formula therefore outlives deletion until then. A maintainer may prefer to narrow the daemon rule instead.
- **The responder is also pinned at the root.** The daemon revives only the root's `@pins` at startup, so a pin only in the guest's `@pins`, as the design describes, is retained but does not wake.
- **A failure with no fixed code is treated as transient** (`turn-failed`), including a turn past its one-hour wall clock. The design covers only admission refusals, but otherwise such a message would stall silently.

Known gaps for the maintainer:

- The harness transcript lives in the responder's worker, as `spawnWorkerLoop`'s does, so it does not survive a restart, and a reattachment that changes the model starts a new one. The design describes a transcript that outlives both.
- Lal's `define`, `request`, and `form` still reach only names the agent holds, as phase 4 reported, and tools calling methods outside a powers profile report an error to the model. The real-daemon tests take text-only turns, so no tool ran.
- No deployment formulates the factory or the launcher yet. The launcher's env must name `AGENT_RESPONDER_FACTORY`, `AGENT_RESPONDER_SELF`, and each harness specifier.

### Security Considerations

Harnesses still hold only the attenuated guest powers and the agent's `AgentInference`, and neither carries key material. The responder's state sits under the guest's `@pins`, which the harness facet refuses to name. The provisioner holds the root host briefly inside the agent's worker, before any harness runs there, and its formula is removed once it returns; the responder itself holds the launcher, which a compromised harness in that worker could reach only by escaping its closure. A refusal never produces mail to the sender, so budget state does not leak to another principal.

### Scaling Considerations

Each woken agent has one Node worker. A wake-off agent has none until first enabled. Each responder pass rereads `listMessages`, which is bounded by that agent's unread mail.

### Documentation Considerations

`packages/hosted-agent/README.md` gains a section on the responder and the launcher's env. A changeset covers `@endo/hosted-agent`, `@endo/lal`, and `@endo/fae`.

### Testing Considerations

`hosted-agent/test/agent-responder.test.js` covers every disposition with a fake clock. Five deliberate mutations were caught: four by named tests, and removing the 72-hour deadline by that test hanging. `daemon/test/agent-responder-restart.test.js` runs a real temporary daemon with the real registry, factory, launcher, and Lal and Fae harnesses, over the real Anthropic adapter with a faked `fetch`. It covers wake on each harness, a really refused admission that defers and then processes, Retry now, restart with a deferred queue, retirement, Dismiss, and deletion cancelling a held upstream request. The full `hosted-agent` and `daemon` suites were not run locally: only the responder, factory, registry, and issuer suites, plus all of `lal` and `fae`. Repo-wide lint auto-fix did not run either; pre-push gates ran `--probes-only` and `eslint` covered the changed files. No real upstream turn was taken.

### Compatibility Considerations

Callers matching `inference-request-refused` on an admission refusal now see the specific code. The grant surface has no callers outside this unmerged stack. The harness refactor in `lal/agent.js` keeps `spawnWorkerLoop`'s behavior, and `runRound` only gains a return value. The legacy subscription path is untouched, so it remains the rollback.

### Upgrade Considerations

Everything ships behind the disabled `apiKeyGuestAgents` flag; nothing formulates these caplets until a deployment does.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `api-key-inference-providers-and-pinned-agents.md` in https://github.com/endojs/endo-but-for-bots/pull/1543
Disposition: orchestrated-slice
Successor: orchestrate-build-api-key-agents-20261104
Phase 1: open | registry is in #1573, not merged
Phase 2: open | adapters are in #1575, not merged
Phase 3: partial | provider UI is in https://github.com/kriscendobot/minion.town/pull/229, draft
Phase 4: partial | branch `feature/api-key-agent-factory`, whose PR is pending, and https://github.com/kriscendobot/minion.town/pull/244
Phase 5: partial | this PR is the Endo half, tested on a real temporary daemon with a fake upstream; the detail view is https://github.com/kriscendobot/minion.town/pull/245, tested against an in-memory factory
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
  claimed_at: 2026-11-04T11:49:14Z
