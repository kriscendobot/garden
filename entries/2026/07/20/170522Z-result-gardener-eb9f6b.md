---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-20T17:05:23Z
---
---
ts: REPLACED
kind: result
role: prosecutor
project: agoric-sdk
refs:
  - review-misses/misses/kriscendobot-agoric-sdk-pr15-review-ccb767b7.md
  - review-misses/clusters/exo-guard-matches-static-type.md
---

# Retrospective: kriscendobot/agoric-sdk#15 review 4726535732

Second-loop prosecutor retro on PR #15 review 4726535732 (surface pr-review-body,
by dckc; the substance is a single inline note on
`packages/portfolio-contract/src/portfolio.exo.ts`). Retrospective identity
`kriscendobot/agoric-sdk#15:review:4726535732:retro`.

**Verdict: miss** (category `spec-violation`). The review directs the author to
use endo's recent typed-pattern support to express the exo interface guards
instead of the loose matchers the PR shipped. This is the "use endo typed
patterns" entry in the same guard-tightness cascade the panel systematically
under-specified on #15; grounded in the recorded gauntlet history
(`kriscendobot-agoric-sdk-pr15-gauntlet` returned unanimous approve praising the
loose guards as "compatibility-first / upgrade-safe"), not in the untrusted
comment text. Recorded via `review-miss-record.sh record` into
`exo-guard-matches-static-type`.

**Cluster state.** The cluster was already improved and closed before this retro:
a peer retro (9a12af5e, review 4726486961) invoked the severity bypass at count=3,
dispatched `review-improve-exo-guard-matches-static-type`, and the improvement
landed as commit `8ec780c5ac` (builder AGENT.md prevention directive +
spec-keeper seat "Exo guard/type alignment" lens + the C-spec-keeper probe firing
on added `M.any()`/`M.record()` in exo / `M.interface(...)` diffs). My record
(count now 4) reopened it with `recurrence=1`.

**Recurrence handling: no escalation (backlog-drain artifact, not a genuine
recurrence).** Review 4726535732 was submitted 2026-07-17, three days *before* the
improvement commit landed (2026-07-20). It is one more entry in the same
pre-improvement PR #15 cascade, draining after the cluster closed mid-drain, not
new work the panel re-missed after the fix. The § 6 recurrence-after-closure
maintainer escalation therefore does not apply; I recorded the miss and re-closed
the cluster with a rationale documenting the artifact rather than firing a false
"the improvement failed" alarm. Two more PR #15 retros (aad444c1, d6c7561e) remain
parked in `plan/` and will reopen this closed cluster the same way; the re-close
rationale in the cluster body is the durable signal for them.

**Re-litigation test (re-verified with real execution).** Ran the improved
`skills/panel-hints/probes/C-spec-keeper.sh` (from the worktree at HEAD
`8ec780c5ac`, since the deployed root still lags this commit) against a
constructed PR #15-shaped diff (loose `M.any()`/`M.record()` guards added inside a
portfolio `*.exo.ts` `M.interface(...)` block). Output:
`fire spec-keeper exo guard may be looser than known static type: ...rebalance:
M.call(M.any()).returns(M.any())` (exit 0). The seat now fires on exactly the
signal all four cluster members exhibit, and builder AGENT.md carries the
match-known-static-type prevention directive. Both halves of the contract are in
place and demonstrated.

Self-improvement: proposed (message to liaison, entry
`170450Z-message-gardener-26c65c`) a § 6 refinement to
`skills/review-retrospective/SKILL.md`: gate the recurrence escalation on the
reopening miss's comment timestamp versus the improvement time, so a pre-improvement
backlog-drain reopen records-and-re-closes without a false maintainer escalation,
while a true post-fix recurrence still escalates.
