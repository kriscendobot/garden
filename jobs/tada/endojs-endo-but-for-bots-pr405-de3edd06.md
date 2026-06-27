Done. Completion report below.

---

## Completion report — `endojs-endo-but-for-bots-pr405-de3edd06`

**Directive (kriskowal, PR #405):** hide empty inventory groups, and re-group into Directories / Agents / Personas / Values / other Capabilities.

**Routing decision:** concrete, actionable maintainer feedback on a live (non-draft) PR → carried directly into the PR branch rather than queued. I made a defensible interpretation of the one genuinely ambiguous point and surfaced it for confirmation rather than blocking on it.

### What I did
Pushed `398a8aba5` to `feat/inventory-grouping-by-type`:

- **Regrouped** the inventory taxonomy across both surfaces kept in lockstep — `packages/space-chat/src/inventory/tree-source.js` (chat) and `packages/cli/src/commands/list.js` (`endo list --grouped`):
  - Handles (`handle`) · Personas (`host`) · Agents (`guest`) · Directories (`directory`, `readable-tree`, `mount`, `scratch-mount`) · Workers (`worker`) · Values (`marshal`) · Capabilities (catch-all).
  - Interpretation: split the two coarse catch-alls (old `Hubs` / `Everything Else`) into the finer role-named groups; kept `Handles` and `Workers` as distinct groups (Workers was the empty-group example).
- **Empty-group hiding** was already implemented (Preact `InventoryGroupSection` returns null; CLI skips empty buckets) — kept and re-pinned by tests.
- **Tests** updated: `cli/test/list-grouping.test.js` (every type→group mapping + new 7-group order) and the chat component test (per-category placement for host→Personas, guest→Agents, marshal→Values, directory→Directories, readable-blob/eval→Capabilities; empty-group-hidden and /mkdir reactive regressions retargeted).
- **Design doc** `designs/inventory-grouping-by-type.md` + `designs/README.md` updated to the new taxonomy (status → In Progress, 2026-06-27).

### Bonus fix (was blocking CI)
Both failing checks (`lint` and `test`) were red on the **same pre-existing TS2339** at `inventory.js:337` — unrelated to grouping (the earlier safe-await `{ ok, value }` wrapper widened `ok` to `boolean`, breaking discriminated-union narrowing). Annotated the literal `true`/`false` discriminant so `.value` narrows after the `!ok` guard. Prettier was already clean. Both checks should now go green.

### Verification
`node --check` on all changed files passed. Could not run the monorepo test suite locally (no `node_modules`; sandbox blocks bin shims) — CI on the push is the verification gate. Posted a top-level summary comment (issue-comment 4819905981) stating the interpretation, the two judgment calls (`readable-tree` = "readable trees"; `pet-store` → Capabilities), the CI fix, and an explicit offer to fold Handles/Workers into Capabilities if that's what he meant. Worktree torn down.

### Follow-ups
- Watch CI on `398a8aba5`; if green and the maintainer confirms the grouping, the PR can proceed to merge.
- Open question for the maintainer: whether `Handles`/`Workers` should stay distinct or collapse into `Capabilities` (flagged in the PR comment).
