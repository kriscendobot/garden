Gap report delivered to the maintainer. The job is blocked on an external dependency I should not work around, so I'm completing with a gap report rather than spinning. Here is my completion report.

---

## Completion report: `formula-inspector-retention-paths-table`

**Outcome: BLOCKED — gap reported, no PR opened (as the plan directs when #284 is unavailable).**

### What I did
- Verified the dependency graph for this follow-on:
  - **#439** (design) — MERGED.
  - **#440** (formula inspector) — MERGED into `llm` 2026-06-27. The back-face to extend is `packages/spaces-util/src/formula-view.js` (with `formula-view-registry.js` / `value-component.js`).
  - **#284** (retention-paths host API — the table's required data source) — **still OPEN, not on base `llm`.**
- Inspected #284's API surface and its state in depth.

### The gap (why no PR)
The plan requires the table to be **sourced from #284's host API** and explicitly forbids reimplementing the graph walk in the UI. #284 has not landed:
- **Stalled since 2026-05-21.** kriskowal's last review said *"Please rebase and run the gamut again"*; that rebase/re-gamut never happened (no activity in 5+ weeks).
- **CI red:** 4 FAILURE checks of 26. Not mergeable as-is.
- Its `listRetentionPaths` host method does not exist on `llm`, so a table PR built now could neither pass CI nor be verified — exactly the situation the Definition of Done says to report rather than work around.

### Good news for the follow-on (ready the moment #284 lands)
- #284 exposes the right shape over the **captp `HostInterface`** (reachable from the chat web client, not CLI-only):
  - `listRetentionPaths(locator) -> Promise<RetentionPath[]>` (snapshot)
  - `followRetentionPaths(locator) -> AsyncIterator<RetentionPathDelta>` (live `{snapshot}` then `{added,removed}`)
- `RetentionPath` = array of segments, each `{ groupMembers, referencedBy, labels }`; pet-store edges render `pet:<name>`, root segment carries `type:"root"`. This maps cleanly onto table rows (one path per row/group, segments as the path, labels as edge kinds) and supports the empty state directly (`length === 0`).
- Bind point on the inspector side: `packages/spaces-util/src/formula-view.js`.

### Follow-ups / recommendation
1. **Land #284 first** — the rebase + gamut re-run kriskowal already requested on 2026-05-21. This is the sole blocker.
2. After #284 merges to `llm`, **re-promote this plan** (`jobs/plan/formula-inspector-retention-paths-table.md` → `todo/`); the design+build is then a straightforward bind to `listRetentionPaths` plus a scannable table section + render tests against a `RetentionPath[]` fixture.
3. I messaged the maintainer (via the liaison) with this gap and offered to take the **#284 rebase-and-gamut** as a separate job on request — not posted unilaterally, since it's a 1419-line dependency PR that was already bulletin-tracked.

No worktree was created (read-only investigation only); nothing to tear down.
