# PR-review sequence — `endojs/endo-but-for-bots`

_Live snapshot: 2026-07-16 16:47 UTC. Links and GitHub state were refreshed from
the API. The sequence distinguishes review-ready work from changes-requested,
conflicting, draft, or actively serviced work. Mergeability is now reported
concretely for every PR — the `UNKNOWN` placeholders from the prior snapshot have
all recomputed._

## Review now

Review these from top to bottom. They are non-draft, `MERGEABLE/CLEAN` with all
checks green, and carry no outstanding `CHANGES_REQUESTED` review.

1. [`endojs/endo-but-for-bots#259`](https://github.com/endojs/endo-but-for-bots/pull/259)
   — hardened `TextEncoder`/`TextDecoder` shim. `master`, non-draft,
   `MERGEABLE/CLEAN`, 18/18 checks. This is the remaining straightforward M2 shim
   review.

2. [`endojs/endo-but-for-bots#694`](https://github.com/endojs/endo-but-for-bots/pull/694)
   — Docker self-hosting with authenticated remote gateway. Non-draft,
   `MERGEABLE/CLEAN`, 23/23 checks. This is the M3 remote self-hosting line.

3. [`endojs/endo-but-for-bots#669`](https://github.com/endojs/endo-but-for-bots/pull/669)
   — Pi-compatible JSONL transcript projection. Non-draft, `MERGEABLE/CLEAN`,
   23/23 checks.

4. [`endojs/endo-but-for-bots#708`](https://github.com/endojs/endo-but-for-bots/pull/708)
   — restore content-address QID/hash in `@endo/exo-git`. Non-draft,
   `MERGEABLE/CLEAN`, 23/23 checks. (Related plumbing landed meanwhile in `#734`,
   exo-git credential/ref-update typing — re-confirm no overlap before merge.)

5. [`endojs/endo-but-for-bots#656`](https://github.com/endojs/endo-but-for-bots/pull/656)
   — `provideSubMount` primitive. Non-draft, `MERGEABLE/CLEAN`, 24/24 checks.
   (Mergeability recomputed to `CLEAN` since the prior snapshot.)

6. [`endojs/endo-but-for-bots#705`](https://github.com/endojs/endo-but-for-bots/pull/705)
   — git remote fetch/pull/push tool. Non-draft, `MERGEABLE/CLEAN`, 22/22 checks.
   (Recomputed to `CLEAN`.)

7. [`endojs/endo-but-for-bots#706`](https://github.com/endojs/endo-but-for-bots/pull/706)
   — formula-owned git commit-identity boundary. Non-draft, `MERGEABLE/CLEAN`,
   25/25 checks. (Recomputed to `CLEAN`.) Review before its stacked phase-3 PR
   [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707).

> Moved out since the prior snapshot: `#598` (daemon→manager rename phase 1) has
> gone `CONFLICTING/DIRTY` and now carries `CHANGES_REQUESTED` — see _Needs
> engineering_.

### Separate `master` Docker lane

[`endojs/endo-but-for-bots#608`](https://github.com/endojs/endo-but-for-bots/pull/608)
is the earlier local/headless Docker image: non-draft, `MERGEABLE/CLEAN`, 15/15
checks, but based on frozen `master-eecc683`. Decide whether it still lands on the
`master` lane or is superseded by the remote-gateway line in
[`endojs/endo-but-for-bots#694`](https://github.com/endojs/endo-but-for-bots/pull/694).

## Let active work finish before reviewing

No PRs are currently held by an in-flight job — the job board (`jobs/todo`,
`jobs/doin`) is idle at this snapshot. The three PRs parked here last time have
moved on: `#682` **merged**, and `#714` / `#719` now need engineering (their
review-feedback jobs completed without clearing `CHANGES_REQUESTED`) — see below.

## Needs engineering before another review

| PR | Current state | Next move |
| --- | --- | --- |
| [`endojs/endo-but-for-bots#598`](https://github.com/endojs/endo-but-for-bots/pull/598) | `CHANGES_REQUESTED`; `CONFLICTING/DIRTY`; 23/23 checks | Rebase onto live `llm` and address review. Landing releases the parked phase-2 and phase-3 rename build chain (`build-daemon-rename-to-manager-phase2`/`-phase3`). |
| [`endojs/endo-but-for-bots#594`](https://github.com/endojs/endo-but-for-bots/pull/594) | `CHANGES_REQUESTED`; otherwise `MERGEABLE/CLEAN`, 16/16 | Address review; merge releases `resume-lint-ceiling-shepherds`. |
| [`endojs/endo-but-for-bots#667`](https://github.com/endojs/endo-but-for-bots/pull/667) | `CHANGES_REQUESTED`; `MERGEABLE/BLOCKED`, 27/27 | Address review on the stdio JSONL RPC bridge (blocked only on an approving review). |
| [`endojs/endo-but-for-bots#670`](https://github.com/endojs/endo-but-for-bots/pull/670) | `CHANGES_REQUESTED`; `MERGEABLE/CLEAN`, 23/23 | Address review on subscription OAuth. |
| [`endojs/endo-but-for-bots#671`](https://github.com/endojs/endo-but-for-bots/pull/671) | `CHANGES_REQUESTED`; `CONFLICTING/DIRTY`; 3 failing of 24 | Rebase, fix CI, and address review. It still gates registry follow-up work (`registry-immutable-byte-array-followup`). |
| [`endojs/endo-but-for-bots#707`](https://github.com/endojs/endo-but-for-bots/pull/707) | Non-draft, `MERGEABLE/UNSTABLE`, 3 failing of 24 | No longer conflicting. Land `#706`, then rebase the stacked worked-loop PR onto `llm` and fix the failing checks. |
| [`endojs/endo-but-for-bots#713`](https://github.com/endojs/endo-but-for-bots/pull/713) | `MERGEABLE/CLEAN`, 23/23, but based on feature branch `feat/mount-glob-delegated` | Rebase onto live `llm` before review/merge. |
| [`endojs/endo-but-for-bots#714`](https://github.com/endojs/endo-but-for-bots/pull/714) | `CHANGES_REQUESTED`; `CONFLICTING/DIRTY`; 24/24 checks | Rebase onto `llm` and address review on the platform range/tree reads. |
| [`endojs/endo-but-for-bots#719`](https://github.com/endojs/endo-but-for-bots/pull/719) | `CHANGES_REQUESTED`; otherwise `MERGEABLE/CLEAN`, 18/18 | Address review on the hardened URL vetted shim. Prefer this design-faithful `%URL%`/`%SharedURL%` split over the older `#263`. |
| [`endojs/endo-but-for-bots#721`](https://github.com/endojs/endo-but-for-bots/pull/721) | `CHANGES_REQUESTED`; `MERGEABLE/CLEAN`, 23/23 | Its `@endo/reminder` design `#682` has now **merged**, so the "after design settles" hold is lifted — address the implementation review. |
| [`endojs/endo-but-for-bots#263`](https://github.com/endojs/endo-but-for-bots/pull/263) | `MERGEABLE/UNSTABLE`, 1 failing of 16; no review | Older hardened-URL shim, superseded by `#719`. Close in favor of `#719`, or fix the failing check only if `#719` is abandoned. |
| [`endojs/endo-but-for-bots#695`](https://github.com/endojs/endo-but-for-bots/pull/695) | Draft, `CHANGES_REQUESTED`, `MERGEABLE/BLOCKED`, 6/6 | Revise the SturdyRef agent-surface design; do not treat it as awaiting first review. |
| [`endojs/endo-but-for-bots#697`](https://github.com/endojs/endo-but-for-bots/pull/697) | Draft, `CHANGES_REQUESTED`, `MERGEABLE/BLOCKED`, 5/5 | Revise the cross-peer SturdyRef bridge design. |
| [`endojs/endo-but-for-bots#723`](https://github.com/endojs/endo-but-for-bots/pull/723) | Draft, `CONFLICTING/DIRTY`, no reported checks | Align with the merged split-plugin design `#722`, then rebase before review. |

## Draft designs awaiting an explicit go/no-go

- [`endojs/endo-but-for-bots#676`](https://github.com/endojs/endo-but-for-bots/pull/676)
  — conservative `@endo/regexp` subset. Draft, now `CONFLICTING/DIRTY` (rebase
  needed), no reported checks. Acceptance releases the parked
  `build-endo-regexp-conservative-subset` job.

- [`endojs/endo-but-for-bots#715`](https://github.com/endojs/endo-but-for-bots/pull/715)
  — portable `@endo/inspect` package and shim. Draft, `CONFLICTING/DIRTY` (rebase
  needed), 5/5 checks. Acceptance releases the parked `build-endo-inspect` job.

- [`endojs/endo-but-for-bots#662`](https://github.com/endojs/endo-but-for-bots/pull/662)
  — content-locator magnet URNs. Draft, `CONFLICTING/DIRTY`, no reported checks;
  review the design before implementation work.

## Newly landed or retired since the prior snapshot (2026-07-15 06:00)

- [`endojs/endo-but-for-bots#682`](https://github.com/endojs/endo-but-for-bots/pull/682)
  **merged** (`@endo/reminder` message-scheduler design, supersedes the
  endoclaw-timer line). This unblocks implementation PR `#721` for review.

- Broader landings in the same window touch the mount/git surface the _Review
  now_ line depends on: `#643` (consolidate mount + Git capability contracts),
  `#734` (`@endo/exo-git` credential/ref-update typing), plus agentry/exo-stream
  containment fixes `#687`, `#728`, `#744`, `#745`. Re-confirm none has
  invalidated `#705`/`#706`/`#708`/`#713` before merging those.

- Already merged/closed in the prior window and now fully retired from the
  sequence: `#722`, `#661`, `#710` (merged) and `#658` (closed).

## External fork decision

[`kriscendobot/agoric-sdk#17`](https://github.com/kriscendobot/agoric-sdk/pull/17)
remains open, non-draft, and mergeable but `UNSTABLE`: 73 of 87 checks succeeded
and two failed. The maintainer decision remains whether the resource-heavy
multichain legs receive larger runners, become non-required on the fork, or get a
dedicated infrastructure-tuning pass.

## Scope

There are 253 open pull requests in `endojs/endo-but-for-bots`. This document is
the curated maintainer sequence for current milestone work and garden-unblocking
edges, not an assertion that the remaining long tail is review-ready.
