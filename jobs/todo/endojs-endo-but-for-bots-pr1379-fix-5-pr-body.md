---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
handler-timeout: 1800
pr: https://github.com/endojs/endo-but-for-bots/pull/1379
dispatch: automatic
---

# Replace the PR body of endojs/endo-but-for-bots#1379 (handoff from fix-5)

Gauntlet stage `endojs-endo-but-for-bots-pr1379-gauntlet-20261007-fix-5` ran on host
oros-studio-garden-ce242c49. That host's bot token cannot edit PRs on endojs
(`updatePullRequest` returns 403), so this job is pinned to endolin.

Task: replace the body of https://github.com/endojs/endo-but-for-bots/pull/1379 with
the exact text between the BODY markers below (`gh pr edit 1379 --repo
endojs/endo-but-for-bots --body-file <file>`). Change nothing else: do not push, do
not un-draft, and do not edit the ledger. Before you replace the body, check
whether a later stage has already edited it (`gh pr view 1379 --json body`). If the
current body already has `### Documentation Considerations` and
`### Upgrade Considerations`, report that and stop.

What changed from the current body: it restores the template headings
`### Documentation Considerations` and `### Upgrade Considerations`, which the
panel-5 PR-body template gate required, and it lists the inherited stack commits
(`ae86b858a`, `d3af4b6dc`). The ledger stays `Disposition: orchestrated-slice`.
The current main2 `phase-evidence-gate.sh` accepts that disposition and returns
`hold-draft` (rc 30). The `invalid-disposition` result in panel-5 came from a
deployed gate older than commit bcecceb0c80.

----- BODY -----
## Description

Implements the host-call leg of `designs/ironhorse-panic.md` (§ Host functions are messages too) in `slot-machine-transcript`. Stacked on #1377 → #1376; the frozen base `llm-1706e63` predates them, so the diff also carries their commits `ae86b858a` and `d3af4b6dc`. Refs: #1018

Adds callback admission by classification; host calls recorded as `host-request`/`host-reply` events in the crank's commit; transactional effects as a declarative write set applied to a transcript-owned table; post-commit `outbound` effects; durable barriers; and logical handles, re-seated or marked broken on restart. Schema version 2.

Also carries the test-only fix `fix(daemon): eliminate orphan pid test race`.

Stays draft pending maintainer review of #1370 (Q3/Q6/Q7). Live XS wiring is the successor job below.

### Security Considerations

A misclassified callback, or a call refused after its effect ran, marks the handle broken and recovery stops. Transactional adapters return data, not code. Blob names are validated as SHA-256 digests.

### Scaling Considerations

Host calls per crank are bounded by `max_host_calls` and `max_host_bytes`; excess is refused with `Backpressure`.

### Documentation Considerations

Rust doc comments only; there is no user-facing surface yet.

### Testing Considerations

Crate tests drive the § Verification host-handle/effect contract, including escapes, refused barriers, and write sets applied once across a retry. CI runs the crate's fmt check, crash matrix, and embargo coverage test.

### Compatibility Considerations

The crate is new, with no consumers.

### Upgrade Considerations

Transcripts are stamped schema version 2, and opening one with any other version is refused rather than migrated. No version-1 transcript was ever deployed.

<!-- garden-phase-evidence-ledger:v1 -->
## Phase and evidence ledger

Design: designs/ironhorse-panic.md
Disposition: orchestrated-slice
Successor: endojs-endo-but-for-bots-ironhorse-panic-live-handle-reseat
Acceptance: partial | Covers the transcript side of § Verification's host-handle / effect contract: `tests/host.rs` drives admission, recorded replies, transactional write sets, outbound release, barriers, escapes, and handle reseat/broken marking against the transcript API in isolation. The metamorphic "replay == live" check that exercises handle reconstruction through a live XS worker is NOT covered here; it belongs to the successor. Gated on maintainer review of the Q3/Q6/Q7 answers in #1370 before this leaves draft.
<!-- /garden-phase-evidence-ledger -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)

<!-- garden-job: endojs-endo-but-for-bots-ironhorse-panic-host-call-open-pr -->






----- END BODY -----
