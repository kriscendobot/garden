I ran panel round 9 on kriscendobot/garden-book PR #15, and the verdict is **must-fix**.

- **Setup:** the PR head is `kriscendobot:garden-book-illuminations-republish-20261014` at commit `9212459`, against base `main-5acd916`. I reviewed it in an isolated checkout at `scratch/project-wt-kriscen-b7c6b3afe27a-7de12a2b`.
- **Panel run:** my first `panel.sh` run was killed by mistake (rc=143). A stray `pkill` hit it. I reran it detached, and the single-round panel then finished with rc=0, ending on `code-panel single-round — must-fix`.
- **Seats:** 34 seats ran. 3 asked for changes (decomplector, coverage-auditor, pruner), 17 left comments only and 14 approved. No seat or decider errors.
- **Must-fix items:**
  1. **decomplector:** replace the HTTP listener in `tools/clip-server.mjs` with Playwright route fulfilment. The browser check would then serve exactly what `makePublishContent` returns, under the clip's CSP. This removes the separate file-set rules in the publisher and the check, which is what caused the repeated `publish-book.mjs`/`browser-check.mjs` must-fixes in earlier rounds.
  2. **coverage-auditor:** `measure()` in `tools/browser-check.mjs` never runs in any automated test. Either add a Chromium-backed test with one good and one known-bad fixture, or record in the PR body why it can't run under `npm test`, with the manual run as evidence.
  3. **pruner:** delete-only prose cuts in `build/README.md`, `art/OPENAI-ILLUMINATIONS.md` and `art/illumination-redraw-evidence.md`. The PR body also says publishing "uploads every relative image the page loads", which is stale and contradicts the declared-plates behavior.
- **Review posted:** https://github.com/kriscendobot/garden-book/pull/15#pullrequestreview-5538939975. It leads with the three must-fix items, then each seat's report with request-changes first.
  - GitHub refused a request-changes review because the bot authored this PR, so it went up as a comment review, the same as earlier rounds.
  - The full aggregate was 93 KB, over GitHub's review size limit. I cut the body to about 59 KB: the must-fix seats are complete, and only some lower-priority seat reports were shortened to a one-line stub.
- **Follow-up for the maintainer:** coverage-auditor suggests adding c8 coverage to garden-book's `npm test`, so this repo gets a coverage report the panel can read. Not done here.

No garden code changed. I did not fix anything or take the PR out of draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr15-gauntlet-panel-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1258061 cached reads)
- Output: 7796 tokens
- Cost: $0.9246681999999998
- Wall-clock: 414s

<!-- garden-usage-end -->
