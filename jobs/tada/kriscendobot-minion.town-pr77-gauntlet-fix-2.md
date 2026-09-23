CI is GREEN (rc 0). The round-2 fix is complete.

## Completion report

**Job:** Gauntlet FIX round 2 for kriscendobot/minion.town PR #77 (docs-only: an MCP tool-name naming convention + four design reconciliations).

**What I did:** Read the round-2 code panel verdict (29 seats, disposition `must-fix`, head `48411b8`) across the review body and its continuation comment, consolidated the cross-seat `must-fix` cluster, applied the fixes once, pushed as a follow-up commit, and watched CI to green.

**Changes (commit `3bc3922`, pushed to `docs/design-tool-name-reconcile`):**
- **README naming convention** (the dominant, ~15-seat must-fix): Rule 3 now qualifies collisions by a **fixed source-level facet precedence judged on the maximal all-facets-wired surface**, never by per-deployment mount order — with an explicit qualification form `<method><Facet>` and a note that a duplicate `registerTool` is a whole-surface boot crash (so collisions are resolved at design time). Rule 1 carves out the composed `status` tool; Rule 2 generalized beyond `guest_`/`clip_`.
- **git-remote-capability.md**: proposed `lookup` tool renamed to `identify` (a new read-only descriptor method, not the live-power `GuestAgent.lookup`) and its descriptor now **redacts the locator for bearer-shaped bindings** (capability-leak must-fix); `request` specified as create-only, non-awaiting (returns on send with `messageNumber`, rejection absorbed daemon-side), redemption via `has` not `readText`; reconciled against open PR #37's `intake.request`.
- **remote-guest-endo-cli.md**: invite cancel mounts as `cancelInvite` (paired subject, deployment-invariant); dropped the duplicated `cancel` in the delivery list.
- **endo-reminder / ertp-credits**: `reminder_*`/`credit_*` provisional names reconciled under the precedence rule, not mount order.
- **claude-agents-capability.md**: `submit` reclassified as a new `GuestFacet` method (facet + socket-adapter + in-memory-backend wiring, not tool-only) that fails closed on a non-form `messageNumber`.
- Refreshed the PR body (corrected "None collides", named the README convention and widenings) and posted a round-2 fix summary comment naming head `3bc3922`, the dispositions, and what was declined (typist arrow = repo house style; deep per-method reminder mirrors deferred to that design's build; pruner/fast-checker/coverage findings are follow-up).

**CI:** GREEN (typecheck + vitest, rc 0) — docs-only diff, no code touched.

**Follow-ups (not this stage's work):** the driver re-posts panel-3 to verify the fixes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr77-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 75 tokens (3828194 cached reads)
- Output: 34695 tokens
- Cost: $3.9208860000000003
- Wall-clock: 558s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
