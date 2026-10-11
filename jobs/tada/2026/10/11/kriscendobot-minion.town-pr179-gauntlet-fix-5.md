Fix round 5 for kriscendobot/minion.town PR #179 is done. All three must-fix items from panel round 5 are fixed, pushed as `bbf1c71` (fast-forward from `d42b5fe`), and CI is green: `ci-wait-merge.sh --no-merge` returned 0 with 3 of 3 checks passing.

**Must-fix items:**
1. **Clip names now come from the page the gateway actually serves.** A new `servedContentRoot` function in `src/endo/gateway/vhost-table.ts` is now the only place a clip record is turned into the content root to serve. The gateway's request path (`gateway.ts`) and the title reader (`clip-title.ts`) both use it.
   - `publish.list` takes the content root from the clip store's record, which the daemon registry writes when a clip is registered. Only a record with no stored root falls back to reading its directory's `front`.
   - So if a guest rewrites `front` without republishing, the gutter no longer shows the title of a page nobody is being served.
   - New test in `test/gateway/publish.test.ts`: "names a clip from the root the gateway serves, not the directory's current front".
2. **The extra daemon connection is gone.** I removed the `makeDaemonSiteDirectorySource` wiring from `src/http.ts` and put `src/endo/gateway/site-registry.ts` back to the base version. That drops the reconnect, deadline and late-open code, plus its test file `test/gateway/daemon-site-directory-source.test.ts`.
3. **The design doc's argument is corrected.** `designs/clip-shell-framework.md` now says the name is read from the served root. Because that root is content-addressed, its title is cached per root, and clips published before this change need no backfill.
4. **The flaky test is fixed.** In `test/gateway/clip-title.test.ts`, "takes a slot back from a read that never settles" now uses `timeoutMs: 500` and `queueTimeoutMs: 1000`, with `slotCeilingMs` still at 40. It passed 8 out of 8 runs on its own.

**Should-fix items I also did:** removed the "Visible effect" and "Reconnect" parts of the PR body and cut "Why at list time" down to a link to the design doc. I also posted a "Panel round 5 fixes" summary comment on the PR, and reworded the `clip-title.ts` comments so they no longer say "a name never blocks the listing" or blame only the daemon.

**Checks:** `tsc --noEmit` is clean. `npm test` has one failure, `test/git-remote/capability.test.ts`, which is outside this diff and already listed in the PR body as failing only in the checkout environment.

**Left for later:** the remaining round-5 should-fix items:
- Storing the title once at publish time instead of reading it when clips are listed.
- A U+2800 braille-blank title still passes the visibility check and renders blank.
- Matching `</title` per the HTML spec.
- Making `NAME_FILTER` private.
- Updating `DEPLOYMENT.md`.
- Posting fix-summary comments for earlier rounds.

The driver will re-post panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 72 tokens (3248925 cached reads)
- Output: 19205 tokens
- Cost: $1.8414370000000007
- Wall-clock: 1010s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
