# Gauntlet fix round 3: endojs/endo-but-for-bots#1343

I applied the round-3 panel's must-fix items and the related should-fix items, then regrouped the branch history. The new head is `166b9f15b`, and CI is green on it (26/26). The first CI run had one red job, `test (22.x, ubuntu-latest)`. It failed on a "Termination requested" unhandled rejection in `endo.test.js`, during the `readLog` follow tests and outside the changed code. I re-ran that job once and it passed.

## Fixes

- **locksmith (must-fix): a handle name gave write access to another guest's pet store.** `makeGuest` in `host.js` can find an existing guest only by its handle name. In that case it now endows the guest only if the guest's formula is a `guest` whose `hostAgent` is this host. Otherwise it fails with "not a guest of this host". A new test has a sibling host that holds another host's guest handle and is refused.
- **breaker (must-fix): special endowment IDs were not pinned between resolution and guest creation.** `formulateGuestDependencies` in `manager.js` now pins each special ID first. It then rechecks it under the formula graph lock: the ID must still exist, and `@main` must still be a worker. If a check fails it unpins and throws `ENDO_SPECIAL_NAME_SOURCE_UNAVAILABLE`.
- **decomplector: `@main` was stored in two places.** An endowed `@main` now goes straight into the guest formula's `worker` slot, and no default worker is created. `specialNames` holds only names the daemon doesn't bind itself. This removed the `@main` exception in `guest.js`, which now treats every daemon-bound name the same way and also blocks `@mail` when the guest has no mail hub. This changes the formula shape before release, so no migration is needed. The `special:@main` edge test now expects a `worker` edge.
- **Retained record trusted stale or forged special IDs** (raised by breaker, wire-watcher and assessor). The retained policy record no longer stores special identifiers. Special names are resolved only when a guest is actually created. If a record outlived a failed or interrupted creation (the record exists but the guest doesn't), they are resolved again. A new test covers a forged record, a missing source, and recovery after the source is re-bound.
- **integrator: old intermediate name.** Renamed `introducedSpecialNames` to `specialEndowments` in `guest.js`, `manager.js` and `types.d.ts`. I also undid the unrelated `→`/`->` rewrite in `help.md` and `help-text-data.js`.
- **pruner and packager: changeset.** The changeset is condensed and points to the README for the full rules. `@endo/agentry` is now a `minor` bump. The README and changeset now say that an endowed `@main` worker is shared with anyone else who holds that worker.
- **packager and integrator (must-fix): `fixup!` commits and inconsistent breaking markers.** I squashed the 14-commit series into 4 commits:
  - `feat(daemon)!: endow guests through one @-partitioned endowments map`
  - `refactor: provision guests through endowments in daemon callers`
  - `test(daemon): cover guest endowments`
  - `docs: document guest endowments and add a changeset`

  I checked that the final tree is identical to the pre-squash work, then pushed with `safe-push-pr-head.sh --mode rewrite` (`d2cf543e4` → `166b9f15b`).
- I updated the PR body to match: how `@main` is handled now, the handle-ownership check, the new tests, and the agentry bump.

## Local checks
- `provision-lifecycle.test.js`: 13/13 pass, including the 2 new tests.
- The daemon type check (`tsc`) is clean, and eslint reports 0 errors.
- These ran on Node 22, because this worktree's `better-sqlite3` was built for Node 24. I swapped in a Node 22 build for the run and restored the original afterwards.
- The full daemon suite doesn't work in this environment: the channel tests fail or hang. CI covers it, and CI is green.

## Not addressed (should-fix or comment-only)
- assessor: reconnecting a retained guest with an endowments map that leaves out its special entries is still rejected.
- typist: the `endowments` type is still `string[]` rather than `NamePath`.
- A residual race: if an unprovisioned guest of the same name appears while a retained guest is being created for the first time, that creation fails, and a retry can then reuse that guest without its special names.
- A follow-up to give `provideHost` and agentry the same `endowments` shape.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1343-gauntlet-20261007-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 144 tokens (8962208 cached reads)
- Output: 35699 tokens
- Cost: $3.7362616000000015
- Wall-clock: 5166s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
