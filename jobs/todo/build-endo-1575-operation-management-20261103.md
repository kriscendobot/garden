---
posted_at: 2026-11-03T18:47:46Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: https://github.com/endojs/endo-but-for-bots
pr: https://github.com/endojs/endo-but-for-bots/pull/1575
tracker: https://github.com/kriscendobot/minion.town/issues/227
task: Maintainer decision (2026-11-03, delegated to the liaison's discretion): add the Phase 3 operation-management contract to #1575 itself, not a follow-up PR. On the owner-scoped provider directory/admin facets, expose: (1) create-operation status by idempotency key, answering committed / in-progress / key-needed / not-found; (2) list of the owner's pending (intent / secret-created) operations; (3) cancel of an operation still in intent; (4) agent reattachment to another provider of the same kind, idempotent, keeping name, mail, wake state, conversation (and the replace-key path through it); (5) recording the owner's upstream-revocation assertion (upstreamRevocationAssertedAt). Follow designs/api-key-inference-providers-and-pinned-agents.md (PR #1543, branch design/claude-api-key-agents) sections "Step 1 unknown outcome", "Creation and retirement operations", and reattach. Never expose key bytes. Add tests per method, including crash/lost-response cases, then push to #1575's head and let the gauntlet run. Afterward note on kriscendobot/minion.town#229 that its Endo prerequisite is met so the rollout gate can be evaluated.
