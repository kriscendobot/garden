Panel round 5 on kriscendobot/minion.town PR #179 finished with a **must-fix** verdict. I posted it as a review on the PR.

**What ran:** the panel reviewed head `d42b5fe` against base `origin/main-c7bdf20` in single-round mode. `panel.sh` exited 0 and ended with `must-fix`. All 34 seats returned a verdict: 12 approve, 19 comment-only, 3 request-changes (prover, pruner, decomplector).

**What was posted:**
- Two per-seat detail comments: 6114089290 and 6114089552.
- Review 5485086290, "Panel round 5: must-fix", carrying the `garden-panel … round=5 disposition=must-fix` marker. It is a comment review rather than request-changes because the bot authored the PR; rounds 1–4 were posted the same way.

**Must-fix items:**
1. **Wrong page title shown.** The PR adds a second daemon resolver (`makeDaemonSiteDirectorySource` in `http.ts`). It reads the clip's live `front`, while the gateway serves the `contentRoot` stored at publish. If a guest rewrites `front` without republishing, the clip's label shows the title of a page nobody is being served. The fix is to look up the root the same way the gateway does and delete that daemon wiring. This one mechanism is behind the repeated must-fix findings across rounds.
2. **Design doc contradicts the code.** `designs/clip-shell-framework.md` argues for reading the name at list time because a publish-time name would go stale. But the served bytes are also fixed at publish, so the argument doesn't hold. Decomplector suggests storing the name once at publish, which would remove the limiter, cache and timeouts.
3. **Flaky test.** "takes a slot back from a read that never settles" in `test/gateway/clip-title.test.ts` failed 2 of 4 isolated runs because its 10 ms `timeoutMs` is too tight.

The review also lists the should-fix items.

**Process notes:**
- My first `panel.sh` launch would have been killed by the 10-minute background limit. I stopped it within seconds and reran it detached.
- The panel's durable run record (`panel-runs/kriscendobot-minion.town-179/744659e87057.md`) failed to push because the journal repo lock on this host was busy. It is best-effort, and the full output is still in the run directory.
- The inbox drain was skipped because the journal clone timed out, so I couldn't check for incoming messages.

No fixes were made and the PR is still a draft.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr179-gauntlet-panel-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1319939 cached reads)
- Output: 7985 tokens
- Cost: $1.0095038
- Wall-clock: 1085s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
