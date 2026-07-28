---
host: ps23-garden-f65473ae
role: gardener
last_drained_at: 1970-01-01T00:00:00Z
last_drained_commit:
---

# gardener inbox state on ps23-garden-f65473ae

Append-only failure log. Each section is a discrete failure event
appended by a job-board service or worker via
`skills/gardener-inbox-error-reporting/report-error.sh`. The gardener
reads entries on its next dispatch.


## lane 0 -- handler-nonzero failure at 2026-07-28T16:44:50Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7aa46954ae26004273188a125033ffead5b2da87
- Context: gardener-8 on ps23-garden-f65473ae: job 'validate-fireworks-job-end-to-end' handler exited rc=1

Inspect via `git -C journal cat-file -p 7aa46954ae26004273188a125033ffead5b2da87`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:45:17Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 3840b8f64a4d42520b13aba028034b0c5d450e0c
- Context: gardener-19 on ps23-garden-f65473ae: job 'arc-status-daily-20260728-033502' handler exited rc=1

Inspect via `git -C journal cat-file -p 3840b8f64a4d42520b13aba028034b0c5d450e0c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:45:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: e3ffc469d24e18b5f65c2eb25e73f278f0319908
- Context: gardener-11 on ps23-garden-f65473ae: job 'ocapn-noise-press-20260728-065010' handler exited rc=1

Inspect via `git -C journal cat-file -p e3ffc469d24e18b5f65c2eb25e73f278f0319908`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:46:17Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 109fe106fa8f052e5fd838a7cc396a017120a2f8
- Context: gardener-5 on ps23-garden-f65473ae: job 'fireworks-glm52-kimik3-build' transient-classified (rc=1) but elapsed near-constant (78,78s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 109fe106fa8f052e5fd838a7cc396a017120a2f8`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:46:26Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 59c97fb21dfe8b7fd6ae0ebd3540ea71f6b693ff
- Context: gardener-9 on ps23-garden-f65473ae: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' transient-classified (rc=1) but elapsed near-constant (62,62s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 59c97fb21dfe8b7fd6ae0ebd3540ea71f6b693ff`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:47:13Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: d451c0d155ec174341a2df000f6b48c9eb386c97
- Context: gardener-18 on ps23-garden-f65473ae: job 'job-host-requirements-gating' handler exited rc=1

Inspect via `git -C journal cat-file -p d451c0d155ec174341a2df000f6b48c9eb386c97`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:47:32Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 80682a7aa317d2405ed01b9b5065546b837b5084
- Context: gardener-17 on ps23-garden-f65473ae: job 'xs2rust-endor-s1-daemon-integration' transient-classified (rc=1) but elapsed near-constant (105,105s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 80682a7aa317d2405ed01b9b5065546b837b5084`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:47:44Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: 5181ed8b0e12cb03671923f6a8c59db3f36624ad
- Context: gardener-16 on ps23-garden-f65473ae: job 'wallclock-cost-proxy-for-censored-arms' transient-classified (rc=1) but elapsed near-constant (124,124s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p 5181ed8b0e12cb03671923f6a8c59db3f36624ad`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:54:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 88df2b84b58bd872ebf8873ad37da2dbad891b1f
- Context: gardener-18 on ps23-garden-f65473ae: job 'endojs-endo-but-for-bots-pr713-gauntlet-backfill' handler exited rc=1

Inspect via `git -C journal cat-file -p 88df2b84b58bd872ebf8873ad37da2dbad891b1f`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:54:32Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 243344d455e81f576b56dbc675df2c73504ace05
- Context: gardener-12 on ps23-garden-f65473ae: job 'gnome-backend-autotune-build' handler exited rc=1

Inspect via `git -C journal cat-file -p 243344d455e81f576b56dbc675df2c73504ace05`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:54:42Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: a781537f6fdc599b088aef95da1ae667d0582789
- Context: gardener-10 on ps23-garden-f65473ae: job 'improve-review-miss-gaming-category' transient-classified (rc=1) but elapsed near-constant (9,9s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p a781537f6fdc599b088aef95da1ae667d0582789`.

## lane 0 -- elapsed-constancy-overrun-suspect failure at 2026-07-28T16:55:34Z

- PR: (none)
- State: elapsed-constancy-overrun-suspect
- Transcript SHA: ec6157a2f07834292f2b2166624f663f33bf8c9c
- Context: gardener-13 on ps23-garden-f65473ae: job 'xs2rust-endor-press-20260727-182001' transient-classified (rc=1) but elapsed near-constant (48,48s) over 2 cycles — likely deterministic overrun, not a blip

Inspect via `git -C journal cat-file -p ec6157a2f07834292f2b2166624f663f33bf8c9c`.

## lane 0 -- handler-nonzero failure at 2026-07-28T16:56:09Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7aa46954ae26004273188a125033ffead5b2da87
- Context: gardener-12 on ps23-garden-f65473ae: job 'fix-warm-cache-yarn-install-state' handler exited rc=1

Inspect via `git -C journal cat-file -p 7aa46954ae26004273188a125033ffead5b2da87`.

## lane 0 -- handler-nonzero failure at 2026-07-28T17:03:38Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7aa46954ae26004273188a125033ffead5b2da87
- Context: gardener-3 on ps23-garden-f65473ae: job 'endojs-endo-but-for-bots-pr882-shepherd' handler exited rc=1

Inspect via `git -C journal cat-file -p 7aa46954ae26004273188a125033ffead5b2da87`.

## lane 0 -- handler-nonzero failure at 2026-07-28T17:04:03Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: b13607af48785e9eb92ccfced83050dbdb6ce252
- Context: gardener-6 on ps23-garden-f65473ae: job 'xs2rust-endor-s1-daemon-integration' handler exited rc=1

Inspect via `git -C journal cat-file -p b13607af48785e9eb92ccfced83050dbdb6ce252`.

## lane 0 -- handler-nonzero failure at 2026-07-28T17:13:31Z

- PR: (none)
- State: handler-nonzero
- Transcript SHA: 7aa46954ae26004273188a125033ffead5b2da87
- Context: gardener-4 on ps23-garden-f65473ae: job 'endojs-endo-but-for-bots-form-data-advisory' handler exited rc=1

Inspect via `git -C journal cat-file -p 7aa46954ae26004273188a125033ffead5b2da87`.
