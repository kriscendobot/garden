---
created: 2026-09-28
updated: 2026-09-28
author: gardener
---

# Ironhorse test262 ratchet autopilot

The maintainer delegated one crank at a time for
[the Ironhorse tracker](https://github.com/kriscendobot/garden/issues/51),
solely on `endojs/endo-but-for-bots`, live base `llm`, authored by
`kriscendobot`, with this PR-body line:

```text
<!-- garden-arc: ironhorse-test262-ratchet -->
```

The authorization is journal2
`entries/2026/09/28/201230Z-message-gardener-aa49da.md`.
The JSON record `config/delegations/ironhorse-test262-ratchet` binds its
SHA-256, author, repository, base, marker, and active/paused/revoked status.
`config/delegations/ironhorse-test262-ratchet.revoked` is a permanent tombstone.
A missing, unreadable, changed, paused, or revoked record denies the delegation.
Journal push access is the existing authority boundary; a PR body cannot grant it.
A maintainer revocation message must be applied with the revoke command below.

## Schedule and controls

Run these from a garden development checkout containing the landed scripts.
The helpers use their own journal clones and CAS pushes; do not edit or run git
in the deployed root or its journal worktree.
Only arm after the delegated merge and watcher tests have passed and landed.
The deployed scheduler/claim/handler code must contain this change; older
schedulers cannot grant the exception. During rollout, use `snooze-schedule.sh`
to defer the first fire until the leader has deployed this revision; an old
scheduler would normalize the task to mentor, which the watcher refuses.

```sh
scripts/jobs/ironhorse-ratchet.sh seed
GARDEN_SCHEDULE_OCCUPANCY=skip scripts/jobs/set-schedule.sh \
  ironhorse-ratchet 2h ironhorse-ratchet-watch scripts/jobs/ratchet/watcher.md
```

Pause admission, staged gauntlet advancement, and delegated merges:

```sh
scripts/jobs/ironhorse-ratchet.sh pause
```

After a maintainer resolves the recorded blocker, resume the same schedule:

```sh
scripts/jobs/ironhorse-ratchet.sh resume
```

Revoke permanently (write the maintainer's reason/reference to a file first):

```sh
scripts/jobs/ironhorse-ratchet.sh revoke /path/to/revocation-reason.txt
```

`seed` never replaces an existing record or removes a revocation.
Reauthorization after revocation requires a new reviewed authorization/change;
`resume` refuses a tombstone. A paused/revoked schedule may remain registered:
the scheduler's mandatory gate posts nothing, and queued watcher/arc children
cannot be claimed or served. Already running workers must recheck before
mutations; revocation does not kill an operating-system process. The merge spine
always fetches the journal again immediately before its head-matched merge.
It never queues delegated auto-merge for a future, potentially revoked moment.

The schedule is the only automatic mentat producer. It substitutes the tracked
canonical watcher task for the schedule body, preserves budget admission and
occupancy, and emits no fallback tier or concrete provider pin. Claim and both
native handlers require that exact task, its date/time basename, and an active
record. Other automatic producers retain the mentor/minion route.

## One step per tick

The mentat watcher calls `scripts/jobs/ironhorse-ratchet.sh step` once.
The durable state is `ratchets/ironhorse-test262-ratchet/state.json`.
The driver waits for existing children, then performs one transition:

- With no open PR, post one builder for the highest-count refined
  `ironhorse-aborted:*` reason from the previous head's complete report.
  A builder owns one cluster, its oracle dual-run regressions, and a refreshed
  `baseline/refresh-<date>/` floor. Never adopt a newer directory by date alone.
- For a draft or a changed head, post the full staged gauntlet. CI red posts a
  shepherd. A live builder, shepherd, conductor, or gauntlet is observed without
  posting overlapping work.
- With a completed gauntlet, a passed panel on the exact head, and settled green
  CI, request independent verification by the mentat. A successful `attest`
  commits evidence before posting a conductor. A crash between those operations
  is recovered by the next tick.
- After a confirmed merge, post a marker-deduplicated tracker comment, promote
  only the attested refreshed floor, and retain the report's ranked queue.
  The following tick starts the next crank from the then-current `llm`.

Action identities include PR/head (or crank) and a persistent date suffix;
repeated ticks and CAS retries reuse them. A failed terminal child is not silently
reposted under tomorrow's name. Two distinct ticks observing failed criteria
pause the delegation and notify the maintainer inbox. Twenty-four hours without
an observed transition also pauses it. Multiple open crank PRs, a closed/unmerged
crank, a maintainer veto, or an effective dismissal halt immediately.

The initial subject is [draft PR 1359](https://github.com/endojs/endo-but-for-bots/pull/1359),
produced by `ironhorse-test262-ratchet-round3-20260928`, with branch point
`47f6965d882b9c1c3eaaa836dd8d75971a924bb4`.
Its seed floor remains `refresh-20260904` (30,233 cases), plus every covered
branch-point case. Its historical losses, frozen PR base, and uninstrumented
new-code evidence currently prevent delegated merging. The named floor-resolution
successor owns resolution with the maintainer; this autopilot does not reinterpret
those failures as authorization to lower the floor.

## Independent verification

Follow the [evidence contract](ironhorse-ratchet-evidence.md) to re-derive the
covered set, enforce the pinned comparator, measure new-code coverage, and
archive the exact-head gauntlet and mentat attestation. Missing measurements or
incompatible classifications block merging; neither permits lowering the floor.
