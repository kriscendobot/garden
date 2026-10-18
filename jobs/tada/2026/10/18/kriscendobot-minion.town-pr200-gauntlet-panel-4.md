Panel round 4 on kriscendobot/minion.town PR #200 came back **must-fix**. `panel.sh` exited 0, so this is a real verdict, not a panel error.

I ran a single round against an isolated checkout of `feat/beta-settings-simplify` at head `f26ce02`, compared to base `feat/beta-home-splash-waitlist-bbf6c15`. The panel also added the decomplector seat, because a design doc changed and the last two rounds raised must-fix on the same mechanism.

**Results:** 34 seats ran. Three asked for changes; the rest approved or left comments only.
- **surfacer** (the must-fix): `DEPLOYMENT.md:787` lists the served modules as only `home.js` and `shell.js`. It leaves out the new `settings.js`, which no longer matches the Caddy `@landingScripts` list or the route-admission JSON.
- **breaker** (should-fix): the design says the deletion tombstone refuses the bearer on "every route". But it is only enforced on the guest web routes. Earlier CLI invitations or peer connections may still reach the guest through the OCapN routes, which the tombstone does not cover. Either revoke those in `deleteGuest` or narrow the claim.
- **pruner**: some explanations are repeated in several places (`http.ts`, `DEPLOYMENT.md`, the design), the design doc narrates what this PR removed, and several test and JSDoc comments just restate the code beneath them.

Other should-fix items:
- **archivist:** the diagram in `designs/clip-shell-framework.md:62` is out of date, and the `ENDO_GC` claim isn't backed by anything in the repo.
- **decomplector:** `deleteGuest(id, commit)` takes a callback; split it into a check call and a retire call. Separately, it noted that the durable-append code partly duplicates `credit-ledger` (a matter of taste, not blocking).
- **assessor:** retrying a delete that already succeeded on the server shows a confusing "Not deleted" message.

**What I posted:** a comment review on PR #200, id 5562329804, because GitHub doesn't let the bot request changes on its own PR. It follows the same layout as rounds 1 and 2: blocking seats first. The full text was about 94KB, more than GitHub's review size limit, so the remaining seat blocks are in PR comment https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6248208459.

I did not fix anything or un-draft the PR, and made no garden commits. The fix-loop stage comes next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (734044 cached reads)
- Output: 4063 tokens
- Cost: $0.6954368
- Wall-clock: 284s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
