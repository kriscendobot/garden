# Fix round 3 complete: kriscendobot/minion.town PR #150 (CI green)

I applied panel round 3's must-fix and most of its should-fixes in two follow-up commits on `fix/claude-cli-production-enable` (`fa7b114`, `731cdb2`). CI is green on head `731cdb2`.

**The must-fix (integrator #1):** the PR description was out of date. I rewrote it to:
- give the correct `MemoryMax` (1536M, not 1G);
- add the new deploy gate in `deploy-app.sh` (`assert_claude_production`);
- add the connect-time spawn serialization (`serializeSetupSpawn`) and the wider test coverage.

The rewrite also takes pruner's PR-description trims: shorter motivation, no design-rationale paragraph, no "tsc is clean" line and no test count. The `garden-job` marker is unchanged.

**Should-fixes applied:**
- **integrator #2:** `DEPLOYMENT.md` now says the deploy runs the Claude production checks itself and rolls back if one fails. The commands to run over SSM stay, as a way to re-check a live host.
- **assessor #1:** the deploy's `/account/claude/<nonce>` check now also fails on a 5xx or a `000` status, not only on 404. I didn't require a 2xx/3xx, because the smoke request uses a made-up nonce and can legitimately get a 4xx.
- **archivist:** the comment in `minion-mcp.service` now names `serializeSetupSpawn` instead of `handleSetupToken`.
- **curator / integrator #3 / fast-checker:** the `childName` schema in `guest-tools.ts` now calls `isValidChildName` itself instead of copying its pattern, so the two can't drift.
  - My first version imported it from `agents.ts`. That broke CI: `agents.ts` loads `@endo/errors`, which needs SES installed first, so three test files failed to load. The second commit moves the predicate into a new dependency-free `src/endo/claude/child-name.ts`, and `agents.ts` re-exports it.
  - Locally, `tsc` is clean and the full suite passes (805 tests), apart from the `git-remote/capability` failure that also happens on `main` on this host.

**Not applied:**
- **orthographer (`cancelled` → `canceled`):** declined. `cancelled` in that tool description is the name of a result tag the code actually returns (`type: "cancelled"`), not prose, so renaming it in the description would misdescribe the result.
- **pruner #6/#7:** the shorter service and deploy-doc comments.
- **corner-prober / breaker:** the extra race and boundary tests.
- **coverage-auditor:** the missing coverage report.

All of those were comment-only or optional, so I left them for the next panel.

**Note:** the maintainer has already approved the PR (review 5407324149, "please conduct and deploy"). The gauntlet driver re-posts panel-4 next. The maintainer may prefer to go straight to merging once that panel passes.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr150-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (2065535 cached reads)
- Output: 11696 tokens
- Cost: $1.2727150000000003
- Wall-clock: 768s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
