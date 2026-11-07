Fix round 1 for kriscendobot/minion.town PR #254 is pushed and CI is green: all 7 checks pass, and `ci-wait-merge.sh --no-merge` returned rc 0.

**The finding.** The style pre-pass failed `spell-out-identifiers` because `test/home-page.test.ts` uses `ok`. That name isn't one the test made up. It is the field in the result that the production `submitWaitlist` returns (`Promise<{ ok: boolean; message: string }>`), which `src/waitlist/waitlist.ts` also uses. Renaming it would change production code and the API, which is outside this round's scope.

**What changed.** I added a file-level waiver on line 2 of `test/home-page.test.ts`:
`// spell-out-exempt -- \`ok\` is the established public wait-list response field returned by submitWaitlist.`
This follows the PR's own earlier commit 1f61df2, which waived the same field the same way in three other files. With the PR base as the reference, the probe now passes locally.

**Push.** One follow-up commit, 608b3d6 `test(web): annotate fixed wait-list response field`, advanced the PR head from 083da5d using `safe-push-pr-head.sh` in its default history-preserving mode.

**Problems on this host:**
- `ensure-project-worktree.sh` failed because the shared bare clone `worktrees/kriscendobot-minion.town.git` is read-only inside the sandbox. This looks like a relative of the 2026-11-07 tmpexec read-only outage. To work around it, I cloned privately into the per-job `$TMPDIR`, set the bot git identity in that clone, and pushed from there. This will break any project job on this host until the bare repos are writable from the sandbox, so it is worth a sandbox/host-repair look.
- My first CI wait ran into the tool's background time limit and was stopped. I waited for the checks to finish with a foreground polling loop, then re-ran `ci-wait-merge.sh` to get the official rc 0.

I didn't re-run the panel; the driver posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1157592 cached reads)
- Output: 4524 tokens
- Cost: $0.7721104000000001
- Wall-clock: 1953s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
