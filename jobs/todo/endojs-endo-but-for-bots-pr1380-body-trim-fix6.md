---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# Update the PR body of endojs/endo-but-for-bots#1380 (gauntlet fix-6 handoff)

https://github.com/endojs/endo-but-for-bots/pull/1380. The fix-6 stage of the
`endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat-gauntlet` could not
edit the PR body from host oros-studio (bot PAT 403 on PR writes). The only task:
replace the PR body with the text between the markers below, verbatim, using
`gh pr edit https://github.com/endojs/endo-but-for-bots/pull/1380 --body-file <file>`.
It addresses the round-6 panel's pruner (concision: 457 → ~260 words) and
coverage-auditor (JS-test statement) findings. Keep the phase/evidence ledger and
the garden-job marker as they are. Do NOT un-draft the PR and do not touch code.

----- BODY -----
Refs: #1018

## Description

Connects the host-call transcript (#1379) to the live xsnap worker and, under a transcript, lifts the open-handle suspend refusal from #1150. Stacked on #1379 and #1374.

- Host callbacks are classed `pure`, `read`, or `barrier`; under a transcript, stateful and nondeterministic ones go through `Transcript::host_call`.
- Handles carry reconstruction descriptors and re-seat only on the published snapshot's verified heap, or as broken.
- Each delivery gets its own crank. A refused delivery stops the worker. Only the supervisor may attach or suspend.

### Security Considerations

Whoever can write the transcript chooses what a resumed worker reopens, including ambient `root` paths. The transcript holds generated keys, random bytes and hasher input in plaintext. Transcripts and heap snapshots are owner-only (`0600`) regardless of umask. They are not encrypted.

### Scaling Considerations

One durable SQLite commit per barrier, including each streamed `write` chunk; not benchmarked, since no daemon path attaches a transcript yet. Recorded reads store their full reply. Hasher retention is capped at 1 MiB per hasher and 16 MiB per worker; past either, the hasher re-seats as broken.

### Documentation Considerations

`designs/ironhorse-panic.md` § native-handle ownership replaces the old suspend-refusal paragraph.

### Testing Considerations

Rust: `rust/endo/xsnap/src/lib.rs` `tests`, `rust/endo/xsnap/src/powers/{crypto,sqlite}.rs` `tests`, and `rust/endo/slot-machine-transcript/tests/`. JS: `packages/daemon/test/bus-manager-rust-xs-powers.test.js` stubs the XS host globals under Node to check that every crypto power throws a host refusal; an XS-hosted daemon run is not needed for that wrapper.

### Compatibility Considerations

No behavior changes until a supervisor sends `host-transcript`, which no daemon path does yet.

### Upgrade Considerations

Out of scope: supervisor attach at spawn/restore, and the replay driver.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: `designs/ironhorse-panic.md`
Disposition: non-deliverable-probe
Probe-reason: worker-side slice only; the design's acceptance ("replay == live", "a declared barrier halts replay") needs the supervisor-attach and replay-driver follow-ups, which this PR does not include
Acceptance: deferred | worker-side evidence only (suspend/resume re-seat, broken-handle refusal, escaped-barrier recovery stop, in `xsnap/src/lib.rs` tests); replay-side bullets await the replay driver
<!-- /garden-phase-evidence-ledger -->

<!-- garden-job: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat -->



----- END BODY -----
