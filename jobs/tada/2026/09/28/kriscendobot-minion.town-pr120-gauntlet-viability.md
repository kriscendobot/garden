**Viability gate: kriscendobot/minion.town PR #120** (`feat(claude): root-only delegate() attenuated sub-factory + design-gap closures`)

The PR is open, still a draft, and passes the gate: it hasn't been superseded and the reason for it still holds. I spent no clean, panel, fix, CI-wait or un-draft budget and made no repo changes.

Deciding question: Does `main` today still lack the root-only `delegate()` / `listDelegations` / `revoke` delegation surface, the never-reject boundary and the inbox-watch driver, while the landed design (`designs/claude-agents-capability.md`) still calls for them?

Answer: yes.

Evidence:
- **State:** head `8e6ed5e` is the retcon from earlier today; a tree-identical retcon with CI green is reported on the PR. There are no formal reviews. On 2026-09-28T21:02Z kriskowal asked to "run a gauntlet and retcon", so the maintainer wants this reviewed now.
- **Not superseded:** `main` is 38 commits ahead of the PR's frozen base `main-c815041`. Those commits are #119 (credential-expiry reauth), #118, #117, #80, #96 and harness bumps. None of them implements delegation:
  - `git grep` on `main` finds no `listDelegations`, `childAgentsFor`, `RootClaudeAccount`, `never-reject.ts` or `inbox-watch.ts`.
  - `neverReject` shows up only in code comments that point at a helper that was never written. That is exactly the gap the PR says it fills.
  - No other PR, open or closed, covers `delegate`.
- **Premise still holds:** the design on `main` still specifies `delegate()` (line 123), `RootClaudeAgents` and `RootClaudeAccount`. The follow-up that #97's approval asked for is still unbuilt.
- **Merge conflicts (not a viability issue):** merging with current `main` conflicts in `src/endo/claude/{account,agents,wiring}.ts`, because #119 touched the same files. This is a rebase against the base, not displacement. The gauntlet's clean stage, or a weave onto a fresh `main` snapshot, should handle it before the panel runs.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (341028 cached reads)
- Output: 2535 tokens
- Cost: $0.4976256
- Wall-clock: 118s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
