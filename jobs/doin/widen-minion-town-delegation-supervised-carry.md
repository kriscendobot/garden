---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Widen the minion.town delegation to supervised carry (no escalations)

Maintainer directive, recorded verbatim in journal entry
`entries/2026/10/07/203746Z-message-gardener-a253b1.md` (read it first; it is the
authorization the delegation record must bind to). Summary: the maintainer will review
minion.town as a whole once the objectives in https://github.com/kriscendobot/garden/issues/58
and https://github.com/kriscendobot/garden/issues/89 are satisfied and validated in
production; arc supervisors carry `kriscendobot/minion.town` PRs through review and merge.
The maintainer chose **"Everything, no escalations"** over keeping the existing
escalation paths. Endo changes keep maintainer review (not in scope here).

Current state (verify, do not trust): `scripts/jobs/minion-town-screening.sh status`
reports `denied: ... config/delegations/minion-town-pr-screening` missing, so the #139
delegation was never seeded on the journal and screening is inert. Design and operator
doc: `designs/minion-town-pr-screening.md`, `context/operations/minion-town-screening.md`.
Code: `scripts/jobs/screening/{policy,driver,control,report}.py`,
`scripts/jobs/screen-delegated-prs.sh`, `ci-wait-merge.sh --screened-delegated-merge`.

## Change

1. Authorization: the record's `AUTHORIZATION` must point at the new entry above, and its
   digest check must bind to that entry. Keep the schema-versioning honest (a record bound
   to the old #139 entry must not silently validate against new semantics).
2. Scope (policy.py): admit PRs on any base in `kriscendobot/minion.town` (frozen
   `main-<sha>` bases, stacked heads), not only `main`; admit PRs the supervisors have
   un-drafted. A PR that is still draft is never merged by the screen; the SUPERVISORS
   un-draft after a passing gauntlet. Gap-revealing probes (PR bodies or jobs marked
   probe/gap-revealing) stay draft and are never screened. Author stays `kriscendobot`.
3. Escalations: empty `escalate_paths`, `escalate_except`, and `escalate_sections`. The
   300-file compare-limit fail-closed rule stays (it is a correctness limit, not policy).
   Do NOT remove: CI terminal-green, completed gauntlet at the exact head, human
   CHANGES_REQUESTED blocks that one PR, the production-baseline gate, post-merge
   validation, pause-and-heal, auto-resume, and the maintainer pause/resume/revoke
   controls. Those are safety mechanisms the maintainer's choice did not touch.
4. A stacked PR may merge only after its base PR has merged and it has been restacked
   onto the live base (weave); the screen must not merge a PR into a stale frozen base.
5. Tests: extend `scripts/jobs/test/minion-town-screening-test.py` and
   `ci-wait-merge-screening-test.py` for the new scope, empty escalations, and the
   stacked-base rule. Update the operator doc and design.
6. Seed: run `scripts/jobs/minion-town-screening.sh seed` against the journal once landed
   and deployed to the leader, then `status` must print `active`. Post the result as a
   journal message. Arming is the deliberate act; record that you did it and when.

Land on `main2` directly (the garden's own repo takes no PR workflow). The maintainer's
`pause`/`revoke` controls must work on the widened record exactly as before.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-07T20:39:08Z
