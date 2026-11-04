---
handed-off: build-minion-town-tool-removal-20261104
deliverable-complete: false
---
## Completion report: build-minion-town-tool-minimalism-20261104

**Status:** I closed the web-accept gap, which was the blocker. No tools have been removed yet. All the removal work is handed to a posted successor job.

### What I did
1. **Why the two locators differ.** The `invite` tool doesn't return the daemon locator itself. It registers it in the server's in-memory invitation registry and returns a registry identifier (`#v=1&invitation=<id>`). `POST /api/guest/invitations/accept` only took that identifier. So a raw `endo://…` locator from `E(E(agent).invite(n)).locate()`, made through `evaluate`, had no way in.
2. **The fix, in draft https://github.com/kriscendobot/minion.town/pull/239** (base `main-9196892`):
   - The accept route now also takes `{ locator, petName }` and redeems it as the visitor's own guest. That uses the existing `acceptLocal` path, which does `E(invitee).accept(locator, petName)`, so it grants nothing the visitor's guest couldn't do already.
   - A malformed, spent or foreign locator gets a 404 `invitation-unavailable`, so the visitor keeps their guest. The daemon's error reason is not passed back.
   - `home.js` reads `#v=1&locator=<encoded endo://…>`, shows the existing invitation card, and clears the locator from the address bar, since a locator works like a password.
   - Added a changeset.
3. **Checks:**
   - **Real-daemon test:** I added one where an MCP guest creates the invitation with `evaluate` only, and a freshly created browser guest accepts it through the web accept route. Mail then goes from agent to person via `evaluate`, and from person to agent via `/api/guest/mail`, which `evaluate` reads back. Reusing the same locator gets a 404 and the second guest keeps its guest. CI ran it against the pinned endo `1706e632` and it passed (6/6, run 41757084445).
   - **Unit tests:** fragment parsing and address-bar clearing.
   - **CI:** all checks are green. Locally, vitest (52 tests) and `tsc` pass.
4. **Audit of garden-side callers:**
   - The watchdog probe only counts the results of `tools/list`; it doesn't call the `status` tool, so removing tools won't break it.
   - `skills/minion-town-clip-publishing` uses `writeText`, `readText`, `has`, `status` and `list`.
   - `context/operations/minion-town-mcp.md` uses `status`, `writeText`, `remove`, `send` and `invite`.
   - In minion.town, PR #235's `tools/guide-recipes/recipes.ts` calls the `writeText` and `remove` tools directly.
   - The successor job lists all of these to migrate.

### Which tools to remove (step 1)
- **Remove:** `status`, `list`, `writeText`, `readText`, `listMessages`, `send`, `dismiss` and `adopt`. PR #235's recipes ran each of these through `evaluate` successfully.
- **Remove after a check:** `has`, `remove`, `resolve` and `submit`. For `remove`, the check is whether the daemon still protects `@main` from deletion when the call comes through `evaluate`.
- **Remove after #239 is deployed and works on production:** `invite` and `cancelInvite`.
- **Keep:**
  - `evaluate`.
  - `publish`, `listSites`, `unpublish` and `upgrade`, because they act on the app's clip store and billing, not on the guest.
  - The four root-only Claude tools, because the pinned Endo can't hand that factory to a guest.

### Not done (owned by the successor)
- The Playwright run of the invitation card and the production run.
- The actual tool removals, and updating the `instructions` string, resources and primer.
- Migrating the garden callers listed above.
- The before/after tool list and the `tools/list` size in bytes.

Two things gate the removals: #239 has to merge and deploy, and the guide in #235, which is still a draft, has to land so agents aren't left without instructions.

**Successor job:** `build-minion-town-tool-removal-20261104`, posted with the full decision table and caller list.

I created no production guests and logged no locators.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-tool-minimalism-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 96 tokens (4036984 cached reads)
- Output: 22763 tokens
- Cost: $2.0412088000000006
- Wall-clock: 531s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
