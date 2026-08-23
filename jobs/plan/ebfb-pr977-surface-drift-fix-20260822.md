---
gate: go-ahead
priority: normal
role: fixer
tier: mentor
token-budget: 100000
doomed: true
doom_signature: deadline-overrun
doom_count: 1
requeue_cycles: 1
deadline_overruns: 1
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-23T02:43:38Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-23T02:43:38Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
repo: endojs/endo-but-for-bots

Drive https://github.com/endojs/endo-but-for-bots/pull/977 to green and merge-ready.
It is OPEN, un-drafted, lint is green, but the `test` legs (node 22.x/24.x on
ubuntu and macos) fail deterministically on a guest method-surface assertion in
`packages/daemon/test/endo.test.js` (~line 6429).

## Diagnosis (verify before editing)

The failing assertion is a deepEqual of the guest's expected method-name list.
The expected snapshot still lists `provideSubMount`, which the actual daemon
guest surface no longer exposes (a `provide*` method renamed/removed on the
`llm` base while this PR's expected list stayed pinned). This looks like
rebase/weave drift of the expected surface snapshot against `llm`, not a
host-only-method leak. Confirm this by comparing the PR's expected list against
the current daemon guest surface on `llm` before changing anything.

## What to do

1. Weave/rebase PR 977 onto current `llm` if it is behind, then reconcile the
   expected guest method-name list in `endo.test.js` to match the real current
   guest surface. Change ONLY the drifted names; do not weaken the security
   coverage this PR exists for — the full host-only-method-absence checks (the
   loop over `hostOnlyMethodNames`, the host-only delta, and `@host` rejection)
   must remain intact and still assert every host-only method is absent from and
   rejected at the guest/@host boundary.
2. If the drift turns out NOT to be a benign rename (i.e. a host-only method has
   actually appeared on the guest surface), STOP and report — that would be a
   real regression, not a test fix.
3. Confirm CI goes fully green, then shepherd/conduct per the maintainer's
   standing "weave, shepherd, conduct" directive on the PR.

## Notes

- Keep security-incident specifics out of commit messages and the PR
  description; this is the daemon-side regression coverage from a prior incident.
- A long worktree path can overflow the unix `sun_path` limit when running the
  daemon tests locally; a peer used an uncommitted `ENDO_TEST_DIRNAME` shim.
  A failure of that shape is an environment artifact, not a broken test.
- Context: the prior `lint-unstick` job's lint fix is already landed and green;
  this failure came in with a later panel-1 fix commit (head `dc39fef1`). The
  earlier weave/shepherd attention-directive (`...pr977-64413faf`) was doomed.
