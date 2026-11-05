Fix round 4 for PR #249 is pushed and CI is green, but only after rerunning one failed WebKit job. `ci-wait-merge.sh` first exited 3 (red), then 0 on the same head, `e90919d2`.

**CI rerun**
- **Failure:** `gate (webkit)` timed out at 5 s on "shows limits and model changes before reattaching".
- **Why I reran instead of reporting red:** this round's commits don't touch the reattach code, and the same test passed on the previous head. I ran `gh run rerun --failed` once, and all three browser gates then passed.
- **Limits:** this looks like a flake, but one passing rerun doesn't prove it, and WebKit isn't installed on this host. The bot's token can't see commit statuses or non-Actions checks.

**Must-fix source:** no juror labelled anything must-fix in the review body. I took the items from the panel-run record, which marks archivist, decomplector and saboteur as must-fix (its 20-item list is cut off and also includes their "checked, no issue" lines). I also fixed a few cheap items other jurors raised.

**Changes**
- **`8740a3c4`, agent projection:** only an `active` agent now gets the full record. The cited factory revision also has a `deleting` lifecycle that used to fall through to the full projection. It and any unknown value now expose only `agentId`, `name` and `lifecycle`. This also restores two dropped doc comments.
- **`5abcf687`, wake retry:** while a wake is unconfirmed, the switch shows the request being checked and no longer asks a queued-mail question whose answer was ignored. The error text is corrected too.
- **`e90919d2`, replacement docs and tests:**
  - The `replacementMoves` doc and the changeset now state the wider grant-only refusal and how it clears.
  - `operationId` is deprecated, and the changeset says the fixes apply once `API_KEY_GUEST_AGENTS` is on.
  - `reattachKey`'s parameter is now `moveId`.
  - There are three new replacement tests.
- **On the PR:** the body now says why both move paths stay, and I posted the required summary comment: https://github.com/kriscendobot/minion.town/pull/249#issuecomment-6651391796

**Declined after checking the cited upstream revision or this code**
- **`provider-not-found` on retry:** `list()` still returns superseded providers, so this can't happen.
- **Unreadable answers:** `json()` already turns a parse failure into a `TypeError`.
- **Reattach with nothing selected:** the confirm button is disabled in that case.
- **Moving everything through the factory:** its `reattach` takes only agents it owns, so older grants need the registry path.

**Left for panel 5**
- Explicit `Public*` return types, a `dailyDollars` ceiling, the property-test proposals, persisting pending keys in `sessionStorage`, and squashing history.
- A stuck creation still blocks unrelated grant-only moves until it finishes or is aborted; this is now documented, not fixed.

**Verification**
- Typecheck and pre-push probes pass; lint auto-fix did not run.
- The endpoint, provider-service and Chromium browser suites pass locally. WebKit and Firefox ran only in CI.
- The new `deleting` and wake tests fail when the production code is reverted. I did not revert-check the three replacement tests.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr249-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (3757152 cached reads)
- Output: 30851 tokens
- Cost: $2.699602400000001
- Wall-clock: 1436s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
