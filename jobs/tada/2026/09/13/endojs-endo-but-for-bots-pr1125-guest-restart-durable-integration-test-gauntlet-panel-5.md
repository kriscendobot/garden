Panel round 5 complete. Report follows.

---

**Gauntlet stage: PANEL round 5 — endojs/endo-but-for-bots PR #1125**

- Resolved PR head: `kriscendobot/endo-but-for-bots` @ `bot/build/endo-guest-invite-primitive`, base `llm` (real merge-base SHA `ff3ca7d45d706b55cf56480f36aea4eed67ae540`, passed explicitly to `panel.sh` since the base is an upstream branch).
- Provisioned an isolated project worktree and ran `panel.sh` in single-round mode (`GARDEN_PANEL_SINGLE_ROUND=1`). It fanned all 34 seats and decided **must-fix**.
- 5 seats returned request-changes: **prover**, **locksmith**, **breaker**, **engine-realist**, **corner-prober**. The dominant blocking findings:
  - **locksmith [must-fix]:** `EndoDirectory.readOnly()` does not recursively narrow nested sub-directory lookups — a holder of the read-only view can `lookup()` a nested directory and get full write authority, reachable via the new `provideGuest({ networks: readOnlyView })` path. Inconsistent with the sibling `EndoMount.readOnly()` which does recursively attenuate.
  - **corner-prober [must-fix-loop]:** leaf-only retention-key collision — two same-leaf invitations from one inviting agent on different paths (`['team-a','bob']` vs `['team-b','bob']`) clobber each other's retention pin at the shared `guest-bob` key.
  - **prover [request-changes]:** the `readable-directory` unwrap branch in `getAllNetworkAddresses` has zero test coverage; a read-only-`networks` guest would break on `.locate()` and no test would catch it.
- Posted the aggregate verdict on PR #1125 as a **comment** review (review ID timestamp `2026-09-13T01:42:24Z`) with an explicit MUST-FIX header. Request-changes was attempted first and rejected by GitHub ("Can not request changes on your own pull request") — the bot owns the PR head; this matches the convention rounds 1–4 already used on this PR.

No fix, un-draft, or loop performed (single-round stage, as specified). The gauntlet driver will read the stage marker below to schedule the next fix stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-guest-restart-durable-integration-test-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1498401 cached reads)
- Output: 9247 tokens
- Cost: $1.6566005000000001
- Wall-clock: 772s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
