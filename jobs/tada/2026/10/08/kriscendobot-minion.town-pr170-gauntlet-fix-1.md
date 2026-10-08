I applied all four of the panel's must-fix items to PR #170, pushed them as four follow-up commits (`143a624` → `f999de8`), and CI is green (3/3 checks, `ci-wait-merge` rc 0).

**Must-fix items applied**
1. **CSP hashes.** The old hashes left out the newline that the browser keeps after `<script>`, so both inline scripts would have been blocked. I recomputed both hashes in `minion-town.caddy`. The `guest-shell.html` hash matches the one the panel computed. The `/` hash is new (`pcLN…`) because the bootstrap script also changed (item 5).
   - `locator-bootstrap.test.ts` now hashes the exact text between the tags and checks that it starts with the newline.
   - The Playwright test server now sends the CSP headers parsed from the Caddy file. I swapped the old hash back in and the leak-canary test failed, so a stale hash now fails in a real browser.
2. **A startup error no longer deletes the only copy of the guest.** `start().catch` used to delete the stored guest on any error. Now the stored guest is removed only when `/api/guest` answers 401, 403 or 404. Network faults, 5xx responses and storage or decryption errors leave it in place.
3. **A guest from a link must be verified before it replaces the stored one.** `captureLocatorFragment` now writes it to a separate `pending-guest` record.
   - If the server accepts it, it becomes the stored guest.
   - If the server rejects it, the pending record is dropped and the existing guest is untouched.
   - There are new Playwright tests for a wrong guest link and for a 503 response.
4. **Design doc.** I added §4.1 to `designs/invitation-only-guest-onboarding.md`, covering the bootstrap scrub, encrypted storage, the pending slot, and the delete-only-on-rejection rule. I also marked the older parts that §4.1 replaces (the routes table, §4, §5's recovery text, build gate 7, and the file map).

**Should-fix items I also took because they were cheap**
5. The bootstrap now forwards the old `/#recover=1` OAuth return to `?recover=1`, with a browser test.
6. `?invalid-fragment=` only displays known reason codes; anything else gets generic text.
7. One shared kind check now covers store, load and remove.
8. Copying the guest URL passes `guestUrl.href` instead of the URL object.

**Local checks:** typecheck passes and all 6 browser tests pass. `npm test` had 937 passed and 1 failed. The failure is `test/git-remote/capability.test.ts › propagates a git failure`, which is in a file this PR doesn't touch and matches an existing failure on this host.

**Should-fix items left for later:**
- The race where two first-visit tabs can each create the encryption key (use `add`, then re-read on conflict).
- Saved invitations never expire.
- Browsers without IndexedDB or WebCrypto (private mode) lose the credential after the scrub.
- The parser constants are duplicated between `locator-fragment.js` and `invitation-envelope.ts`.
- Leftover references from the `guest.html` rename, including the stale `src/web/invitation-session.ts`.

I didn't re-run the panel; the driver posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2320254 cached reads)
- Output: 17688 tokens
- Cost: $1.5247228
- Wall-clock: 481s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
