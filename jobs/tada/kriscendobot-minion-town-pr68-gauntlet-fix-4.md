CI is GREEN. The fix stage is complete.

## Completion report — kriscendobot/minion.town PR #68, gauntlet FIX round 4

This was a clean re-derivation after a reaper requeue: no prior fix-4 work had been pushed (PR head was at `5024556`, and the panel-4 verdict post-dated every existing commit). I applied the panel round-4 must-fixes as review-feedback follow-up commits.

**Pushed** (`5024556..606092b` on `feat/weblet-publish-dir`):
- `408754c fix(clip): honor the @main worker bridge and bound payload size (#68)`
- `606092b test(clip): pin worker selection, endowment, and size ceilings (#68)`

**Applied**
- **Must-fix 1** — the dead `@main`/`MAIN` bridge. The clip site probed `facet.has("@main")`, whose app-side `assertValidPetName` rejects `@`-names before the socket, so `resolveGuestMainWorker`'s catch always returned legacy `MAIN`. Added `GuestFacet.mainWorkerName()`, resolved once in `composeFacet` against the **raw daemon** `has`, unifying both call sites.
- **Must-fix 2** — tests now record the `evaluate` call and pin the selected worker (`MAIN`, and `@main` once the fixture advertises it) plus the `["guest"] = ["@agent"]` endowment (never `@host`). Both the bridge bug and a `@host`-escalation now fail the suite.
- **Must-fix 3** — added a `.max(MAX_CONTENT_FILES)` count cap and a 16 MiB total-decoded-byte ceiling checked before `publish.publish`, with two new tests.
- **Should-fix (security)** — validate `contentValue` via `assertValidPetName` before splicing into `E(guest).lookup`; dropped the dead `typeof/length` guard; renamed the shadowing `name` var.

Suite: typecheck clean, clip tools 16/16 (was 12), full suite 308 passing. **CI terminal: GREEN.**

**Deferred (documented in the PR comment, [#issuecomment-5549068032](https://github.com/kriscendobot/minion.town/pull/68#issuecomment-5549068032)) — with rationale, not silently:**
- **Must-fix 4a** (register through `MCP_TOOL_NAMES`) — `src/endo/mcp-tool-names.ts` is introduced by still-open #79 and does not exist on this branch; cannot route through a file that isn't here.
- **Must-fix 4b** (reword `upgrade … in place`) — the `upgrade` tool's behavior is unchanged by this PR; rewording only the docstring to match the unlanded #88 direction would make the comment lie about the code. Belongs to the #88 line of work.
- **Must-fix 5** (split the conflated commit) — the fix-stage contract is review-feedback follow-up commits, not a published-history rewrite mid-review.

**Must-fix 6** (answer the maintainer sitrep + post a PR summary) — done via the PR comment above.

Follow-ups for a later round: the #79-dependent namespace registration, and the `dev/mock-as.ts` should-fixes (refresh_token scope fallback, `grantedScopes` eviction, redirect-URL logging).

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 100 tokens (3602057 cached reads)
- Output: 29874 tokens
- Cost: $3.4655335
- Wall-clock: 501s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
