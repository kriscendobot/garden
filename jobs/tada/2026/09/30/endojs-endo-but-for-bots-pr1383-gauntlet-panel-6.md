PR #1383 (`docs(designs): daemon lifecycle idempotency`) failed panel round 6 with a **must-fix** verdict, and the review is posted on the PR.

**What I did**
- Made an isolated checkout of `endojs/endo-but-for-bots` on branch `design/daemon-lifecycle-idempotency`. Its head is `1f77b37d01`, the round-5 fix commit.
- Ran `panel.sh` in single-round mode against the real merge-base SHA, `7ff30afbce` (the frozen base branch is `llm-7ff30af`). It exited 0 with disposition **must-fix**.
- My first run failed only because I passed the wrong worktree path, so every seat failed on `cd`. It was my mistake, not a problem with the panel or the PR. I deleted that run's scratch directory and ran it again with the correct path; the result above is from the second run.
- Posted the combined seat reviews on the PR with the `garden-panel-verdict: must-fix` marker. GitHub doesn't allow request-changes on the bot's own PR, so it went up as a COMMENT review, the same way round 5 did.

**What still needs fixing**
- **Integrator (binding, must-fix):** the PR description is missing the "Scaling Considerations" and "Upgrade Considerations" headings from the PR template. The integrator also says the design never squares its use of `ENDO_BIN` with `daemon-capability-bus`, and wants that design added to the Dependencies table.
- **Critic:** the stale-claim reclaim (unlink, then link again) has a race. A slow second reclaimer can delete the winner's fresh claim marker, so two daemons each think they own the state directory. The design should either have the winner re-check its marker before doing anything destructive, or say plainly that this gap remains.
- **Skeptic (must-fix):** `ping`'s exit code becomes "a total function of the classifier." That drops its current full round trip to the daemon in favor of a bare socket connect, so a daemon that binds its socket but never starts serving would look healthy. Also, no test SIGKILLs `engo` itself.
- **Ergonomist:** the query commands return exit code 3 for `elsewhere` (a daemon is running, just on a different socket), the same code as for no daemon at all. Also, `stop` goes ahead and stops an `elsewhere` daemon, while `start` and `clean` refuse.
- **Pruner:** cut the Consideration sections in the PR description that repeat the design. This conflicts with the integrator's template requirement, so the fixer will have to reconcile the two.
- **Minor:** the decomplector notes that "claimant" means two different processes (`run-daemon` and `manager-node.js`), and that the ordering of `engo`'s claim is never stated. The pedant flags durations written three ways ("5s", "10ms", "one second"). The novice suggests defining the classifier before the section that first uses it, and the copyeditor has one small wording nit.

This stage didn't fix anything and didn't un-draft the PR; the gauntlet's fix loop takes it from here.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1383-gauntlet-panel-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (470033 cached reads)
- Output: 3999 tokens
- Cost: $0.6212826
- Wall-clock: 350s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
