All done. Here is my completion report.

---

## Completion report — endo-but-for-bots PR #405, inventory grouping (round 2)

**Outcome:** All five of kriskowal's follow-up asks are implemented, tested, and pushed to the PR branch `feat/inventory-grouping-by-type`; a top-level summary comment was posted on #405.

**How each ask was addressed:**

1. **Filtered per-header count** — `InventoryGroupSection` (space-chat `inventory.js`) now derives `visibleCount` by applying the special-names (`@`-prefixed) filter, and uses it for both the count badge and the empty-group `return null`. The host wrapper (`inventory-component.js`) reads the show-special checkbox's live `.checked` state, passes `showSpecial` into the confined tree, and re-renders on toggle (a single module-level detacher prevents listener stacking across channel switches; `renderConfined` reconciles in place so the `followNameChanges` subscription survives). A group whose only members are hidden specials now disappears until the toggle reveals them.
2. **Handles group** — formula type `handle` maps to a dedicated **Handles** group in both `tree-source.js` and `cli/list.js`, no longer folded into Capabilities.
3. **Manual order** — fixed to **Handles, Directories, Values, Capabilities, Agents, Personas** in both `INVENTORY_GROUPS` tables; the CLI catch-all now resolves Capabilities by key (it is no longer last).
4. **Speech bubble removed** — deleted the `💬 ::before` rules on conversable and active-conversation pet-names in `index.css`.
5. **Indent** — `.pet-group-body` padding-left 4px → 7px.

**Also updated:** the design doc (six-group taxonomy + manual order + count/bubble/indent notes), the changeset, the CLI `--grouped` help string, and tests (chat: Handles group, filtered count, hidden-only group; CLI: Handles bucket, new order, key-based catch-all).

**Verification:** chat component tests 458 passing (incl. 3 new/updated), CLI grouping tests 10 passing, `eslint` + `prettier --check` clean, `tsc --build` clean for `@endo/cli`, `@endo/chat`, `@endo/space-chat`.

**Commits pushed:** `297dc9610` (the five fixes) and `16b493f16` (help-text correction).

**Review:** an adversarial juror pass confirmed no [BUG]/[RISK] — the reordered catch-all, reactive show-special wiring, and the special-only-group lazy-mount edge case (benign/recoverable) all check out.

**Follow-ups (out of scope, pre-existing, left for a future pass):** CLI `INVENTORY_GROUPS`/`groupForType` are unhardened (matching this file's existing convention); `directory.js` `formatId` isn't inside the type-resolution `catch`; follow-mode prints `-name` removals even when a `--type` filter is active. None affect this change.

**Self-improvement:** nothing this time.
