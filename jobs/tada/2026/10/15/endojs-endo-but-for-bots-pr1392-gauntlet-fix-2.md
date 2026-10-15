PR #1392 fix round 2 is done: I pushed one follow-up commit (`65391dffb`) and CI on that exact head is green (35 of 35 checks, none failed).

**Most of panel-2's must-fix items were already fixed before I started.** Review 5531318636 was posted at 09:56Z. Force-pushes at 10:24Z and 12:16Z (the second from the restack job running on endolin) had already dealt with nearly all of it:
- **Changesets:** now a single changeset with a major `@endo/pass-style` bump. The release note says Parcel recognition is local only and that a Parcel is never a key or pattern. The lockfile commit is now `chore: Update yarn.lock`.
- **Types:**
  - The `Passable` docs now separate "passable" from "marshalable".
  - `PassByRef`, `PureData`, `toThrowable`, `Key`, `Pattern` and `Matcher` exclude `ParcelObject`, at any nesting depth, with negative type tests.
  - `TFKindMap` maps `'parcel'` to `ParcelObject`.
- **Reading the global:** `globalThis.Parcel` is now read through its own data descriptor, so a hostile getter is never run.
- **Skipped tests:** the trust-boundary tests the prover found skipped in every mode were replaced by `parcel-pre-shim.test.js`. It runs 20 scenarios, each in a fresh Node process, so they actually execute.
- **Other items:**
  - A test now pins the one-element `[parcel]` rank case.
  - The README names `@endo/parcel/shim.js` as what turns recognition on.

**What I changed:**
- **README:** commit `65391dffb` adds one sentence under "Pass-by-reference" in `packages/pass-style/README.md`. It says a Parcel cannot yet cross a marshal boundary, which answers the saboteur. I pushed it with `safe-push-pr-head.sh` in advance mode, on top of `a2a578525`.
- **PR body:** the Security Considerations section still claimed that passing a Parcel gives the receiver authority to open it. This host's bot token gets a 403 when writing to endojs PRs, so I couldn't edit it from here. I posted job `endojs-endo-but-for-bots-pr1392-fix2-body-summary`, pinned to `endolin-garden-ece02cb4`, which will:
  - replace that paragraph in the PR body;
  - post the fix-2 summary comment the scribe asked for, listing what was fixed and what was declined.

**Declined or deferred** (the reasons are in that summary comment):
- **Narrowing marshal's `toCapData` parameter so it excludes Parcels** (curator): declined. It would stop every caller that holds a generic `Passable` from type-checking anywhere in the monorepo.
- **XS test coverage:** deferred. `marshal`'s `test:xs` is `exit 0` and pass-style and patterns have no XS harness, which the PR body already says.
- **Using the `@endo/parcel` `makeParcel` helper in tests, and adding fast-check properties:** both were should-fix or summary-fix, and I left them for a follow-up.

**Coordination:** the endolin restack job, `endojs-endo-but-for-bots-pr1392-parcel-restack-20261015-r5527149922-expanded-window`, is still running on this PR. I told it about the new head, that I'm not pushing again, and that CI on `65391dffb` is green. It has acknowledged and will post its own restack summary.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1392-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 68 tokens (2523792 cached reads)
- Output: 13275 tokens
- Cost: $1.4258983999999997
- Wall-clock: 3327s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
