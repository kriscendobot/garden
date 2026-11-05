---
posted_at: 2026-11-05T21:13:08Z
role: builder
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: builder.** **Wait-list sign-up advances to a thank-you page at `https://minion.town/soon`** (maintainer, kriskowal, 2026-11-05).

**Behavior asked for.**
- After a successful wait-list sign-up (`POST /api/waitlist` returns 202), the visitor moves to a thank-you landing page at **`/soon`**, not a note on the sign-up card. They are never shown the sign-up form again straight after signing up.
- The `/soon` page offers two ways on: **"Sign up with another address"** (returns to the sign-up form, empty) and **"Already a resident?"** (the same sign-in-to-recover path the splash has today: `deploy/aws/www/index.html` line ~423, `/oauth2/start?rd=/%23recover=1`), for someone who missed it before signing up.
- `/soon` must work as a real URL: reloading it, bookmarking it, and the back button behave sensibly. A visitor who opens `/soon` directly without having signed up should still get a calm page (a short "we are letting people in gradually" message with the same two choices; do not claim they are on the list). Do not put the visitor's email address in the URL, history state, or any log; if the page echoes anything, take it from session storage for that one view and never show another person's data.
- Routing: `/soon` is currently not a route. Make the landing page (`deploy/aws/www/home.js`, `index.html`, the Caddy config, and the app's static serving) serve it, verify the deploy order in `DEPLOYMENT.md` § Closed-beta waitlist, and make sure `/soon` is excluded from any redirect that sends logged-in or invited visitors elsewhere.
- Keep the card system consistent with the existing cards (`splash`, `invitation`, `deletion-pending`; `landingMode` / `showCard`), keyboard and screen-reader friendly (focus moves to the heading, `aria-live` for transitions), with the failure case kept on the form: a 503 or network error shows a calm retry message on the form and does NOT advance to `/soon`.

**Coordinate with the sibling job `build-minion-town-recovery-outcome-screen-20261105`.** It reworks the same file (`home.js`), adding a stand-alone screen for a failed guest recovery and a production smoke check for `/api/waitlist`. If its PR is open, stack on it; if it has merged, build on main; do not duplicate its work or fight its changes. The two screens should read as one family (same layout, tone, and button styles).

**Context.** The wait list itself was provisioned on 2026-11-05 (the DynamoDB table `minion-town-waitlist` had never been created; `POST /api/waitlist` now returns 202). Do not touch real waitlist rows: tests use a stubbed store, and the production check posts a clearly fake address (`…@example.com`) and removes that row afterwards using the garden-fleet admin credentials only if you have them; otherwise verify the redirect with a stubbed response and leave production data alone.

Repo: kriscendobot/minion.town (base: current main). Test with the real-daemon + Playwright recipe: covering sign-up success, failure, direct `/soon` open, reload, back button, "Sign up with another address", and "Already a resident?". Deploy and verify in production; record screenshots in the PR. Maintainer evaluates production results, not diffs (review inversion).

<!-- garden-reaped: 1 -->
<!-- garden-plain-retry-not-before: 2026-11-05T21:33:14Z -->
