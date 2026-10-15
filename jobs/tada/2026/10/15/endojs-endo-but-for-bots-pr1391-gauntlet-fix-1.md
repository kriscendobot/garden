# Fix round 1 for endojs/endo-but-for-bots #1391: pushed, CI green

I applied panel-1's must-fix items as follow-up commits and pushed them to `build/sturdyref-ses-accommodation` with `safe-push-pr-head.sh`. The head moved from `282679dda` to `a10a201e32e`. CI is green on that head: 35 checks, 0 failed.

The first CI run went red on lint. Prettier flagged `_parcel-xs-smoke.js`, which my `c` → `compartment` rename had broken. I pushed a formatting-only commit and ran CI again. The bounded 3600s wait ran out with one macOS test still pending, so I kept polling until that check passed and then confirmed green with `ci-wait-merge.sh`.

## What changed
- **Proxy can leak `locate` as `Parcel.open`** (warden, saboteur, breaker, spec-keeper): `sampleParcel` now returns the `open`, `isParcel` and `prototype` values it checked by descriptor. `tameParcelConstructor` uses only those values and never reads the candidate again. A new test, `parcel-proxy-open.test.js`, covers a Proxy whose `get` returns `locate` for `open`.
- **Wrong `sampleParcel` contract and unused plumbing** (typist, archivist, purist): removed the unused `presampled` path into the intrinsics collector, and gave `sampleParcel` a correct, typed return value.
- **Over-long comments** (pruner): shortened the `sampleParcel` doc comment and the comments in `global-object.js`.
- **One-letter name** (stylist): renamed `c` to `compartment` in the remaining file. The other flagged file was deleted under the prover item.
- **Tests that pass without this PR** (prover): removed `parcel-absent.test.js`, `global-locked-universal.test.js` and the `_json-locked-first.js` fixture.
- **Single-case test** (fast-checker): added `@fast-check/ava` to SES's dev dependencies, plus a property test that creates many parcels at different locations and checks each one. `yarn.lock` is updated in its own commit.
- **Changeset** (packager, curator, migrator, changeset-auditor, releaser): rewrote it one sentence per line. It now says that `lockdown` rejects any existing `globalThis.Parcel` that is not the `@endo/parcel` constructor, and tells users how to upgrade.
- **README** (archivist): added the Parcel behavior under lockdown to `packages/ses/README.md`.

Locally, the full SES suite passed (417 tests, 1 known failure), and eslint and tsc found no errors. I could not run the XS tests here because this host's `xst` binary is broken, so CI covered them.

## Not done in this round
- **Migrator's request to coordinate the dependent releases:** not changed. The changesets config (`updateInternalDependencies: patch`) rewrites `@endo/lockdown`'s `ses` range to SES 3.x at release time. Adding an SES peer requirement to `@endo/parcel` would change a package that belongs to the base PR. Panel-2 may raise this again.
- **Integrator's request to reword earlier commit subjects:** this needs a history rewrite, so it is left for a retcon.
- **Corner-prober's extra test fixtures:** these were optional suggestions and are not added.
- **Summary comment on the PR:** posting it failed with a 403, because this host's bot token cannot write to endojs PRs. The intended text listed the items above.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (4399809 cached reads)
- Output: 22083 tokens
- Cost: $2.1468778
- Wall-clock: 6632s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
