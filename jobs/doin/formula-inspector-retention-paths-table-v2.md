<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-07-02T14:39:31Z -->

# PLAN (follow-on, re-parked): add a retention-paths table to the formula inspector

Re-park of `formula-inspector-retention-paths-table` (v1 completed BLOCKED on #284;
maintainer **approved the recommendation to land #284 first**). This is the v2 spine
that holds the same follow-on work, **blocked on endo-but-for-bots#284 landing** to
base `llm`. When #284 merges, promote this plan (plan→todo). Wear the **designer**
then **builder** role on `endojs/endo-but-for-bots` (bot identity, bot repo).

## Dependency status (2026-06-28)

- **#440** (formula inspector, design #439) — MERGED into `llm`. Bind point:
  `packages/spaces-util/src/formula-view.js` (with `formula-view-registry.js` /
  `value-component.js`).
- **#284** (retention-paths host API — the table's data source) — OPEN, now
  **MERGEABLE** (rebased 2026-06-28); the sole remaining gate is **CI-green +
  merge**, being driven by job `pr-ebfb-284-shepherd`. Do **not** start this build
  until #284 is on `llm`; do **not** reimplement the graph walk in the UI.

## The feature

Add a **"Retention paths" table** to the formula inspector's Value-modal Formula
back face (#439) listing **all** paths by which the inspected formula is retained —
each row a path from a retaining root through the reference graph to this formula,
showing formula-ids/petnames and edge kind. Make it scannable when many (group/sort,
show count, paginate/scroll). Handle the empty state ("no retaining paths /
unretained"). Read-only, sourced from #284's captp `HostInterface`:

- `listRetentionPaths(locator) -> Promise<RetentionPath[]>` (snapshot)
- `followRetentionPaths(locator) -> AsyncIterator<RetentionPathDelta>` (live)
- `RetentionPath` = array of segments `{ groupMembers, referencedBy, labels }`;
  pet-store edges render `pet:<name>`, root segment carries `type:"root"`;
  `length === 0` is the empty state.

## Approach

- Bind the table to #284's host API at `packages/spaces-util/src/formula-view.js`.
  A small design pass first if the layout warrants it.
- Match the surrounding confined-Preact Chat UI (per #471).
- Render tests against a `RetentionPath[]` fixture: multiple paths, single path,
  none.
- End with the standard top-level PR summary comment (SHA + what was added +
  verification).

## Definition of done

The formula inspector shows a "Retention paths" table sourced from #284's host API,
with sensible layout + empty/many states and tests, on a PR against
`endojs/endo-but-for-bots`. Report the PR number.

---
claim:
  host: endolinbot
  gardener: 29
  claimed_at: 2026-07-02T14:39:34Z
