---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
pr: https://github.com/endojs/endo-but-for-bots/pull/1527
fallback-tier: minion
dispatch: automatic
---

# Update PR #1527's title and body (relay from oros: updatePullRequest 403)

Gauntlet fix-2 for https://github.com/endojs/endo-but-for-bots/pull/1527 pushed head `4ae508178c0` but could not edit the PR from host oros-studio-garden-ce242c49 (PAT lacks Pull requests: write). The panel's integrator seat flagged the stale body as must-fix: it still says the round-trip test is `#[ignore]`d.

Do ONLY this, then complete:

1. Check `gh pr view https://github.com/endojs/endo-but-for-bots/pull/1527 --json headRefOid`. Proceed if the head is `4ae508178c0…` or a descendant of it.
2. Set the title to `feat(endo): XS worker snapshot GC roots, round-trip test, and exit-path fixes`.
3. Set the body to EXACTLY the text between the BODY markers below (write it to a temp file and use `gh pr edit 1527 -R endojs/endo-but-for-bots --title ... --body-file <file>`).
4. Re-read the PR and confirm both stuck. Change nothing else; do not touch the draft state.

----- BODY BEGIN -----
## Description

Finishes Phase 2 of `designs/daemon-xs-worker-snapshot.md`.

- **Ephemeral GC roots.** `Supervisor::mark_suspended` pins the snapshot's SHA-256 in a ref-counted root set (`gc_roots()`). Resume adopts the pin as a `GcRootLease`. Both resume paths, in-process and child process, release it on the restored worker's first outbound frame or when its output ends. A worker sends nothing before its machine is rebuilt from the snapshot, so that frame shows the blob was read. A repeated suspend releases the replaced record's pin.
- **Round-trip test.** `supervisor_suspend_resume_round_trip` in `rust/endo/src/endo.rs` drives suspend and resume through the real routing callbacks. Further tests cover a store-backed resume, a failed process resume, and a repeated suspend.
- **Crank-end crash fix (`xsnap`).** The test exposed a SIGSEGV. The worker loop evaluated `__shouldTerminate()`, and `Machine::eval` has no catch frame, so a bundle without that hook crashed the process. The probe is now a `try`/`typeof` expression that never throws.
- **Exit-path race fix.** Each registration carries a generation (`register_tracked`). Worker exit paths unregister through `unregister_registration` with the generation their caller registered. A late exit therefore cannot clobber a handle that was suspended or resumed since.

### Security Considerations

None. The changes are in-supervisor bookkeeping, plus a probe that can no longer crash the host.

### Scaling Considerations

The root set is a small in-memory map with one entry per suspended snapshot.

### Documentation Considerations

The Phase 2 items in the design doc are marked done.

### Testing Considerations

`cargo test -p endo --lib` covers the round trip, the lease reference counting, the stale-exit cases, and the failure paths.

### Compatibility Considerations

`register`/`unregister` keep their signatures. `wire_worker_tasks` now takes the caller's registration generation and an optional lease. Bundles without `__shouldTerminate` now keep running instead of crashing.

### Upgrade Considerations

None. Suspend state lives in memory, so there is nothing to migrate.

<!-- garden-job: build-daemon-xs-worker-snapshot-supervisor-round-trip-test -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- BODY END -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-23T20:10:55Z
