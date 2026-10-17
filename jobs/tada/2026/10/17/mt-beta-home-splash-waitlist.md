# mt-beta-home-splash-waitlist: completion report

`https://minion.town/` is now one public landing page, with a closed-beta splash and a waitlist. Draft PR **https://github.com/kriscendobot/minion.town/pull/198** (1 commit, head `feat/beta-home-splash-waitlist`, frozen base `main-bda7739`) is mergeable and all CI is green (test, Claude harness amd64 and arm64). No production admission setting was changed.

## The two pages, and what replaced them
- **Before:** `/` served the public guest shell (`guest.html`). The "home" link went to `/index.html`, the clip shell behind the OAuth login.
- **Now:** `index.html` is the only landing page and is served publicly at `/`. A new script, `home.js`, finds the visitor's guest the same way the old guest shell did: the `#v=1&guest=` link, then the credential saved in the browser, then the OAuth recovery bond on `#recover=1`. It then shows:
  - **a guest:** the clip shell. The guest panel from `guest.html` (copy guest URL, forget this browser, invitations, mail, add a recovery provider) moved into the settings overlay.
  - **an invitation link:** an accept-invitation card.
  - **anyone else:** a closed-beta splash with a waitlist form and no way to create a guest.
- A credential that arrives in the link is saved and removed from the address bar straight away. "Copy guest URL" rebuilds the link from the saved credential.
- `/index.html`, `/guest.html` and `/shell.html` now redirect (308) to `/`, and old guest and invitation links keep working through the redirect. Those three files are deleted. OAuth callbacks, `/mcp`, `/api/guest*`, `/account*`, `/billing/*` and `connect.html` are unchanged.
- Because the landing page is public and holds a credential, `/` now sends a strict content security policy. The one inline frame-bust script is allowed by its hash, and a test fails if the script and the hash drift apart.

## Waitlist
- **Endpoint:** `POST /api/waitlist` validates the address and normalizes it (trim, lowercase). It returns the same 202 answer for a new address, an already-listed address and a honeypot hit, so it never reveals who is on the list.
- **Limits:** 5 submissions per hour per network (/24 for IPv4, /48 for IPv6). No email is sent or verified.
- **Storage:** DynamoDB table `minion-town-waitlist` holds only the address, signup time, an expiry 365 days out that deletes the row automatically, and a short hash of the coarse network.
- **Provisioning:** `deploy-waitlist-store.sh` creates the table and lets the app only add rows.
- **Export and deletion:** `npm run waitlist -- list [--csv]` and `npm run waitlist -- remove <email>`, run with the fleet admin credentials.
- Retention and deletion are written up in `designs/closed-beta-waitlist.md` and `DEPLOYMENT.md`.

## Evidence
- **Real browser:** headless Chromium against the dev demo server, with the production security policy applied to `/`:
  - The splash appears with no create-guest control.
  - Submitting the same address twice in different case gives the same message and stores one row; a bad address is rejected; the honeypot stores nothing.
  - A guest URL opens the shell, removes the credential from the address bar and survives a reload.
  - An invitation created in the overlay was accepted in a fresh browser, and mail went through between the two guests.
  - All three old URLs redirect into the shell with the guest link intact.
  - "Forget this browser" and a dead saved credential both fall back to the splash.
  - There were no security-policy violations at load, and an injected inline script was blocked.
- **Full app:** the real app serves `/api/waitlist`.
- **Checks:** typecheck is clean. Locally, one existing test (`test/git-remote/capability.test.ts`), which this change doesn't touch, failed on this host; it passes in CI. New tests: `test/waitlist.test.ts` (23) and `test/home-page.test.ts` (22).

## Maintainer follow-ups (also in the PR body)
1. **Before merging,** run `deploy/aws/scripts/deploy-waitlist-store.sh` once as the fleet admin; merging deploys automatically. Until the table exists the waitlist returns 503, though the splash still loads.
2. **OAuth accounts with no recovery bond, likely including yours, will land on the splash.** I didn't make sign-in fall back to `/account/guest-formula-id`, because that endpoint creates a guest for any admitted account. One-time fix: open `/account/guest-formula-id` while signed in, visit `/#v=1&guest=<id>`, then choose "Add a recovery provider".
3. **Choices for you to approve or change:** accepting an invitation still creates a guest (the coupon job will gate it); addresses are lowercased for dedupe; a shared office or campus network shares the 5-per-hour limit; mail and invitations sit in the overlay unchanged for now, for the settings-simplify and chat-clip jobs to reshape.
4. **Follow-up:** without an OAuth session the shell's clip list is empty, because `/account/clips` looks clips up by OAuth account, not by guest. A guest-based clip list is a separate job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/mt-beta-home-splash-waitlist.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 178 tokens (13807928 cached reads)
- Output: 79929 tokens
- Cost: $6.1317336
- Wall-clock: 1605s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
