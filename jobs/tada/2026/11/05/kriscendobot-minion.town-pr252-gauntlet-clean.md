**Clean stage for kriscendobot/minion.town #252: done, CI green, nothing pushed.** The PR head stays at `755d0179` and the PR is still a draft.

**Coverage and dead code**
- **Scope:** the PR adds one line to `deploy/aws/www/home.js` (a `hashchange` listener that reloads the page) and one new check in `test/browser/clip-frame-gate.ts`.
- **Coverage:** I did not run a c8 baseline, because `boot()` only runs in a browser. The browser gate exercises the new line, so I added no tests.
- **Mutation check:** with the listener removed, the new check "a guest URL pasted over the open landing recovers in the same tab" fails, 30/31 on Chromium, with the credential left in the URL. With it restored, 31/31 pass. I put the file back afterwards.
- **Dead code:** the change orphans nothing.
- **Reload side effects:**
  - The only other reader of `location.hash` is `provider-ui.js`, which `home.js` doesn't appear to affect (I didn't check its page load directly).
  - The logout link's `href="#"` calls `preventDefault`, so it can't trigger a reload.
  - `history.replaceState` doesn't fire `hashchange`, so it can't cause a reload loop.

**Local checks**
- `test/home-page.test.ts` and `test/shell-clip.test.ts` pass, 138/138.
- The `tsc` typecheck printed no errors, but the exit status I captured was from the pipeline's `tail`, so it isn't proof on its own. CI's typecheck job passed.
- I only ran the gate on Chromium, because this host has no Firefox or WebKit browsers. The CI gate job covers all three.

**CI**
- `ci-wait-merge.sh --no-merge` returned rc 0 (GREEN) at `755d0179`, and the Actions API confirms both runs succeeded: `test (typecheck + vitest)` and `clip frame browser gate`.
- The bot token can't read `statusCheckRollup`, so the script fell back to the Actions runs API. Commit statuses and non-Actions checks weren't visible.

**Follow-ups:** none for this stage; the gauntlet driver takes it from here.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr252-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (417478 cached reads)
- Output: 5299 tokens
- Cost: $0.6219476
- Wall-clock: 778s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
