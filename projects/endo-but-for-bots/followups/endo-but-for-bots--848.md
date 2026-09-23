---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 848
created_at: 2026-07-28T16:47:00Z
last_appended_at: 2026-07-28T16:47:00Z
status: parked
---

# Follow-ups for endo-but-for-bots#848

Deferred findings from the backfilled panel round of 2026-07-28 (a six-seat
reduced code panel: assessor, migrator, packager, prover, integrator,
changeset-auditor). The blocking and should-fix findings went to the fixer job
`endojs-endo-but-for-bots-pr848-panel-fixes`; these are the out-of-scope items,
revisited automatically at merge time.

## Items

- [ ] Genie keeps a private `makePiAgent` copy and does not depend on
  `@endo/agentry`, while `packages/lal/agent.js:113` already routes through
  `@endo/agentry/harness` for exactly this reason. PR #848 wrote the same
  Pi-0.81 defaulting decision into two parallel implementations, so the next Pi
  bump pays the cost twice.
  **Source seat(s)**: integrator
  **Round**: 1
  **Recommended action**: open a follow-up PR folding genie's `makePiAgent`
  onto the `@endo/agentry/harness` implementation, or file an issue recording
  the deliberate divergence.

- [ ] Genie's compat-registry stream routing is pinned only by incidental
  integration coverage (construction side effects in unrelated tests). A named
  unit test asserting the constructed agent's stream function would be cheaper
  to keep honest.
  **Source seat(s)**: prover
  **Round**: 1
  **Recommended action**: open a follow-up PR adding one named test in
  `packages/genie/test/` pinning the constructor contract.

- [ ] pi-agent-core 0.81 moved its own type imports off `/compat` onto the
  pi-ai root, while PR #848 added two new `/compat` imports. Not blocking today,
  since `streamSimple` is not on the root export, but it is the next upgrade's
  cost.
  **Source seat(s)**: migrator
  **Round**: 1
  **Recommended action**: revisit at the next pi bump; prefer the non-compat
  entry point once `streamSimple` (or its successor) reaches the root export.

- [ ] 0.81's compat `streamSimple` selects a builtin provider by
  `(provider, api)` rather than `(provider, model id)`, and applies
  `withEnvApiKey` on the builtin branch where 0.80 did not. Repository faux
  providers register under `provider: 'faux'`, so no current test is affected,
  but a future model whose provider name collides with a builtin routes
  differently.
  **Source seat(s)**: assessor
  **Round**: 1
  **Recommended action**: record in the pi upgrade notes; add a guard test if a
  non-faux custom provider is ever registered.

- [ ] Pre-existing and not introduced by PR #848: the agentry eval test
  `conflict-rebase > outcome assertion fails when conflicted worktree is left
  mid-rebase` fails at baseline on a host whose global `rerere.enabled=true`
  leaks into the fixture repository.
  **Source seat(s)**: prover
  **Round**: 1
  **Recommended action**: open a follow-up PR pinning `rerere.enabled=false`
  locally in the git fixture repositories under `packages/agentry/test/`.
