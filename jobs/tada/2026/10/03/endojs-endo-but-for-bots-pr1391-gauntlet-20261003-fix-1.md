Fix round 1 is done for endojs/endo-but-for-bots PR #1391 ("feat(ses): permit and share a pre-lockdown SturdyRef shim"), and CI is green at head `61a08fd144`.

The round-1 panel review (5399695642, on head `0088203`) had two must-fix items. An earlier attempt at this job had already handled both before it died: it pushed commit `61a08fd144` and edited the PR body, both at 08:29 on 2026-10-03, minutes after the review. I checked that work, added a note to the PR, and watched CI. I pushed no new commits.

1. **Pruner (padded comments):** done in `61a08fd144`.
   - In `packages/ses/src/global-object.js`, the comment on `firstWinsPropertyNames` no longer describes how to add a second entry. It now states the rule an entry must meet: it reaches every compartment, so it must confer no authority, and passing a shape check does not prove that. This also covers the copyeditor seat's non-blocking suggestion on the same comment.
   - In `packages/ses/test/_sturdyref-shim-first.js`, the extra sentence about freezing and hardening is gone.
2. **Integrator (two different `SturdyRef` concepts, and the maintainer's unresolved objection on #695):** the PR body now has a section headed "Relation to other SturdyRef work". I checked its two claims:
   - It cites kriskowal's 2026-09-30 comment on #695 (issuecomment-5903472512), which asks for exactly this as item 2: SES permits a shim-installed `SturdyRef` and shares it with child compartments. The PR leaves the remotable-versus-passable question to layer 3 (#1392).
   - `@endo/ocapn`'s `SturdyRef` is a type definition local to that module, not a global, so the two can't collide at runtime (confirmed in `packages/ocapn/src/client/sturdyrefs.js`). Item 7 of the maintainer's plan is where OCapN moves onto the shared `SturdyRef`.
   - The integrator also recommended returning the PR to draft; it already is one.

I posted a comment on the PR listing how each must-fix item was addressed, so the next panel round can see it: https://github.com/endojs/endo-but-for-bots/pull/1391#issuecomment-5968274020

**CI:** `ci-wait-merge.sh --no-merge` returned 0 after about 15 minutes; all 33 checks passed.

**Follow-ups:**
- Panel round 2 should rerun the integrator seat to confirm the body section answers its objection. The real design question (remotable or new passable kind) is the maintainer's to settle on #695 and #1392.
- The copyeditor's suggestion was covered, but other seats' non-blocking test-gap suggestions were not applied, because only must-fix items were in scope. They are: a fixture with only one of the two required statics, getter-shaped statics, and a "cannot replace" test that checks the mutation and a later grandchild compartment.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1391-gauntlet-20261003-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 96 tokens (3096849 cached reads)
- Output: 17478 tokens
- Cost: $2.0485298000000003
- Wall-clock: 6363s
- Model(s): claude-opus-5-5 ×2

<!-- garden-usage-end -->
