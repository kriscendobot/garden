---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
pr: https://github.com/endojs/endo-but-for-bots/pull/1379
fallback-tier: minion
---

# Post the gauntlet panel round-5 verdict on endojs/endo-but-for-bots#1379

Job `endojs-endo-but-for-bots-pr1379-gauntlet-20261007-panel-5` ran the panel on oros-studio (disposition **must-fix**, head `2c43a058c065a2a18b6e579e079d122cc2cd9666`). That host's PAT gets a 403 on `addPullRequestReview` for endojs, so this job is pinned to endolin to post the review.

1. Skip and complete if a review containing `<!-- garden-panel-verdict: round=5 disposition=must-fix head=2c43a058c065a2a18b6e579e079d122cc2cd9666 -->` already exists on the PR.
2. Otherwise post the text between the markers word for word with `gh pr review https://github.com/endojs/endo-but-for-bots/pull/1379 --comment --body-file <file>`. Use a comment review because request-changes is refused on a PR its author reviews. Append the usual provenance footer if you have one. Post it even if the PR head has moved, since the verdict names the head it ran against.
3. Do not fix anything and do not un-draft.

----- REVIEW BODY -----
## Panel review — round 5 (single-round gauntlet stage)

**Disposition: must-fix.** Head `2c43a058c0`, base `llm-1706e63` (`1706e63247fb`). All 33 seats ran (33 ok): 9 request changes, 14 comment-only, 10 approve. Posted as a comment review because GitHub refuses request-changes on a PR its author reviews; treat it as request-changes.

**Deterministic pre-passes (both bind must-fix)**
- Phase/evidence: `blocked` (`invalid-disposition`). The ledger declares `Disposition: orchestrated-slice`; the gate accepts only `deliverable` or `non-deliverable-probe`. Acceptance is `partial` (the § Verification replay == live check is handed to a successor), and the stop gate on #1370 (Q3/Q6/Q7) is still open.
- PR-body template: `NONCONFORMING`. The body is missing `### Documentation Considerations` and `### Upgrade Considerations`. Round 4's pruner asked to drop those empty sections; the template gate wins. Restore both with one sentence each, and keep the body short elsewhere. Upgrade needs real content: the body says "Schema version 2".

**Must-fix drivers**
- **integrator**: the two pre-pass failures above. Re-declare the ledger as `non-deliverable-probe` (or another accepted disposition) and refill the template headings. Should-fix: the base `llm-1706e63` does not express the stack on #1377 → #1376, so the diff carries `ae86b858a`/`d3af4b6dc`. Retarget the base or list the inherited SHAs.
- **prover**: the new `kill(pid, 0)` probe in `cas.rs` `process_is_dead` is not reached by any test. Pid `4294967295` hits the `try_from` early return, and the own-pid case is excluded before the probe runs. Add unix-gated tests: a live child pid (spared), then the same pid after reap (reclaimed, ESRCH), and pid 1 (EPERM, alive).
- **wire-watcher**: `check_resume` is optional and the crate's own harness (`tests/common/mod.rs:152`) skips it. Make `replay_plan`/`host_replay` take the expected `SnapshotMeta` and fail before returning bytes. Should-fix: `HostReplay::call` returns `reply.unwrap_or_default()`, so a missing reply on a non-outbound call is replayed as empty bytes instead of `Mismatch`. Also, `schema_version` is written but never checked on open.
- **archivist**: the `cas.rs` crate doc says xsnap's directory sync is missing, but this PR adds it in `xsnap/src/lib.rs`. Should-fix: the `Quiesced` doc cites the wrong open question. The "exact committed watermark" prose disagrees with the `max(...)` code in `publish_snapshot`. `designs/worker-quiescence-embargo.md` does not exist on base or head.
- **saboteur / wire-watcher / breaker (converging)**: `DuplicateSuppressor::receive` trusts the worker name parsed out of the sender-written key, and `parse::<u64>` accepts `+5`/`005`. A forged `victim:u64::MAX` key suppresses all of the victim's frames. Take the transport-authenticated worker as an argument and require the canonical key.
- **saboteur**: `abort_crank` drops staged opens, so the next crank reissues HandleId 1 while the adapter still holds the native resource. Record the opens as escaped/broken or return them. Should-fix: own-pid temporaries are never reclaimed when a restarted supervisor reuses its pid.
- **breaker**: `reclaim` deletes every 64-hex name not in `keep`, which breaks a shared or co-tenant store. Enforce one store per worker (an owner marker) or make it refcount-aware, and add a two-transcript test. `check_host_call_bounds` does not count transactional write sets or handle descriptors toward `max_host_bytes`.
- **packager**: the `Cargo.lock` hunks in `ae86b858a`, `d3af4b6dc`, `92d2b1a09` and `220f85da0` should be folded into the trailing `chore: Update Cargo.lock`. The unrelated daemon test fix `25f442f2d` should land separately.
- **purist** (should-fix): `CrankId`/`Sequence`/`HandleId` are interchangeable `u64` aliases; use newtypes. The idempotency key stores the identity twice, once as a string. `crank_state` returns a bare `String`; type it like `HostClass`.
- **pruner**: module docs in `fault.rs`/`host.rs` restate the variant docs. The quoted open-question citations will rot. The `embargo.rs` scope-history paragraph belongs in the design.

**Comment-only highlights**
- assessor: in `daemon-teardown.test.js:~222`, the losing `Promise.race` branch rejects unhandled. Should-fix: `publish_snapshot`/`compact` `take()` pending acknowledgments without restoring them on error, unlike `begin_crank`.
- integrator: leftover `seq` in error strings (`host.rs:1104,1244`, `lib.rs:155`, `tests/crash_matrix.rs:129`).


<!-- garden-panel-verdict: round=5 disposition=must-fix head=2c43a058c065a2a18b6e579e079d122cc2cd9666 -->
----- END REVIEW BODY -----
