# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-07-15 06:00 UTC. Links and GitHub state were refreshed from
the API. The sequence distinguishes review-ready work from changes-requested,
conflicting, draft, or actively serviced work._

## Review now

Review these from top to bottom. They have green checks and no outstanding
`CHANGES_REQUESTED` review. `UNKNOWN` mergeability means GitHub had not recomputed
the merge graph at the snapshot; it is called out rather than presented as clean.

1. [`endojs/endo-but-for-bots#259`](https://github.com/endojs/endo-but-for-bots/pull/259)
   — hardened `TextEncoder`/`TextDecoder` shim. `master`, non-draft,
   `MERGEABLE/CLEAN`, 18/18 checks. This is the remaining straightforward M2 shim
   review.

2. [`endojs/endo-but-for-bots#598`](https://github.com/endojs/endo-but-for-bots/pull/598)
   — daemon-to-manager rename, phase 1. `llm`, non-draft, 22/22 checks;
   mergeability currently `UNKNOWN`. Landing it releases the parked phase-2 and
   phase-3 build chain.

3. [`endojs/endo-but-for-bots#694`](https://github.com/endojs/endo-but-for-bots/pull/694)
   — Docker self-hosting with authenticated remote gateway. Non-draft,
   `MERGEABLE/CLEAN`, 23/23 checks. This is the M3 remote self-hosting line.

4. [`endojs/endo-but-for-bots#669`](https://github.com/endojs/endo-but-for-bots/pull/669)
   — Pi-compatible JSONL transcript projection. Non-draft, `MERGEABLE/CLEAN`,
   23/23 checks.

5. [`endojs/endo-but-for-bots#708`](https://github.com/endojs/endo-but-for-bots/pull/708)
   — restore content-address QID/hash in `@endo/exo-git`. Non-draft,
   `MERGEABLE/CLEAN`, 23/23 checks.

6. [`endojs/endo-but-for-bots#656`](https://github.com/endojs/endo-but-for-bots/pull/656)
   — `provideSubMount` primitive. Non-draft, 24/24 checks; mergeability currently
   `UNKNOWN`.

7. [`endojs/endo-but-for-bots#705`](https://github.com/endojs/endo-but-for-bots/pull/705)
   — git remote fetch/pull/push tool. Non-draft, 22/22 checks; mergeability
   currently `UNKNOWN`.

8. [`endojs/endo-but-for-bots#706`](https://github.com/endojs/endo-but-for-bots/pull/706)
   — formula-owned git commit-identity boundary. Non-draft, 24/24 checks;
   mergeability currently `UNKNOWN`. Review before its stacked phase-3 PR
   [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707).

### Separate `master` Docker lane

[`endojs/endo-but-for-bots#608`](https://github.com/endojs/endo-but-for-bots/pull/608)
is the earlier local/headless Docker image: non-draft, `MERGEABLE/CLEAN`, 15/15
checks, but based on frozen `master-eecc683`. Decide whether it still lands on the
`master` lane or is superseded by the remote-gateway line in
[`endojs/endo-but-for-bots#694`](https://github.com/endojs/endo-but-for-bots/pull/694).

## Let active work finish before reviewing

- [`endojs/endo-but-for-bots#682`](https://github.com/endojs/endo-but-for-bots/pull/682)
  — `@endo/reminder` design. A merge job is active; two of five checks were still
  pending at the snapshot.

- [`endojs/endo-but-for-bots#714`](https://github.com/endojs/endo-but-for-bots/pull/714)
  — platform range/tree reads. A review-feedback job is active. It is otherwise
  mergeable with 24/24 checks, but still records `CHANGES_REQUESTED`.

- [`endojs/endo-but-for-bots#719`](https://github.com/endojs/endo-but-for-bots/pull/719)
  — hardened URL vetted shim. A review-feedback job is active. It is otherwise
  `MERGEABLE/CLEAN` with 16/16 checks, but still records `CHANGES_REQUESTED`.
  Prefer this design-faithful `%URL%`/`%SharedURL%` split over the older
  [`endojs/endo-but-for-bots#263`](https://github.com/endojs/endo-but-for-bots/pull/263)
  unless the active fix reveals a reason to reverse that choice.

## Needs engineering before another review

| PR | Current state | Next move |
| --- | --- | --- |
| [`endojs/endo-but-for-bots#594`](https://github.com/endojs/endo-but-for-bots/pull/594) | `CHANGES_REQUESTED`; otherwise `MERGEABLE/CLEAN`, 16/16 | Address review; merge releases `resume-lint-ceiling-shepherds`. |
| [`endojs/endo-but-for-bots#667`](https://github.com/endojs/endo-but-for-bots/pull/667) | `CHANGES_REQUESTED`; 27/27; mergeability `UNKNOWN` | Address review on the stdio JSONL RPC bridge. |
| [`endojs/endo-but-for-bots#670`](https://github.com/endojs/endo-but-for-bots/pull/670) | `CHANGES_REQUESTED`; `MERGEABLE/CLEAN`, 23/23 | Address review on subscription OAuth. |
| [`endojs/endo-but-for-bots#671`](https://github.com/endojs/endo-but-for-bots/pull/671) | `CHANGES_REQUESTED`; 3 failing of 24 | Fix CI and review feedback before re-review. It still gates registry follow-up work. |
| [`endojs/endo-but-for-bots#721`](https://github.com/endojs/endo-but-for-bots/pull/721) | `CHANGES_REQUESTED`; `MERGEABLE/CLEAN`, 23/23 | Address the latest `@endo/reminder` implementation review after design `#682` settles. |
| [`endojs/endo-but-for-bots#695`](https://github.com/endojs/endo-but-for-bots/pull/695) | Draft, `CHANGES_REQUESTED`, 6/6 | Revise the SturdyRef agent-surface design; do not treat it as awaiting first review. |
| [`endojs/endo-but-for-bots#697`](https://github.com/endojs/endo-but-for-bots/pull/697) | Draft, `CHANGES_REQUESTED`, 5/5 | Revise the cross-peer SturdyRef bridge design. |
| [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707) | Non-draft but `CONFLICTING/DIRTY`, 23/23 | Land `#706`, then rebase the stacked worked-loop PR. |
| [`endojs/endo-but-for-bots#713`](https://github.com/endojs/endo-but-for-bots/pull/713) | Green and mergeable, but based on a feature branch | Rebase onto live `llm` before review/merge. |

## Draft designs awaiting an explicit go/no-go

- [`endojs/endo-but-for-bots#676`](https://github.com/endojs/endo-but-for-bots/pull/676)
  — conservative `@endo/regexp` subset. Draft, `MERGEABLE/CLEAN`, 5/5. Acceptance
  releases the parked `build-endo-regexp-conservative-subset` job.

- [`endojs/endo-but-for-bots#715`](https://github.com/endojs/endo-but-for-bots/pull/715)
  — portable `@endo/inspect` package and shim. Draft, 5/5, mergeability currently
  `UNKNOWN`. Acceptance releases the parked `build-endo-inspect` job.

- [`endojs/endo-but-for-bots#662`](https://github.com/endojs/endo-but-for-bots/pull/662)
  — content-locator magnet URNs. Draft with no reported checks; review the design
  before implementation work.

## Newly landed or retired since the prior snapshot

- [`endojs/endo-but-for-bots#722`](https://github.com/endojs/endo-but-for-bots/pull/722)
  **merged** after being revised into split unconfined and confined HTTP plugins.
  Its older implementation draft
  [`endojs/endo-but-for-bots#723`](https://github.com/endojs/endo-but-for-bots/pull/723)
  now needs engineering alignment with the merged design before review.

- [`endojs/endo-but-for-bots#661`](https://github.com/endojs/endo-but-for-bots/pull/661)
  **merged** (confined HTTP client/tool wiring).

- [`endojs/endo-but-for-bots#710`](https://github.com/endojs/endo-but-for-bots/pull/710)
  **merged** (`@endo/cbor` design).

- [`endojs/endo-but-for-bots#658`](https://github.com/endojs/endo-but-for-bots/pull/658)
  **closed**; its follow-up design work is active and it is no longer review work.

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
remains open, non-draft, and mergeable but `UNSTABLE`: 73 of 87 checks succeeded
and two failed. The maintainer decision remains whether the resource-heavy
multichain legs receive larger runners, become non-required on the fork, or get a
dedicated infrastructure-tuning pass.

## Scope

There are 254 open pull requests in `endojs/endo-but-for-bots`. This document is
the curated maintainer sequence for current milestone work and garden-unblocking
edges, not an assertion that the remaining long tail is review-ready.
