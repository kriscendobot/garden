# Fix round 6 for kriscendobot/minion.town PR #165: three code must-fixes pushed, CI green, but the next panel will still block

I pushed `fc7ff2f` to `feat/claude-pinned-responder` and CI finished green (`ci-wait-merge` rc 0, 3/3 checks). The fourth must-fix can't be fixed with code, so panel-7 will still come back "must-fix" (see below).

## What I changed
1. **Assessor: unattributed sender.** In `src/endo/claude/inbox-responder-caplet.ts`, a message whose `from` can't be resolved to a sender is no longer treated as inbound. It is skipped the same way a message from the child itself is, so it can't spend an inference. In the caplet test, `from` is now optional and the test feeds a message with no sender, checking that it gets no inference, no effect and no dismissal.
2. **Curator: `watchInbox` on the shared type.** I removed `watchInbox` from the shared `ClaudeAgents.create` options and added a root-only `create` override to `RootClaudeAgents` in `src/endo/claude/types.ts`. Its doc comment says the option is root-only and returns `unavailable` when no responder endpoint is configured, which also covers the typist's request for docs. The runtime `caller.isRoot` check stays, because remote callers aren't bound by the type. The delegated-facet test now casts to call `create` with the option and still expects `unavailable`.
3. **Breaker: concurrent create race.** In `src/endo/claude/agents.ts`, when the inbox-responder install fails, a child this call published is now torn down only if no caller has been handed its agent. If a concurrent plain `create` already got the handle, the child stays live without a responder. A new test runs `create("w", {watchInbox:true})` and plain `create("w")` together with the install failing. It fails without the fix and passes with it.

## Checks
- `tsc --noEmit` is clean.
- The claude test files pass.
- In the full `npm test`, 937 tests pass and 1 fails: `test/git-remote/capability.test.ts` "propagates a git failure". That failure is a known one on this host's environment and this diff doesn't touch it.

## Not addressed (should-fix or comment-only)
- Assessor: the responder-restore loop doesn't check whether the delegation is still live.
- Breaker #2: a transport-level `unavailable` dismisses the message, so mail is lost while the app is down.
- Breaker #3: the two rate-cap windows sit on different clocks and can disagree.
- Breaker #4: effects are keyed on message numbers and never pruned.
- Integrator: the "responder" vs "inbox-watch" naming split, deferring per-child rate tunability, and squashing the fixup commits.

## Needs a decision
Every round, the integrator seat and the phase/evidence pre-pass return `phase-evidence-verdict=blocked`, `probe-must-remain-draft`. The PR's own ledger declares it a non-deliverable probe: Phase 1 is blocked on the unlanded Endo substrate (#150), and Phases 2–6 and the acceptance evidence are open. That forces "must-fix" no matter what the code looks like, so the gauntlet will keep looping (this is already fix round 6). The driver or maintainer should take PR #165 out of the gauntlet and leave it as a draft probe until Phase 1 lands and the production canaries are recorded.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr165-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1212726 cached reads)
- Output: 8670 tokens
- Cost: $0.9789132
- Wall-clock: 425s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
