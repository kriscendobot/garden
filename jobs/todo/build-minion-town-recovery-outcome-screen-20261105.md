---
role: builder
tier: mentor
posted_at: 2026-11-07T11:23:28Z
handler-timeout: 3600
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-07T15:42:28Z cleared=none -->

---
role: builder
tier: mentor
posted_at: 2026-11-05T22:13:16Z
handler-timeout: 3600
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-07T09:27:03Z cleared=none -->

---
role: builder
tier: mentor
posted_at: 2026-11-05T21:03:18Z
handler-timeout: 3600
token-budget: 250000
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-11-05T21:46:57Z cleared=none -->

---
posted_at: 2026-11-05T20:40:38Z
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Give a failed guest recovery its own clear screen on minion.town** (maintainer experience report, kriskowal, 2026-11-05).

**What happened.** He deleted his guest on https://minion.town/, then tried to recover by signing in with GitHub (the `kriskowal` bond). The flow returned him to the sign-in page, and the "No guest is bonded to that sign-in." message did not appear until he reloaded. He arrived back at the wait-list sign-up sheet and felt lost.

**Where it comes from.** `deploy/aws/www/home.js` (about lines 420-440): when `parsed.recover` is set, `resolveGuest` calls `api('/account/guest-recovery')`; on a non-deletion-pending failure it calls `say('waitlist-status', 'No guest is bonded to that sign-in.', true)`. That writes into the waitlist splash's status element, and the later `land()` / `showCard(...)` flow then shows the splash, so the message is either written before the card exists, hidden, or overwritten, and it is a one-line note on a card about something else (the wait list).

**Do:**
1. **Reproduce** it with the real-daemon + Playwright recipe (delete a guest, sign in via a recovery bond that has no guest, observe). Find the actual reason the message is missed (ordering, the status element hidden, a reload race) and fix it, with a regression test that fails first.
2. **Make the outcome a stand-alone screen,** not a status line: a dedicated card (same card system as `splash`/`invitation`/`deletion-pending`; see `landingMode` and `showCard`) that says plainly what happened ("We signed you in with GitHub, but no minion.town guest is attached to that sign-in"), what the person can do next (join the wait list, redeem a coupon/invitation if they have one, try another sign-in provider, contact), and why they are seeing it. It must be reachable only for the failed-recovery case, must not leak whether any particular guest exists beyond what the sign-in already proves, must be keyboard and screen-reader friendly (focus moves to its heading, `aria-live`), and must survive a reload sensibly (the address bar is cleared, so persist the outcome in session storage for that one view, or re-derive it, so it neither vanishes nor sticks).
3. **Review the neighbouring failure paths** in the same function for the same "arrives somewhere unexplained" problem (deletion pending, guest unavailable: `Your guest is unavailable right now. Reload to try again.`, a rejected credential, an expired invitation) and give each a clear, calm explanation. Do not rewrite the shell; keep this scoped to the landing page.
4. Deploy and verify in production with Playwright; do not mutate real account data (use a dedicated test principal or a throwaway guest). Record screenshots of the new screen in the PR.

Repo: kriscendobot/minion.town (base: current main). Maintainer evaluates production results, not diffs (review inversion). The wait list itself was just provisioned (see below), so the join-the-wait-list action on the new screen must work in production; verify it end to end.

**Context already handled by the liaison (do not redo):** "wait list not available" was a missing DynamoDB table; `deploy/aws/scripts/deploy-waitlist-store.sh` had never been run. It was run on 2026-11-05, and `POST /api/waitlist` now returns 202. A probe row was inserted and deleted. Add a production smoke check for `/api/waitlist` to the deploy probe (`deploy/probe/prod-objectives.mjs`) so a missing store fails the deploy loudly instead of surfacing as "unavailable" to a visitor, and make the splash's error text say the list is temporarily unavailable and how to retry, not a bare "not available".

<!-- garden-annotation: key=78d1671abec4 by=producer at=2026-11-05T21:14:43Z -->

COPY CHANGE (maintainer 2026-11-05): never use the word 'resident' in visitor-facing text; use 'guest'. Any new recovery/landing copy says guest. The sibling job build-minion-town-waitlist-soon-page-20261105 changes the existing splash strings; stay consistent with it. Internal role value 'resident' is not renamed.

<!-- garden-transient-elapsed: kind=exit0 through=0 values=1175 -->

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-07T16:13:04Z -->
