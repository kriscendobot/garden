---
host: endolin-garden-ece02cb4
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolin-garden-ece02cb4

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T12:36:22Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 386f3771f0e504b5d78d2439b887bd708efc7b24
- Context: gardener-15 on endolin-garden-ece02cb4: job 'pr-ebfb-286-shepherd' exit-0-unsatisfying but elapsed near-constant (179,179s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 386f3771f0e504b5d78d2439b887bd708efc7b24`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T22:06:52Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: ddf19dff486ab0b558b9b8cbd368a345044cdb59
- Context: gardener-9 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr615-gauntlet' exit-0-unsatisfying but elapsed near-constant (201,201s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p ddf19dff486ab0b558b9b8cbd368a345044cdb59`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-06T23:08:27Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: e729813ec647f015d0e4fbb88ab6b9a1af0e5de4
- Context: gardener-12 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr616-gauntlet' exit-0-unsatisfying but elapsed near-constant (881,881s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p e729813ec647f015d0e4fbb88ab6b9a1af0e5de4`.

## lane 0 -- handler-nonzero failure at 2026-07-10T08:07:00Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-13 on endolin-garden-ece02cb4: job 'self-heal-fix-garden-triager-kriscendobot-endo-revparse-verify' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- handler-nonzero failure at 2026-07-10T08:35:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 6f9794aaa0ba08ac0d3ca49b21e919641eeb92b1
- Context: gardener-17 on endolin-garden-ece02cb4: job 'xst-validation-orchestrator-20260710-083510' handler exited rc=1

Inspect via `git -C journal cat-file -p 6f9794aaa0ba08ac0d3ca49b21e919641eeb92b1`.
