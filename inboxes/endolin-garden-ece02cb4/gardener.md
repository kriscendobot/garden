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

## lane 0 -- handler-nonzero failure at 2026-07-10T08:43:40Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-4 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr14-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- handler-nonzero failure at 2026-07-10T09:05:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b0a1225026f36f1f388e4b212c220b80e8448786
- Context: gardener-13 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr13-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p b0a1225026f36f1f388e4b212c220b80e8448786`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T11:55:52Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 4eb62734ebabd7ab4b8b87ac5fa1b6cfab81dea6
- Context: gardener-15 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr14-fix-chaininfo-snapshots' exit-0-unsatisfying but elapsed near-constant (148,148s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 4eb62734ebabd7ab4b8b87ac5fa1b6cfab81dea6`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T12:34:16Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: be7f5ba9b7dfdd89fe3ab6ddabda9ef71f550c03
- Context: gardener-18 on endolin-garden-ece02cb4: job 'kriscendobot-agoric-sdk-pr13-fix-chaininfo-snapshots' exit-0-unsatisfying but elapsed near-constant (646,646s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p be7f5ba9b7dfdd89fe3ab6ddabda9ef71f550c03`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-10T15:44:06Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: a184ce2cb49ea67f491f858a1b23ebf92a1ddca9
- Context: gardener-6 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-667-genie-stdio-jsonl-rpc-bridge' exit-0-unsatisfying but elapsed near-constant (37,37s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p a184ce2cb49ea67f491f858a1b23ebf92a1ddca9`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-10T17:28:05Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: e02c7978c47e9ee7a4678c67ddc743981852e9c2
- Context: gardener-3 on endolin-garden-ece02cb4: job 'gauntlet-endo-but-for-bots-pull-request-672-genie-subscription-oauth' transient-classified (rc=1) but elapsed near-constant (252,252s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p e02c7978c47e9ee7a4678c67ddc743981852e9c2`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:33:36Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be6fc8fbd936bd0e38373d8fda3d1e35f8b421f5
- Context: gardener-4 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr650-conduct' handler exited rc=1

Inspect via `git -C journal cat-file -p be6fc8fbd936bd0e38373d8fda3d1e35f8b421f5`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:38:57Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 5633f3c3cc1a5ac8402712ab69abfa27db82d394
- Context: gardener-1 on endolin-garden-ece02cb4: job 'readme-control-surface-illustrations' handler exited rc=1

Inspect via `git -C journal cat-file -p 5633f3c3cc1a5ac8402712ab69abfa27db82d394`.

## lane 0 -- handler-nonzero failure at 2026-07-10T17:46:25Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: be68bd60cf955c59acac52dad67aa7f8a09da278
- Context: gardener-1 on endolin-garden-ece02cb4: job 'endojs-endo-but-for-bots-pr618-6a3affe0' handler exited rc=1

Inspect via `git -C journal cat-file -p be68bd60cf955c59acac52dad67aa7f8a09da278`.
