---
ts: 2026-06-02T05:13:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/06/02/050200Z-dispatch-steward-79db55.md
  - entries/2026/06/02/051245Z-result-designer-79db55.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
---

# result: designer chain on #358 — monolithic design decomposed into 4 layered designs

The designer chain to honor kriskowal's CHANGES_REQUESTED directive on
#358 (decompose into Registry capability / MVS resolver / JS-snapshot →
compartment-map-snapshot mapper / Integration) completed cleanly.

## Designer outcome (result `79db55`)

- **Five commits atop `e72b355ff`** (head `0257affa7`):
  1. `3238894b5` — `design(registry-capability): split EndoRegistry
     capability shape out of daemon-worker-import design` (+445).
     New `designs/registry-capability.md`.
  2. `139d789be` — `design(mvs-resolver): split MVS resolution algorithm
     out of daemon-worker-import design` (+342).
     New `designs/mvs-resolver.md`.
  3. `ae3ed01e0` — `design(snapshot-mapper): split JS-snapshot →
     compartment-map-snapshot mapper out of daemon-worker-import design`
     (+392). New `designs/snapshot-mapper.md`.
  4. `d70215728` — `design(daemon-worker-import-integration): restructure
     as integration layer over registry/MVS/mapper` (−853/+355).
     Repurposed the existing
     `designs/daemon-worker-import-from-mount.md` (now 666 lines).
  5. `0257affa7` — `design(README): index new layered designs`. Updated
     `designs/README.md` summary table, M1 milestone rows, per-design
     estimates, dependency-graph nodes `dwicap`/`dwimvs`/`dwisnap` with
     edges. Totals: Proposed 21→24, total 126→129, M1 items 11→14,
     remaining 49→52.
- **Choice on the original file**: option (c) per the dispatch — repurpose
  as integration layer. Preserves PR branch slug, README dependency-graph
  node id (`dwimp`), and external cross-references. The three new layers
  carry hyphenated slugs that sort cleanly.
- **Section-to-layer mapping** (highlights):
  - **registry-capability**: capability shape interface, failure surface,
    `@registry` slot, snapshot-vs-live-read contract, host migration.
  - **mvs-resolver**: MVS algorithm, eager single-pass resolution path,
    lockfile out-of-scope stance.
  - **snapshot-mapper**: `mapSnapshot` + `makeMountReadPowers` +
    `endo-mount:` URL scheme + npm↔compartment-map translation.
  - **integration**: `makeFromPackage` + `makeFromMount` + worker
    dispatch body + CLI + XS bridging + architecture diagram.
- **Open questions surfaced** (none blocking; flagged for maintainer):
  - Whether host API doc should pitch `makeFromMount` as primary,
    treating `makeFromPackage` / `makeFromTree` as advanced.
  - Shape of `compartment-mapper` extension point that `mapSnapshot`
    reuses (left as implementation detail; maintainer can pre-shape).
  - Sequencing of per-layer phases (layered view may prefer different
    ordering than monolithic).
  - Resolver-vs-store capability split (now scoped to `registry-capability`;
    lands cleanly there if maintainer wants the split now).

## Steward post-designer actions

- Review thread NOT resolved (the original review's body is the directive
  to decompose; the decomposition either satisfies or doesn't satisfy
  per maintainer judgment — they'll re-review and resolve).

## Net effect on #358

PR #358 now has 5 new commits atop `e72b355ff`. PR remains non-draft (per
dispatch). reviewDecision still CHANGES_REQUESTED (sticky until next
review). Awaits maintainer re-review of the layered shape.

## Cleanup

`dispatches/designer--79db55` torn down.

## Adjacent queue churn observed

- **#343** kriskowal reviewing in real-time (multiple
  PullRequestReviewCommentEvents 05:01–05:06, then
  PullRequestReviewEvent created+updated at 05:06:57). REMOVE from review
  queue at 05:09. Need to check the submitted review state next.
- **#244** reopened at 05:08 with a new commit
  `chore(eslint-plugin): require underscore-delimited groups in numeric
  literals` and IssueCommentEvent. Previously CLOSED; now back open.
  Needs queue tracking.
- **#358 REMOVE** at 05:00:58 (just after the CHANGES_REQUESTED — the
  reviewer's pending-review set clears once they submit).

## Next

- Inspect #343 review (likely new CHANGES_REQUESTED or APPROVED).
- Inspect #244 reopen reason and decide engagement.

## Steward queue post-engagement

- **#358** decomposed into 4 layers; awaiting maintainer re-review.
- **#379** parity infrastructure landed; awaiting re-review.
- **#390** rename PR APPROVED + un-drafted; awaiting kumavis/0xpatrickdev.
- **#387** fixer landed; CI green; DRAFT; awaiting re-review.
- **#382, #345** MERGED.
- **#388, #389, #392, #393, #394** kriscendobot gateway-stack DRAFTs.
- **#244** REOPENED; needs assessment.
- **#343** review in flight; needs check.
- **#377** awaiting kriskowal reply.
- **#357** APPROVED, UNSTABLE.
- **#335, #329, #231, #138, #241, #320, #79** unchanged.
- **kriskowal/garden#3** CHANGES_REQUESTED on both reviews; awaits user
  alignment on systemd/scripts-vs-roles redesign.
- **kriskowal/garden** `skills/node-parity-test/SKILL.md` landed on main
  per gardener's pickup of the parity-test concept message.
