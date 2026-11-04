---
handed-off: build-minion-town-tool-removal-landing-20261104
deliverable-complete: false
---
## Completion report: build-minion-town-tool-removal-20261104

**Status: handed off, not finished.** All the removal code is in draft PRs and CI is green, and the garden's callers are migrated. Nothing has run in production, because #239 and #235 are still unmerged drafts. The blocked successor job `build-minion-town-tool-removal-landing-20261104` owns the rest, and #239 merging or closing promotes it.

### Changes
- **#242 (draft, stacked on #235):** removes `status`, `list`, `has`, `writeText`, `readText`, `remove`, `listMessages`, `send`, `dismiss`, `resolve`, `adopt` and `submit`. It also moves the guide, primer, recipes, manifest, tests, prod probe, dev client and `instructions` string to `evaluate`.
- **#243 (draft, stacked on #242 and #239):** removes `invite`, `cancelInvite` and the inviter plumbing behind them. It adds the browser proof, `tools/guide-recipes/verify-web-accept.ts`, and the guide's `#v=1&locator=` link.
- **Garden `main2` (`3ec3eb02`):** migrated `skills/minion-town-clip-publishing`, `skills/minion-town-ocapn-dispatch`, `context/operations/minion-town-mcp.md` and `scripts/jobs/minion-town-review-queue/publish.sh`.
    - `publish.sh` wasn't on the job's list, and it would have crashed once `writeText` was gone.
    - `minion-mcp-watchdog.sh` and `minion-mcp-lib.sh` needed no change, because neither has an expected tool count or a removed tool name.
- **kriscendobot/garden-book#17 (draft):** the book's publisher also called `writeText`. It must merge before #242 deploys, or the book can't publish.

### `tools/list` size
These are build-time measurements with clips and invite mounted, not production readings:

| | Tools | Bytes |
| --- | --- | --- |
| Before (#235 head) | 19 | 13264 |
| #242 | 7 | 7066 |
| #243 | 5 | 5663 |

### Evidence
- **Browser proof, local only:** ran against a real daemon at pin `1706e632` with headless Chromium. `evaluate` minted the invitation, a fresh browser guest accepted on the card, mail flowed both ways, a replay failed, and the browser guest was deleted. No locator appeared in the output or the server log.
- **Verify-first tools, real daemon:**
    - `has`, `resolve` and `submit` work through `evaluate`.
    - The daemon itself refuses `remove('@main')`, as well as `@agent` and `@self`, so the tool's guard was redundant.
    - `adopt` no longer needs the tool: the recipe reads the edge name from the message by position, so sender text never enters `source`.
- **CI:** green on #242 (run 41768080955) and #243 (run 41768255035), including the live-daemon steps. Locally, seven test files fail on this host and the reference check couldn't run, but CI passed them all.
- **Production not reached:** this host has no credentials for the MCP bridge, so the garden and garden-book callers haven't been run against production either. The successor requires AWS for this reason.

### Maintainer decisions (also in the PR bodies)
1. **Escaping is now the agent's job.** With `writeText` gone, a locator handed over out of band must go into `source` as a hand-escaped string. Escaped hostile text is tested, but the tool argument used to give this safety for free. Is that acceptable, or do you want an `evaluate` input for literal text?
2. **Rejected text patterns.** `-->`, `<!--`, `import(` and `eval(` are rejected even inside a string, so the guide now teaches escaping one character.
3. **Local quickstart.** Without `ENDO_SOCK`, `npm run client` now proves only OAuth and the tool list, because the in-memory guest has no evaluator. The README says so.
4. **Longer-lived invitation links (#243).** A locator link lives in the daemon, not the server's memory, so I expect it to outlive a server restart, though I didn't run that case.

### Also found
Visitors who already hold a guest never saw an invitation link's card; the page went straight to the shell. This affects today's `invite` links in production too. The fix is in #243, so you may want it sooner.

### Remaining work
**Successor job:**
1. Run the production browser proof after #239 deploys. If it fails, `invite` and `cancelInvite` stay and #243 stays a draft.
2. Land in order, with #235 before or alongside #242. If #235 is still open, both PRs stay drafts, and the job doesn't merge #235 itself.
3. Weave both PRs onto the merged state.
4. Record production `tools/list` sizes and `verify-production.ts` results.
5. Run the garden callers' `evaluate` calls against production, then update the ledgers.

If #239 closes unmerged, the job is told to stop and ask you.

**Separate follow-up, not yet posted:** `GuestFacet` still carries methods that mostly only tests use now, and they can be removed later.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-tool-removal-20261104.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 8 tokens (1351350 cached reads)
- Output: 4042 tokens
- Cost: $8.169083 (1 engagement(s) unpriced)
- Wall-clock: 2651s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
