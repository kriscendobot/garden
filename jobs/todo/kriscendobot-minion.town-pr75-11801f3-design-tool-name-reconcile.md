---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Follow-up to merged PR #75 (`feat(mcp): expose interface-native tool names`, commit 11801f3, merged as 7f0b8f9), which removed the `guest_`/`clip_` prefixes from the MCP tool surface and recorded the old→new mapping table in README.md.

The rename swept the implemented surface (`src/`, `test/`, `deploy/`, and the already-implemented designs), but several **not-yet-implemented** design documents still prescribe prefixed tool names and now contradict the landed convention. A builder implementing any of them would reintroduce `guest_`-prefixed tools:

- `designs/claude-agents-capability.md` — `guest_submit` (lines ~391, ~463, ~506)
- `designs/remote-guest-endo-cli.md` — `guest_invite` (lines ~206, ~225, ~228, ~320, ~381)
- `designs/git-remote-capability.md` — `guest_lookup` (line ~977)

Reconcile those proposed tool names with the interface-native convention PR #75 established: pick names that read as methods of the Endo agent/guest interface (as `guest_eval` → `evaluate`, `clip_publish` → `publish` did), confirm each proposed name does not collide with a currently registered tool name or with another design's proposal, and update every occurrence in prose, examples, and any transcript/sample blocks. Where a design's name choice is genuinely load-bearing and a rename would change its meaning, say so in the PR body rather than forcing a rename.

Do **not** touch the README old→new mapping table (the prefixed names there are deliberate history), and do not re-open the implemented surface — this is a docs-only reconciliation of unimplemented designs. Note that `src/endo/identity.ts` mentions `guest_name` as a DynamoDB attribute, not a tool name; leave it alone.

Open a PR against `main` and run the gauntlet.
