---
created: 2026-09-28
updated: 2026-09-29
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

## Foreman press and controls

Run these from a garden development checkout containing the landed scripts.
The helpers use their own journal clones and CAS pushes; do not edit or run git
in the deployed root or its journal worktree.
Only arm after the press, budget, claim, and handler tests have passed and the
leader has deployed this revision. The old `ironhorse-ratchet` schedule is
retired and the scheduler refuses to dispatch it even if a stale journal row
survives. Do not restore or unsnooze it.

```sh
scripts/jobs/ironhorse-ratchet.sh seed
scripts/jobs/set-arc-budget.sh ironhorse-test262-ratchet \
  <token-cap> <rolling-window-seconds> <press-interval-seconds>
scripts/jobs/seed-ironhorse-press.sh [not-before-ISO-UTC]
```

The maintainer chooses all three numbers. The proposed press interval is six
hours (`21600`). No default token cap exists: a missing, inactive, or malformed
`config/arc-budgets/ironhorse-test262-ratchet` makes the foreman leave the press
parked. Spend is derived on every admission from `usage/*.jsonl` rows stamped
`arc: ironhorse-test262-ratchet`; it sums input, output, and cache-creation tokens
inside the rolling window and never updates a mutable counter. An unmetered or
malformed matching row also fails closed until it leaves the window.
`seed-ironhorse-press.sh` is idempotent against any live canonical press. It may
be used before the budget is chosen: the missing budget then keeps that first
engagement parked rather than inventing a cap.

Every completed arc engagement atomically parks exactly one
`ironhorse-test262-press-<UTC stamp>` deferred successor. It carries
`not_before: completion + press_interval_seconds` and `foreman_only: true`.
Existing live press work in `plan/`, `todo/`, or `doin/` suppresses duplicates.
Only the foreman's deferred selector may promote it, and that selector rechecks
both `not_before` and the rolling arc budget in the promotion CAS. Completion
parks no successor when the delegation is paused, halted, or revoked.

Pause admission, staged gauntlet advancement, and delegated merges:

```sh
scripts/jobs/ironhorse-ratchet.sh pause
```

After a maintainer resolves the recorded blocker, resume the delegation. A live
successor remains parked until its press time and budget both permit promotion:

```sh
scripts/jobs/ironhorse-ratchet.sh resume
```

Revoke permanently (write the maintainer's reason/reference to a file first):

```sh
scripts/jobs/ironhorse-ratchet.sh revoke /path/to/revocation-reason.txt
```

`seed` never replaces an existing record or removes a revocation.
Reauthorization after revocation requires a new reviewed authorization/change;
`resume` refuses a tombstone. A paused, halted, or revoked arc parks no new
successor, and queued watcher/arc children cannot be claimed or served. Already
running workers must recheck before
mutations; revocation does not kill an operating-system process. The merge spine
always fetches the journal again immediately before its head-matched merge.
It never queues delegated auto-merge for a future, potentially revoked moment.

The foreman-promoted press successor is the only automatic mentat producer. It
carries the tracked canonical watcher task and emits no fallback tier or concrete
provider pin. Claim and both native handlers require that exact task, the
`ironhorse-test262-press-<UTC stamp>` basename, the arc marker, and an active
record. Other automatic producers retain the mentor/minion route.

## One step per tick

Each foreman-woken mentat watcher calls `scripts/jobs/ironhorse-ratchet.sh step` once.
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
