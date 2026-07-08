---
host: endolin-garden2-5bcdff64
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on endolin-garden2-5bcdff64

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-07T01:23:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d3846c1987b263f5e2a38cb2682862e82f46c857
- Context: gardener-19 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage5-coder-decl' handler exited rc=1

Inspect via `git -C journal cat-file -p d3846c1987b263f5e2a38cb2682862e82f46c857`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-07T02:45:16Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: 47919798b3b0dbe59454d4297d45ae3e5976e5fa
- Context: gardener-8 on endolin-garden2-5bcdff64: job 'xs2rust-endor-stage5-coder-decl' exit-0-unsatisfying but elapsed near-constant (1266,1266s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p 47919798b3b0dbe59454d4297d45ae3e5976e5fa`.

## lane 0 -- elapsed-constancy-exit0-wedge-suspect failure at 2026-07-07T06:25:21Z

- PR: (none)
- State: elapsed-constancy-exit0-wedge-suspect
- Transcript SHA: d9aed1437224ebbf7e88022e21fa40579a0fa97e
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'minion-town-phase3-google-idp' exit-0-unsatisfying but elapsed near-constant (109,109s) over 2 cycles — likely a wedged child, not a working one

Inspect via `git -C journal cat-file -p d9aed1437224ebbf7e88022e21fa40579a0fa97e`.

## lane 0 -- handler-nonzero failure at 2026-07-08T06:43:55Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 4debb6e629e4d2a90ba540c97de7dfa33beab454
- Context: gardener-2 on endolin-garden2-5bcdff64: job 'design-endo-daemon-cloudflare-storage' handler exited rc=1

Inspect via `git -C journal cat-file -p 4debb6e629e4d2a90ba540c97de7dfa33beab454`.

## lane 0 -- handler-nonzero failure at 2026-07-08T06:52:16Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 049076a7e1f30fe3690d22bca23c6b25e826341c
- Context: gardener-17 on endolin-garden2-5bcdff64: job 'endojs-endo-but-for-bots-pr637-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 049076a7e1f30fe3690d22bca23c6b25e826341c`.
