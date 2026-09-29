---
child-endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript-host: oros-studio-garden-ce242c49
child-endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-outbound-embargo-host: endolin-garden2-5bcdff64
child-endojs-endo-but-for-bots-ironhorse-panic-outbound-embargo-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-transcript-host: endolin-garden2-5bcdff64
child-endojs-endo-but-for-bots-ironhorse-panic-transcript-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-debugger-panic-break-host: endolin-garden2-5bcdff64
child-endojs-endo-but-for-bots-ironhorse-panic-debugger-panic-break-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-cxs-panicked-adapter-failure-notified: recovered
child-endojs-endo-but-for-bots-ironhorse-panic-cxs-panicked-adapter-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-ironhorse-panic-cxs-panicked-adapter-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-classification-lint-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-ironhorse-panic-classification-lint-reap-count: 0
child-endojs-endo-but-for-bots-ironhorse-panic-e2e-probe-host: endolin-garden2-5bcdff64
child-endojs-endo-but-for-bots-ironhorse-panic-e2e-probe-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-ironhorse-panic-e2e-probe endojs-endo-but-for-bots-ironhorse-panic-classification-lint endojs-endo-but-for-bots-ironhorse-panic-cxs-panicked-adapter endojs-endo-but-for-bots-ironhorse-panic-debugger-panic-break endojs-endo-but-for-bots-ironhorse-panic-transcript endojs-endo-but-for-bots-ironhorse-panic-outbound-embargo endojs-endo-but-for-bots-ironhorse-panic-host-call-transcript endojs-endo-but-for-bots-ironhorse-panic-retry-replay endojs-endo-but-for-bots-ironhorse-panic-coda-reference-error endojs-endo-but-for-bots-ironhorse-panic-halt-shape-unification
on-child-failure: continue
state: running
created_by: gardener
created_at: 2026-09-29T08:55:09Z
---

# PR #1018 follow-ups: build every deferred branch of the Ironhorse panic design

Directive: kriskowal, https://github.com/endojs/endo-but-for-bots/pull/1018#issuecomment-5884163049. Plan, design, and build every deferred branch of `designs/ironhorse-panic.md`, and probe the feature end to end.

Legs run serially. The first is a gap-revealing end-to-end probe, which stays a draft. The rest are builds, each opening a draft PR and handing off to its own gauntlet: classification lint, the C-XS Panicked adapter with delivery-path ExecutionOutcome consumption, the debugger `<panic>` break, the Slot Machine transcript, the outbound embargo, host-call transcript and handles, terminate/restore/replay, the Coda (panic-on-reference-error), and the Halt shape unification.

The open design questions go to the manual mentat job `endojs-endo-but-for-bots-ironhorse-panic-open-questions-mentat`, which runs concurrently. The transcript-dependent legs read its answers.

The failure policy is `continue`: the legs are largely independent, so one failed leg should not strand the others.
