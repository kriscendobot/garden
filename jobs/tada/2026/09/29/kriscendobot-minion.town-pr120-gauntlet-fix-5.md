I applied round 5's code must-fixes and pushed them to PR #120, and CI is green on the new head `4222c44`. That green comes from the GitHub Actions runs API, not from `ci-wait-merge.sh`. The bot token on this host can't read the PR's CI status field (`statusCheckRollup` → "Resource not accessible by personal access token"), so that script could never finish and would only have hit its deadline. I stopped it after about 7 minutes. The only workflow, `test (typecheck + vitest)`, finished with `success` on `4222c4481c` (https://github.com/kriscendobot/minion.town/actions/runs/36515771978).

**Must-fix items**
1. **Phase/evidence gate:** no code change can clear it. The PR stays draft until endojs/endo-but-for-bots#1015 and the live canaries (root, confinement, delegation, restart) land.
2. **`infer` liveness gap:** `infer` now re-checks liveness after the credential-status `await` and before taking the inference slot. A revoke, cancel or dismiss in that gap now returns `unavailable` and spends nothing. The new test for this fails at the old head `484cfc3` and passes at `4222c44`.
3. **PR description:** rewritten to describe what the code does now, not a changelog per panel round. It covers the guarded `@endo/exo` handles made by `guardedFar`, the new `@endo/exo`/`@endo/patterns` dependencies, the concurrency and teardown guarantees, and current test counts.
4. **Abbreviated names:** the mock `infer` parameter `p` is now `prompt` in `test/claude-delegation.test.ts` and `test/claude-inbox-watch.test.ts`. The variables `p`/`gc` are now `peerChildFacet`/`"grandchild"`.

**Should-fix items**
- **Also fixed: child facets after `revoke`.** A child's facet now uses the same liveness check as its agent (`childIsLive`): the record must be current and its delegation not revoked. I added assertions to the existing revoke test. These new assertions don't fail on the old code, so the behavior may already have been covered another way.
- **Also fixed: missing completion-summary comment.** I posted one for this round's commit on the PR.
- **Not addressed:** teardown claimed twice, the status facet outliving its grant, the name of the injected `Far` seam, a repeat `delegate` dropping its new `canceled`, the inbox rate window using `Date.now()`, the `DelegatedClaudeAgents` alias, the looser `maxChildren` guard, the unhardened `DEFAULT_INBOX_WATCH_RATE`, regrouping the commits, and the title.

`npm run typecheck` and `npm test` (521 passed, 7 skipped) pass locally.

**What changed:** one commit, `4222c44` (`fix(claude): re-check liveness after infer's credential await; revoke inerts child facets`), touching `src/endo/claude/agents.ts` and the two test files. It was pushed with `safe-push-pr-head.sh` as a plain fast-forward from `484cfc3`.

**Follow-up:** `ci-wait-merge.sh` can't read CI status on host oros-studio-garden-ce242c49. It needs to fall back to the Actions runs API, or later fix stages on this host will stall until their deadline.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr120-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 56 tokens (1775715 cached reads)
- Output: 12538 tokens
- Cost: $1.2133990000000001
- Wall-clock: 1986s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
