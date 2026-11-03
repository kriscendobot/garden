Fix round 3 for kriscendobot/minion.town PR #234 is pushed and CI is green on the new head (7 of 7 checks). The panel-4 review was not re-run.

**Input.** No deterministic pre-pass block came with the job, so I worked from the latest panel review (5751992940). Every seat voted request-changes, but the items were all should-fix or comment-only; none was must-fix.

**Pushed** with `safe-push-pr-head.sh` as two follow-up commits, moving the head from `a909f9be` to `bb6f1bee`:

- **`bae1dcdc` fix(web)**
  - **Forget route:** `DELETE /api/guest/contacts/:petName` now deletes the caller's accepted invitation records under that name. A replay after the name is forgotten or rebound to another peer now answers 404 (raised by breaker, purist and wire-watcher). New HTTP test: bob accepts alice's invitation as `friend`, forgets it, accepts carol's as `friend`, and replaying alice's invitation gets 404.
  - **`forgetContact` docstring:** no longer says "revokes nothing". It now says forgetting a name that holds a pending remote invitation voids it (engine-realist).
  - **Comments:** the `dismissAll` comment now describes the `Promise.all` behaviour accurately. `removeName` now takes a structural `{has, remove}` type and a parameter named `names` (purist). I dropped two duplicate comments in the tests (pruner).
- **`bb6f1bee` fix(probe)**
  - **Mint answer:** the probe now scans it for both bearers before handing the invitation to the acceptor, and the scan also catches a percent-encoded copy. New fake-town test covers a bearer echoed plainly and one encoded in `invitationUrl`. This was the main finding from locksmith, breaker, purist and wire-watcher.
  - **Coupons:** the mint now sends `attachCoupon: false`, so the probe won't reserve a coupon every pass once #199 lands (integrator).
  - **Spent step:** it now also checks that the 404 carries the code `invitation-unavailable`.
  - **Wording:**
    - The header warning now names the three guest bearers that `MINION_PROBE_BASE` redirects.
    - The probe and `DEPLOYMENT.md` now use the same wording for the objective.
    - The "same size" claims are narrowed to names and listed messages, with daemon storage reclaim marked as unmeasured.
  - **Pruner cuts:** I applied most of the requested comment cuts.

**PR metadata.** I cut the body from about 425 words to 232 and changed the title to `feat(web,probe): …` so it names the two new routes.

**Checks run locally:** the probe tests passed 35/35, `vitest` on `test/web` passed 53/53, and `npm run typecheck` was clean. After the push, `ci-wait-merge.sh` returned rc 0.

**Follow-ups:**
- **Commit grouping not done:** integrator wants the earlier commits regrouped into `feat(web)` then `feat(probe)`. That needs a history rewrite, which a follow-up-commit fix round shouldn't do, so it is still open.
- **Map growth:** the router's in-memory invitations map still has no eviction for contacts that are never forgotten. This predates the PR.
- **Untested:** the remote-invitation voiding claim comes from engine-realist reading the daemon source. No real-daemon test covers it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr234-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1680122 cached reads)
- Output: 11560 tokens
- Cost: $1.2600403999999996
- Wall-clock: 474s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
