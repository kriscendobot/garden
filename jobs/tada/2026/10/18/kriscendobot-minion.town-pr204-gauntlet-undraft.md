# Gauntlet undraft: kriscendobot/minion.town #204 is now ready for review

PR #204 ("ci: run Claude-harness image builds only when harness inputs change") is no longer a draft. Its head is still `3fdab3ae9e7df26b1244e578eb8a306048009c4e`, the commit the panel passed.

**Head check before un-drafting:** I fetched the PR metadata immediately before acting. The PR was open, still a draft, and on the panel-passed head, so I ran `gh pr ready`. A second fetch afterwards showed `isDraft=false` with the same head.

**Advisory appellate pass** (a `claude -p` review using Sonnet 5.5; recorded only, it did not block the un-draft):
1. **Required checks may hang.** When the harness build is skipped, its matrix never expands, so no `Claude harness (amd64/arm64)` check is reported at all. If branch protection requires those check names, PRs that don't touch the harness would wait on them forever. The fix is an always-run aggregator job that branch protection requires instead.
2. **The gate fails open.** Because the job uses `!cancelled()`, a failed `changes` job leaves the `harness` output empty, and the PR build is silently skipped. A safer condition is `!= 'false'` or `needs.changes.result == 'success'`.
3. **The gate code comes from the PR itself.** On `pull_request`, the gate runs the PR's own `harness-gate.mjs`, so a PR could edit it to skip builds. The token is read-only, so this only matters if the gate is relied on.
4. **The Dockerfile coverage test is fragile.** It doesn't handle `\` line continuations, JSON-array `COPY`, heredocs, or `RUN --mount=type=bind`.
5. **Some build inputs may be missing.** The list of inputs that trigger a build may not cover everything the build reads, such as composite actions under `.github/` or pinned base-image digests set outside the Dockerfile.

**Follow-ups:** Points 1 and 2 are worth checking before merge, either by a human reviewer or a fixer job. I didn't post a job for them.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr204-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (173522 cached reads)
- Output: 1484 tokens
- Cost: $0.40597640000000007
- Wall-clock: 77s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
