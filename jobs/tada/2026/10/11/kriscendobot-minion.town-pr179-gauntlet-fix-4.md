I fixed both must-fix items from panel round 4 on kriscendobot/minion.town PR #179, pushed them, and CI is green on the new head `d42b5fe`.

**What I changed** (commit `d42b5fe`, added on top of `090fb13`):
1. **A connection that opens after its deadline is now closed.** In `src/endo/gateway/site-registry.ts`, the check for a missed deadline now runs inside the same error handler that closes the connection. Before this, a daemon connection that succeeded but arrived late was left open. I added a test in `test/gateway/daemon-site-directory-source.test.ts` where the connection opens after the deadline; it checks that the connection gets closed and that the next read reconnects. The test fails on the old code and passes with the fix.
2. **The title code is larger than the problem.** I kept reading the name when clips are listed, rather than recording it once at publish, and wrote down why in `designs/clip-shell-framework.md` § 2, the header of `clip-title.ts`, and the PR body:
   - The guest holds the clip's directory and can rewrite its front page without going through the gateway's publish or upgrade, so a name saved at publish would go stale.
   - Clips published before this change have no saved name.
   - If clip records later carry a name that follows the front page, the list-time read and its limits, cache and timeouts can be deleted.
3. **One should-fix item:** the `clip-title.ts` header now says a lookup holds its slot until its reads finish or the hard time limit passes.

I also posted the "Panel round 4 fixes" summary comment naming `d42b5fe` (https://github.com/kriscendobot/minion.town/pull/179#issuecomment-6113148807).

**Checks:** `npm run typecheck` is clean, and the related test files (`test/gateway`, the shell, HTTP and endpoint tests) pass, 271 tests. I did not run the full `npm test` suite. CI passed all 3 checks (`test` and the amd64 and arm64 Claude harness runs), and `ci-wait-merge.sh --no-merge` returned 0.

**Follow-ups:** The rest of round 4's should-fix list is still open:
- logging where swallowed errors come from
- names that are only a U+2800 braille blank or a bare "…", which show as blank
- invisible characters such as ZWNJ being replaced with a space, which splits words
- `<title>` being matched inside comments, scripts and SVG
- sanitizing names three times
- splitting connection handling from the registry lookup
- a migration note
- hardcoded ports in the new test

The next panel round may raise them again. Per the job, I did not re-run the panel.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1311142 cached reads)
- Output: 8416 tokens
- Cost: $0.9747323999999999
- Wall-clock: 884s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
