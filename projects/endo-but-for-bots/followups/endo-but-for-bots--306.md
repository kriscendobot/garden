---
project: endo-but-for-bots
pr_repo: endojs/endo-but-for-bots
pr_number: 306
created_at: 2026-05-20T04:38:00Z
last_appended_at: 2026-05-20T04:38:00Z
status: parked
---

# Follow-ups for endojs/endo-but-for-bots#306

PR title: `feat(daemon): persona capability (epithets + verify) per designs/daemon-capability-persona.md`
Branch: `feat/daemon-capability-persona`
Head at ledger creation: `b6f332621`

The judge code-panel (23 seats) ran two rounds against this PR (rounds at `entries/2026/05/20/020226Z-result-judge-907068.md` and the matching round-2 result). Round 2 terminated with 0 must-fix-loop items at head `b6f332621` and CI 25/25 SUCCESS. The items below were dispositioned `follow-up`; the steward's per-cycle survey polls this ledger's PR for merge state and posts an `action-followups` job when the PR (or its upstream mirror) merges.

## Items

- [ ] Constrain or document the `relationship` free-form string vocabulary before connectors land.
  **Source juror(s)**: saboteur
  **Round**: 1
  **Recommended action**: open a follow-up PR adding `assertRelationship` at the host.js boundary and threading the assertion through `normalizeHostOrGuestOptions`. Pair with a design follow-up updating `designs/daemon-capability-persona.md` § Open Questions: controlled vocabulary.

- [ ] Address the cross-node verification gap. `verify()` compares `topLink.principal === handle` by `===`; the local-daemon case is sound (the daemon caches the exo), but `===` does not survive CapTP marshaling so cross-node verify silently returns `false` even on truthful claims.
  **Source juror(s)**: locksmith, wire-watcher
  **Round**: 1
  **Recommended action**: open a design follow-up describing how the verifier should resolve a remote subordinate's top-link principal to its local cached exo (likely via formula-id round-trip plus a `provide`-style cache lookup that crosses the OCapN node boundary). Implementation PR follows the design's acceptance.

- [ ] Re-run the locksmith lens (capability flow, attenuation) once `HandleControl` (revoke plus verification policy facet) lands. The current PR's verify default is confirm-when-stamped-by-me; richer policies (confirm-all, deny-all, selective) require a facet boundary that does not yet exist.
  **Source juror(s)**: locksmith
  **Round**: 1
  **Recommended action**: when the HandleControl design PR opens, file an issue cross-linking this ledger and naming the locksmith re-review as a panel requirement on the implementation PR.

- [ ] Commit-split discipline for the next persona PR: separate plumbing (types, interfaces) from runtime plus tests. PR #306 bundled them; the next persona PR (HandleControl, controlled vocabulary, cross-node verify) is a good place to apply the split.
  **Source juror(s)**: packager, integrator
  **Round**: 1
  **Recommended action**: brief the builder dispatch for the next persona PR with explicit commit-split instructions; reference this ledger so the discipline is not re-discovered.
