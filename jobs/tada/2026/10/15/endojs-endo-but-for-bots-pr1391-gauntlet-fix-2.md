# PR #1391 fix round 2: panel fixes pushed, CI green

I applied the round-2 panel's must-fix items as five follow-up commits on top of the old head `a10a201e32`, pushed with `safe-push-pr-head.sh`. CI is green on the new head `17390624a32` (35 checks, 0 failed; `ci-wait-merge` returned 0). I did not post the summary comment on the PR: the bot token on this host gets a 403 when commenting on endojs PRs. The text is saved at `/Users/dom/garden/scratch/p1391-summary.md`, but that file is outside any commit, so take it from the lists below if it is gone. The summary file still says head `1758079df5`; update that to `17390624a32` before posting it.

## Commits
- **`9303a1676` `fix(ses)`: require a constructible Parcel with a distinct `locate`** (spec-keeper, locksmith, purist, prover, typist, corner-prober, fast-checker).
  - `sampleParcel` now rejects a candidate that can't be called with `new`. It also rejects one whose `open` or `isParcel` is the same function as `locate`, which covers purist's Proxy descriptor-trap variant too.
  - The error message now says "compatible Parcel constructor" instead of naming `@endo/parcel`.
  - The `ParcelSample` type moved to its own types file and is pulled in with `@import`; the `open`/`isParcel` return types are widened to `unknown`.
  - New tests: four rejection fixtures (no `locate`, an arrow function with a locked `prototype`, `open` aliased to `locate`, and a throwing getter on a static that must never run) and a fast-check property that calls `sampleParcel` directly over every combination of `open`/`locate`/`isParcel` shapes.
- **`b1aed3b8b` `fix(ses)`: re-lock a start Parcel deleted during sampling** (breaker #2). If the start compartment's `Parcel` binding disappears while lockdown samples it, lockdown now restores it locked. Child compartments still get the ordinary binding.
- **`10f8620a7` `docs(ses)`: README and changeset** (assessor, curator, migrator, integrator, archivist, wire-watcher, saboteur). They now say lockdown recognizes `Parcel` by shape, not by where it came from. It applies only to an own data property, and SES trusts it like any other code that runs before lockdown.
- **`1758079df` `test(ses)`** (engine-realist, stylist). The XS smoke test now builds a parcel through the shared constructor and checks the brand, `locate`, `open`, and that `new.target` reaches the initial constructor. The fast-check import is renamed from `fc` to `fastCheck`.
- **`17390624a` `fix(ses)`: rename the types file to `parcel.types.d.ts`**. The first CI lint run failed the repository's package uniformity check, which requires tracked declaration files to use the `*.types.d.ts` naming.

## Declined or deferred
- **warden and breaker #1 (a Proxy whose `construct` trap leaks the privileged constructor); wire-watcher and saboteur (an `open` that closes over authority):** declined. SES cannot authenticate code that runs before lockdown, because that same code could forge any handshake. The accepted design (#1389) calls for checking the shape only, so I documented that trust limit instead.
- **decomplector (remove the SES-wide Parcel support):** declined because it contradicts the accepted design in #1389. The maintainer should decide.
- **integrator should-fixes:** not done. An integration test using the real shim under `packages/parcel` is left as a follow-up. Regrouping the commit history is for the retcon before merge.

## Verification
- **Focused tests:** the 26 `packages/ses` Parcel tests pass. I ran the five new rejection and re-lock tests against the old source and all five failed, so they do catch the change.
- **Type checks and lint:** `tsc` passes for the package and for the root program. eslint is clean apart from older warnings, and the package uniformity check passes.
- **XS:** `xst` is broken on this host, so I ran the same smoke-test sequence on Node against the built bundle and it passed. CI's XS run is the real test for that engine.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 130 tokens (7284512 cached reads)
- Output: 34559 tokens
- Cost: $3.1809784
- Wall-clock: 5863s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
