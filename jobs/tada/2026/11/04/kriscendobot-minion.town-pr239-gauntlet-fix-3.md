**FIX round 3, PR #239: fixes pushed and CI is green.** The head moved from `aebfdf39` to `44215036` in four follow-up commits. CI reports 2 of 2 runs passing, but this host's token can't read the status rollup, so that comes from the Actions runs API, and commit statuses and non-Actions checks weren't visible. I ran `ci-wait-merge.sh` with a 540s deadline instead of the 3600s in the spec, because of the tool limit; it reached green before the deadline.

**Applied (latest panel verdict, review 5765466277):**
- **Locator check (breaker 1, 4; corner-prober 1, 3; transplanter 1):** `isInvitationLocator` now matches the raw string against the exact form the daemon prints. `namesNode` compares the raw `endo://<node>/` prefix. Userinfo, ports, case variants, percent-encoded hosts, extra or repeated query keys, fragments and trailing slashes are all refused.
- **Faults vs refusals (breaker 2):** only `InvitationSpentError` and the daemon's listed refusals now answer 404. Any other fault answers a fixed 503 that doesn't echo the locator; guest-state errors still answer as themselves. The daemon raises plain errors, so refusals are matched by message in `isDaemonInvitationRefusal` (`src/web/local-invitations.ts`).
- **New tests (corner-prober 1–6):**
  - host, query and path corner cases, and the 4096/4097 server length cap
  - the 4089/4090 browser pattern boundary, plus empty, whitespace and newline locators
  - `null`, `""` and array request bodies
  - empty and repeated `locator=` in the fragment
  - a concurrent redeem by two guests against a real daemon (one 200, one 404)
- **Docs (releaser 1):** the changeset is cut to the user action, and the design doc now states the locator form and the 503.

**Where I departed from the panel:**
- **Breaker 1's literal fix would have broken every real locator.** It asked for no `@` or `%` in the path and `type` as the only query key. At the pinned Endo (`1706e632`), `locate()` always adds `from`, sometimes `fromNode`, and adds hints when the daemon has network addresses, and `acceptInvitation` refuses a locator with no `from`. The grammar therefore allows those fields and validates them strictly.
- **Breaker's open question about hints is settled.** The daemon only registers hints when the locator names a different node. A new real-daemon test redeems a locator for this daemon with an unroutable hint added and gets a 200. The no-dial claim rests on that source guard, because the test doesn't observe dialing directly.
- **Corner-prober's concurrent test goes beyond the ask.** I ran it against the real daemon, since a mock couldn't show the race.
- **Not changed:** transplanter 2 (comment-only) asked for a named constant behind the browser's 4089 limit. The new boundary tests pin that limit instead.

**Verification:**
- **Unit and type checks:** targeted vitest files passed: `guest-web-http` (after the final edit) and `guest-web-socket-faults`, `home-page`, `endo-invite-tools` (before the last refusal-list edit). `tsc` was also last run before that edit.
- **Real daemon:** `test/web/guest-web-daemon.test.ts` passed 8 of 8 against a local build at the Endo pin. It caught one refusal message I had guessed wrong, which I corrected to `No formula exists for number`.
- **Lint:** ESLint did not run. `npx eslint` stopped on a config-format error, and `npm run lint --if-present` showed no results.
- **Beyond that:** the full `npm test` suite ran only in CI.

**Follow-up:** a future Endo pin bump that rewords a refusal would turn that 404 into a 503. The real-daemon tests cover the spent, forged-number and undecodable-hint messages, so they would fail on such a bump. `Invalid locator` is only tested with a fake error, because the new grammar stops those locators before they reach the daemon.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr239-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (2169965 cached reads)
- Output: 31060 tokens
- Cost: $2.060049
- Wall-clock: 833s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
