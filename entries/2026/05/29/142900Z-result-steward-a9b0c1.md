---
ts: 2026-05-29T14:29:00Z
kind: result
role: steward
host: endolinbot
to: "*"
refs:
  - entries/2026/05/29/140800Z-dispatch-steward-f8a9b0.md
  - entries/2026/05/29/142800Z-result-designer-9c7d88.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 358
    role: target
---

# result: designer on #358 — 12 inline comments addressed, re-review requested

Designer dispatch `9c7d88` returned cleanly. New head SHA on
`design/daemon-worker-import-from-mount`: `e72b355ffe85c7f063420ee47397ed3689041201`.

## Outcomes (per result `9c7d88`)

The dispatch table named 5 inline comments; the actual review carried
12 (9 top-level + 3 in-thread). Designer treated all 9 substantively
per the role's line-to-section verification norm.

Edits to `designs/daemon-worker-import-from-mount.md` (per maintainer
direction):

- Summary/Goals reframe Node.js as a separate lane with a JS reference
  implementation.
- Non-Goals inverted: "Reimplementing in JavaScript" dropped, "Sharing
  internal data structures between lanes" added.
- Native modules removed from non-goals (new Goal #7).
- RegistryResolution keyed by canonical `<name>@<version>` (e.g.
  `ses@1.0.0`, `@endo/patterns@1.2.1`).
- `makeMountReadPowers` closes over both `registry` and `entryMount`
  with late-bind via `E(registry).fetch`.
- Lockfile scope removed (section, Phase 5, design decision, open
  question, error-catalog references all scrubbed).
- New § "mapSnapshot lane in compartment-mapper" describing the
  daemon-specific lane producing `{ compartmentMap, resolution,
  readPowers }`.

`designs/README.md` synced (Updated 2026-05-29; summary and
size-estimate rows refreshed).

Rebase: origin had moved forward to `193846c93` (solicitor round-1
panel commit). Rebased over it; resolved five conflict regions
keeping kriskowal-directive edits and folding in upstream's helpful
glosses + tests.

Inline replies posted (11): 3324956439, 3324957459, 3324958456,
3324958965, 3324959869, 3324960570, 3324961134, 3324962137,
3324963217, 3324964002, 3324965245.

Top-level summary: comment 4576271365 with comment-ID→disposition→
section table, knock-on README edits, two flags for the maintainer:
- The mapSnapshot lane introduces a structural change to
  `compartment-mapper` itself (extension point). Whether that lands
  in this design's implementation PR or a separate compartment-mapper
  PR is flagged for maintainer steering.
- An "Also untrue" comment on line 124 was ambiguous — treated as a
  continuation of the line-101 lane-separation thread and flagged for
  re-visit.

Re-request review: HTTP 201, kriskowal back in `requested_reviewers`
(used working `--input -` JSON shape).

## Cleanup

Tearing down `/home/kris/dispatches/designer--9c7d88/`.

## Other parallel events to triage this engagement

- **#357 (kriskowal directive at 14:12Z)**: APPROVED but CONFLICTING
  with stale CI from 5+ days ago. Maintainer says "try again, pass
  to conductor when CI green." Dispatching weaver next for rebase
  on current `llm` (CI re-runs automatically on push).
- **#343 (kriskowal CHANGES_REQUESTED at 14:21Z)**: in contractor
  slot `summary-fix-343` — contractor handles, not steward.
- **#377**: still awaiting kriskowal reply to fixer's response.
- **#79**: unchanged.
- **#358**: awaiting kriskowal re-review of designer's update.

Self-improvement: nothing new this engagement.
