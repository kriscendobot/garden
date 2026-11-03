**Clean stage is done for kriscendobot/minion.town #233: coverage tests are pushed and CI is green at `7f5202ecf05`.** `ci-wait-merge.sh --no-merge` returned rc 0 ([run](https://github.com/kriscendobot/minion.town/actions/runs/41615206541)). The bot PAT can't read `statusCheckRollup`, so that result comes from the Actions runs API, which doesn't show commit statuses or non-Actions checks. The PR stays draft.

**Coverage pass**
- I measured v8 coverage against only the lines the PR added.
- **Before:** uncovered lines in `guest-control.ts`, `guest-tools.ts`, `root-host-socket.ts`, `guest-web-service.ts`, `guest-web-socket-service.ts`, `local-invitations.ts` and `http.ts`.
- **After:** the only uncovered added line is `src/http.ts:442`, the `acceptLocal` delegate in the socket-backend wiring. That path needs a real daemon. CI's live-daemon step ran `test/web/guest-web-daemon.test.ts` (5 tests passing) on the previous head; I didn't re-read that log for this one.

**New tests (commit `7f5202ec`, test files only)**
- **`test/web/local-invitations.test.ts` (new):**
  - A failed redeem leaves the link usable by anyone.
  - An accept in flight refuses a second accept and a cancel.
  - Cancel reaches only the owner's invitation under that name, and works on an entry with no daemon state.
  - The identifier travels only in the URL fragment.
- **`test/endo-guest-agent-invite.test.ts` (new):** a daemon invitation is reduced to `locate` and `cancel`, and a non-string locator is refused.
- **`test/endo-invite-tools.test.ts`:**
  - A locator failure cancels the invitation and mints no link, even if that cleanup also fails.
  - A newcomer's name conflict keeps the link good for a retry.
  - One guest can't cancel another's invitation.
  - `cancelInvite` fails closed without the `invite` capability.
- **`test/endo-guest-control.test.ts`:** the facet carries `invite` only when the guest has one, and checks the pet name before the daemon sees it.
- **`test/web/guest-web-socket-faults.test.ts`:** `acceptLocal` binds the contact, refuses a held or invalid name, refuses during a deletion, and rolls back when another process's deletion overtakes it.

**Checks**
- **Mutation check:** I broke the source in 7 places, one at a time, such as removing the owner check or the rollback. The new tests failed each time, and the source was restored afterward.
- **Local runs:** `tsc --noEmit` is clean and the affected test files pass (194 passed, 5 skipped). The skips are the daemon suite, which needs `ENDO_CHECKOUT`. I didn't run the full suite locally; CI did.

**Dead code:** I removed nothing. The symbols the change introduced or moved are all still in use, and the router's old crypto imports were already gone.

**Follow-ups:** none. I installed `@vitest/coverage-v8` with `--no-save`, so `package.json` and the lockfile are unchanged.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr233-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1418211 cached reads)
- Output: 19602 tokens
- Cost: $1.5386422000000002
- Wall-clock: 817s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
