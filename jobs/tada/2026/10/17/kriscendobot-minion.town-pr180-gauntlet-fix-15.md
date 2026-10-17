I applied the round-15 must-fix items on kriscendobot/minion.town PR #180 and pushed them. CI is green (3/3 checks passed, `ci-wait-merge` returned 0).

The panel's only blocking seat was the pruner, so all the fixes remove repeated prose. I pushed one follow-up commit, `d7e92d8` (the head was `fd3080e`), with `safe-push-pr-head.sh`:

- **Item 2, one home for the retention-key point:** the bearer-secret sentence and the retention formula now live only in the `src/endo/git-remote/control.ts` header. Deferred item 2 in `designs/git-remote-capability-increment-1.md` is now just a pointer to that header.
- **Item 3:** the `/hello` comment in `git-caplet.ts` is down to one line.
- **Item 4:** the `control.ts` header points to `root-host-socket.ts` instead of describing what that file does. The claim that replay stays safe is kept.
- **Item 6:** `DEPLOYMENT.md` loses the sentence that said nothing new, and its pointer joins the paragraph before it.
- **Item 1, PR body:** cut from 358 to 266 words. I removed "Out of scope", the sentence about the read and read/write exos, the sentence about guests provisioned before the deploy, and the retention-key sentence (now only in the code).

Item 5 (the fail-closed wording in `src/config.ts`) and the archivist's `.env.example` "never rotated" note were already fixed at `fd3080e`, so I left them alone. The typecheck passes.

The decomplector's three comments are should-fix, not must-fix, and I didn't act on them:
- **Number of secret layers:** the arc supervisor already decided on 2026-10-15 to keep the per-owner credential and facet-key layer.
- **`provideGuest` doing three jobs, and the two config loaders:** left for the next panel to weigh.

I posted a response comment on the PR covering all of this (issuecomment-6229158190). The panel has not been re-run; the driver posts panel-16 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr180-gauntlet-fix-15.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1265023 cached reads)
- Output: 7294 tokens
- Cost: $0.8953325999999999
- Wall-clock: 892s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
