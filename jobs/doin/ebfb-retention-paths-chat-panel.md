# Build: retention-paths Chat UI Paths panel (read-only) — next phase after #284

**Repo:** `endojs/endo-but-for-bots` (bot direct push; bot identity).
**Base:** `llm` (after PR #284 merges — the host API this consumes lands there).
**Design:** [`designs/daemon-retention-paths.md`](https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-retention-paths.md),
sections *Chat UI*, *Reactive update surface*, *Security*, and *Phased Implementation → Phase 4 (Chat panel — read-only)*.

This is the next-phase build the maintainer directed when approving **PR #284**
(review 4604615118, kriskowal, 2026-06-30: "Please conduct and post a job for the
next phase of development as described"). #284 landed the host API and CLI
(design Phases 1-3); the next increment is the **read-only Chat UI panel**.

## The feature (design Phase 4 — read-only)

In `packages/chat`, surface retention paths reactively over #284's host API:

- **Reveal affordance on every value.** A small chain-link "paths" icon next to
  the existing value chip in inbox, inventory, transcript, and value modal.
  Clicking opens the Paths panel.
- **Paths panel** — a floating panel anchored to the value, listing every path
  in the CLI's notation: pet-name segments as a clickable chip (bold pet name +
  parent store label), field-edge segments as a small grey arrow `→<field>`, the
  leaf (target value) highlighted. Handle the empty state (no retaining paths /
  unretained).
- **Live updates.** The panel subscribes via
  `EndoHost.followRetentionPaths(locator)`; first delta is the `{ snapshot }`,
  subsequent deltas are `{ added, removed }`. Render reactively in place; closing
  the panel drops the far reference, releasing the subscription (the producer
  generator returns on the next poll).

Consume #284's exported `RetentionPath` / `RetentionPathSegment` /
`RetentionPathDelta` types from `@endo/daemon`. Do **not** re-walk the formula
graph in the UI; bind to the host API only (host facet, never guest).

## Out of scope (later phases — do NOT include)

- **Write affordances** (design Phase 5 / the PR body's deferred "Phase 4"):
  per-path "Delete pet name on this path" with confirmation, and the per-value
  Disincarnate / Reincarnate toggle. Separate follow-on.
- **Formula-inspector / workers-panel integration** (design Phase 6): tracked
  separately by plan job `formula-inspector-retention-paths-table-v2`.

## Approach

- Match the surrounding confined-Preact Chat UI conventions (per #471).
- A small **web-design pass first** if the floating-panel layout / anchoring /
  segment-chip styling warrants it (kind-discrimination may select the
  `web-designer` then `web-builder` variants); otherwise build directly.
- Render tests against a `RetentionPath[]` / `RetentionPathDelta` fixture:
  snapshot render, multi-path, single path, empty state, a coalesced
  added/removed delta, and subscription release on panel close.
- Add a changeset (`@endo/chat` or the relevant package) and end with the
  standard top-level PR summary comment (head SHA + what was added +
  verification: tests / lint / types).

## Definition of done

A PR against `endojs/endo-but-for-bots` (base `llm`, bot identity) adds the
read-only retention-paths Chat UI: a per-value reveal affordance and a reactive
floating Paths panel sourced from #284's `followRetentionPaths` host API, with
the empty/many states and tests, opening DRAFT to run the gamut. Report the PR
number.

---
claim:
  host: endolinbot2
  gardener: 59
  claimed_at: 2026-06-30T23:03:00Z
