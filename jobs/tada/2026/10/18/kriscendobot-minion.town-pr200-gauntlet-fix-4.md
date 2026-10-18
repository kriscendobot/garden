Fix round 4 for kriscendobot/minion.town PR #200 is pushed and CI is green (3 of 3 checks passed). Commit `c6fa6883` was added on top of `f26ce020` on `feat/beta-settings-simplify`.

The round-4 panel review (5562329804) had three request-changes seats. Here is how each was handled:

- **Breaker, finding 1 (the deletion tombstone claims too much):** I took the reviewer's "narrow the claim" option rather than revoking invitations and peers on deletion. `designs/closed-beta-waitlist.md` § Settings menu and the header of `src/web/deleted-guests.ts` now say the tombstone refuses the bearer on every guest web route, not every route. Both now also say it is enforced only around the guest web router. Invitations the guest already issued (Connect CLI) and peers it already has can still reach the retained guest data over the OCapN routes until `ENDO_GC` is on.
- **Surfacer, finding 1:** `DEPLOYMENT.md` now lists `settings.js` among the served landing modules. I also did the related follow-up: the file list in `designs/clip-shell-framework.md` §8 now includes `home.js` and `settings.js`.
- **Pruner, findings 1–5:**
  - The settings-menu contents now live only in the design. `DEPLOYMENT.md` links to § Settings menu instead of repeating them.
  - The reason the app refuses to start without the fingerprint index is cut down in `src/http.ts` and in `DEPLOYMENT.md`; `http.ts` now points to `DEPLOYMENT.md` § Open self-signup.
  - I removed the change-history item from the design's "Choices for the maintainer to veto" list.
  - I deleted the five test comments that restated the assertion below them, including the borderline "Deleting again…" one, and the `confirmationMatches` comment in `settings.js`.
  - I dropped the repeated first sentence of the `unbondRow` comment in the DynamoDB store, keeping the part about re-bonds and the index backfill.

Before pushing I ran the type check, which was clean. The settings, home-page and guest-settings tests passed (43 tests). The 3 `guest-web-daemon` tests were skipped locally, so a real daemon run did not check those.

Follow-ups:
- The tombstone gap itself is still open: deleting an account does not revoke the guest's invitations or peers. It is now documented, not fixed. A follow-up should either revoke them in `deleteGuest` or turn on `ENDO_GC`.
- The surfacer's other notes were optional and not done: marking test-only exports in the `settings.js` header, and a test that checks the Caddy `@landingScripts` list against `deploy/aws/www/*.js`.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1369071 cached reads)
- Output: 8446 tokens
- Cost: $1.0114461999999997
- Wall-clock: 959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
