**Fix round 2 for `kriscendobot/minion.town#236` is done: the fixes are pushed at `280bacc6` and CI is green.** `ci-wait-merge` returned rc 0, but it could only see Actions runs because this token can't read `statusCheckRollup`. The PR is still a draft, and I didn't re-run the panel.

**Commits**
- **`89b135ea`, name handling:**
  - Any failure after the invite now cancels the invitation in `inviteRemote` and `connectLocal`, so a failed `locate()` no longer leaves a name that answers 409 on every retry.
  - `inviteRemote`, `connectLocal` and `acceptLocal` now share one in-process name reservation.
  - The fake daemon now binds a name on invite and frees it on cancel, with new retry and overlap tests.
  - A 409 on Connect CLI no longer hides an invitation already on screen; this `settings.js` change has no test.
- **`accfd2d0`, hint filter:**
  - `hintIsServed` now accepts only the route's own transport keys with string values, and exactly one `node` and one `loc`.
  - It rejects any other query key, userinfo or a path, and any `loc` not spelled as `JSON.stringify` writes it, which is how the pinned daemon writes it.
  - The two locator functions share one re-format helper, and the WebSocket test uses the shape from `endojs/endo-but-for-bots#684`.
- **`280bacc6`, docs:**
  - The changeset now says the 409 applies on every deployment.
  - `DEPLOYMENT.md` warns that starting a WebSocket listener makes the TCP hint get refused too, and orders the steps.
  - Both design docs match the served route.

**On the PR**
- **Body:** added the phase and evidence ledger, corrected the node-check claim, and noted that raw locators (#239, #243) are out of scope. It also now says the two-daemon trial was manual and CI doesn't reproduce it.
- **Summary comment:** posted the [fix-round summary](https://github.com/kriscendobot/minion.town/pull/236#issuecomment-6624964669) with what changed and what was declined.

**Verification**
- **New tests:** with the old `guest-locator.ts` and `guest-web-socket-service.ts`, 15 tests fail. With the fixes, the locator and socket-fault test files pass (90 tests).
- **Typecheck:** `tsc --noEmit` is clean.
- **Other local tests:** the rest of `test/web/` and `test/settings-menu.test.ts` last passed just before a small final refactor of `guest-locator.ts`, with `guest-web-daemon.test.ts` skipped.
- **Full suite:** I didn't run it locally, so that rests on CI.

**Declined** (reasons are in the PR comment)
- **Commit regrouping:** this stage only adds follow-up commits, so it's left for a retcon before merge.
- **Rebuilding hints from validated fields:** rejecting anything unchecked gives the same guarantee.
- **Checking `loc.transport`:** a wrong value there still goes out, but there's no route value to compare it with, and the dial address comes from the checked hints.
- **A cross-process name guard:** another process can still write in that window; the code comment now says so.
- **Comment-only wire-watcher items:** no change to binding invitations to `identify(petName)` or to `enable`/`disable` ordering.

**Follow-ups**
- **New parked job:** I posted `minion-town-remote-guest-cli-live-proof`, gated on maintainer go-ahead, because the ledger's slice disposition needs a named successor. It owns the remaining design steps and the live acceptance proof.
- **The ledger may not hold the PR in draft:** the author-time gate returned `clear reason=no-ordered-design-signal`, so it didn't treat the design as ordered and never evaluated the ledger. The panel-time gate may do the same, and the PR could then un-draft despite the slice label. `gauntlet.sh` does re-read the ledger after a passing panel, but I didn't test that path, so watch it after panel-3.
- **Merge blocker still open:** `DEPLOYMENT.md` says `enable` stays blocked on the Endo peer-gateway fix and the other preconditions listed there. The PR's three open questions also still need maintainer answers.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr236-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (1487405 cached reads)
- Output: 32070 tokens
- Cost: $1.994393
- Wall-clock: 824s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
