I applied the round-5 panel fixes to https://github.com/kriscendobot/minion.town/pull/210 and pushed them. CI on the new head `fa7781e` came back green (`ci-wait-merge` rc 0).

**What I did:**
- **Must-fix (archivist #1):** `DEPLOYMENT.md` § Guest agent activity said the role could only update `last_active_at` on activity rows. The policy also allows the key attributes `iss` and `sub`, so the sentence now names all three.
- **Must-fix (integrator #1):** the PR body still named the old partition `urn:minion-town:agent-activity`. It now says `urn:minion-town:guest-agent-activity`.
- **Should-fix raised by four jurors (locksmith, saboteur, breaker, wire-watcher):** the serving role could read activity rows by asking `UpdateItem` to return the old values.
  - I added a Deny statement, `GuestAgentActivityNoReturnedRow`, to `deploy-accounts-store.sh`. It blocks `UpdateItem` on the activity partition when `ReturnValues` is `ALL_OLD`, `UPDATED_OLD`, `ALL_NEW` or `UPDATED_NEW`.
  - The Deny also closes a second read path the jurors didn't name: an empty, key-only update that the existing guest-recovery grant would otherwise allow on activity rows.
  - `test/guest-agent-activity-policy.test.ts` gained cases for these. The two activity test files pass (28 tests) and typecheck is clean.
  - I reworded the script header, `DEPLOYMENT.md` and the PR body. IAM limits the role to the one attribute, but it does not make stamps only move forward; that check is in the serving code. A conditional write can also still be used to compare against a stored stamp, and IAM can't close that.
- **Smaller fixes:**
  - The script header now says "the encrypted guest-recovery attributes" instead of miscounting them as two.
  - Two claims I couldn't verify are now worded more carefully.
  - A `…` in a code comment is now ASCII `...`.
  - Per the pruner, I removed facts that were stated in several places.
  - The PR body now says the stamp is recorded only at the app's two guest entry points, so a guest used some other way (for example through its OCapN locator) is not stamped.

**Commits:**
- `bbeeff5` fix(guest): deny returned values on activity-row UpdateItem
- `fa7781e` docs(guest): state each guest-agent-activity fact once

**Not done / follow-ups:**
- **Waiting on the maintainer: whether to redesign the stamp.** The decomplector asked whether the stamp should live on the daemon's guest object instead, which would also cover uses through the OCapN locator. That is a design decision, so I kept the current design and messaged the maintainer to confirm it or ask for a redesign.
- **Not done: commit regrouping.** The integrator suggested squashing the history into four commits. I left it, because this stage only adds follow-up commits. It can be done with a retcon later.
- **Not done: smaller suggestions.** I didn't add a request timeout or cancellation to the DynamoDB writes, or handle the clock stepping backward. Both were raised as should-fix or comment-only, not must-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr210-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1729796 cached reads)
- Output: 14051 tokens
- Cost: $1.2636992
- Wall-clock: 1217s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
