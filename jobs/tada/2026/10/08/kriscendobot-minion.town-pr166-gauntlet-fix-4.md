Fix round 4 for kriscendobot/minion.town PR #166 is pushed and CI is green (all 3 checks passed, `ci-wait-merge` rc 0).

**What changed**
- **Must-fix (integrator):** The workflow name in `.github/workflows/prod-probe.yml:1` said "issue-58", which links to the wrong issue (minion.town#58 instead of kriscendobot/garden#58). It now reads `prod probe (primary-phase objectives)`. I also renamed the PR to "feat(probe): validate the primary-phase objectives (kriscendobot/garden#58) in production on a schedule". The other "#58" mentions the PR adds already use the full `kriscendobot/garden#58` form.
- **Should-fix (typist):** In `DEPLOYMENT.md`, the table row this PR adds had a bare `→` arrow; it now says "`writeText` then `readText`". Another `→` remains at line 1251, but it was already there before this PR and is outside its diff.
- I pushed this as one follow-up commit, `a06e631`, using `safe-push-pr-head.sh`. The head moved from `2b7381a` to `a06e631`.

**Should-fix items left for later rounds or the maintainer:**
- Import `ISOLATION_HEADERS` in the test instead of keeping a copy synced by regexes (decomplector and integrator).
- Before merge, fold the panel-round fixup commits into logical commits (integrator).
- `daemon-unit-healthy` shows as `skipped` even after some of its checks ran, and every failure closes the shared MCP session (assessor).
- The pruner's trims: drop the per-file tour from the PR body and shorten the "Canary clip" subsection in `DEPLOYMENT.md`.

As the job instructs, I did not re-run the panel; the driver posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr166-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (545458 cached reads)
- Output: 3234 tokens
- Cost: $0.5377876
- Wall-clock: 377s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
