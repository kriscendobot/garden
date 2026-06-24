---
ts: 2026-05-18T04:47:00Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

# XS worker snapshot: ephemeral GC root bookkeeping (Phase 2 wrap-up)

Opened draft PR endojs/endo-but-for-bots#281 against the `llm` base
(branch `feat/xs-worker-snapshot-cas-gc-roots-20260518-044324`,
head `b2d28b3d8`).

Implements the second of the two items listed in
`designs/daemon-xs-worker-snapshot.md` § Phase 2 *Remaining*: the
ephemeral GC root bookkeeping for CAS-stored worker heap snapshots.
The first remaining item (full supervisor round-trip integration test)
is deferred; see *Deferrals* below.

## What landed

- `rust/endo/src/supervisor.rs`:
  - `Supervisor` gains an optional `OnceLock<Arc<ContentStore>>`.
  - `set_cas` / `cas` accessors for one-time wiring.
  - `mark_suspended` calls `ContentStore::retain` on the snapshot
    SHA-256 hash; `take_suspended` and the new
    `cancel_suspended` call the matching `release`.
- `rust/endo/src/endo.rs`:
  - `Endo::serve()` calls `self.supervisor.set_cas(...)` right after
    opening the content store.
- `designs/daemon-xs-worker-snapshot.md`:
  - *Done in this cycle* subsection added under Phase 2 *Remaining*;
    integration-test bullet annotated with the JS-bundle precondition.
  - Metadata table `Updated` bumped to 2026-05-15.
- `designs/README.md`:
  - Summary row `Updated` and prose updated.

## Tests

Nine tests in `supervisor::tests`, six new, all passing:

- `mark_suspended_retains_snapshot_in_cas` (new, load-bearing).
- `take_suspended_releases_snapshot_in_cas` (new, load-bearing).
- `cancel_suspended_releases_snapshot` (new, load-bearing).
- `double_suspend_does_not_inflate_refcount` (new; documents the
  current leak shape so a future intentional change is visible).
- `suspend_without_cas_still_works` (new; safety contract for
  unit-test harnesses that do not wire CAS).
- `set_cas_is_idempotent` (new; first-set-wins invariant).
- `suspend_resume_preserves_platform` (pre-existing).
- `suspend_fallback_defaults_to_separate` (pre-existing).
- `suspend_preserves_meter_state` (pre-existing).

Full endo crate suite: 74 passed, 0 failed.

### Regression evidence

Per `garden/skills/regression-evidence/SKILL.md`, each load-bearing
test was proven by breaking the smallest code path it covers:

- Replacing `cas.retain(&sha256)` in `mark_suspended` with a no-op
  fails `mark_suspended_retains_snapshot_in_cas` (asserts
  `snapshot must survive gc while worker is suspended`) and
  `double_suspend_does_not_inflate_refcount`. The release-only path
  still passed because the snapshot was never retained, so a single
  `take_suspended` removed nothing. Reverted; tests pass.
- Replacing `cas.release(&sw.sha256)` in `take_suspended` with a no-op
  fails `take_suspended_releases_snapshot_in_cas` (asserts
  `snapshot must be collectable after resume releases the ephemeral
  root`) and `cancel_suspended_releases_snapshot`. Reverted; tests
  pass.

## CI

CI on PR #281 was pending at the time of this entry. The pre-existing
`eval_worker_bootstrap` failure in the xsnap crate is unrelated and
predates this PR; it needs `ses_boot.js` / `worker_bootstrap.js` /
`daemon_bootstrap.js` to be present in `rust/endo/xsnap/src/`, which
are produced by `packages/daemon/scripts/bundle-bus-daemon-rust-xs.mjs`
and are not checked in. I stubbed them empty to get the workspace to
compile; the suspend/resume supervisor tests do not exercise the
bundles.

## Deferrals

- **Full supervisor round-trip integration test** (the first item
  in Phase 2 *Remaining*). The test needs a working XS worker to
  drive the `suspend` control verb through to a real CAS-backed
  snapshot, then a `restore` round-trip. From a fresh checkout the
  three JS bundles named above are absent and the xsnap crate's
  bundle-dependent tests already fail. Driving this from a builder
  dispatch would either need the bundler step to be wired into the
  Rust build (a non-trivial change to CI hygiene) or a longer
  fixture-checkin to land the bundles. Left for a separate PR;
  the design's *Remaining* section now records the precondition.

## Self-improvement

`skills/regression-evidence` is canonical and worked unchanged on a
pure-Rust target; no role / skill update needed. The dispatch found
that the JS bundle files (`ses_boot.js`, `worker_bootstrap.js`,
`daemon_bootstrap.js`) are not checked into the repo, which means a
builder dispatch into `rust/endo/xsnap` from a fresh checkout needs
to stub them or run the bundler first. The pattern is project-specific
(endo-but-for-bots) and would belong in
`journal/projects/endo-but-for-bots/README.md` or a similar
project-context document, not in a garden role or skill. Surfacing it
in this entry's *CI* note rather than carving a structural lesson.

Self-improvement: nothing this time.
