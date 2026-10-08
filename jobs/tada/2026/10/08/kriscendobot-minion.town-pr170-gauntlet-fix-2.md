I pushed fixes for all five of panel round 2's must-fix items on kriscendobot/minion.town#170 (new head `c3bc2f4`), and CI is green: all 3 checks passed.

**What changed (four follow-up commits on top of `f999de8`):**

1. **Hostile link replacing the stored guest (login CSRF).** A link guest still waits in the `pending-guest` slot until the server accepts it. If a *different* guest is already stored, the shell now keeps showing the stored guest and asks whether to switch. The pending record survives reloads until the user picks "Switch to the linked guest" or "Keep this browser's guest". Creating or recovering a guest over a different stored one also asks first. The code comment and design § 4.1 are corrected. New browser tests cover both answers, with the server *accepting* the foreign guest while another is stored.
2. **A 401 for something that isn't a bad credential.** The server now returns 401 only when the daemon reports the identifier unknown. I matched the daemon's own error messages for that ("No formula exists for", "Unknown identifier", and the identifier-parse errors). A CapTP disconnect or any other daemon fault now returns 503. The cached daemon connection is dropped when it closes, so the next request reconnects. The browser now deletes a stored guest only on a 401. New tests: the HTTP route returns 503 when the backend throws a non-credential error, plus a classifier test.
3. **Invalid or failed link offering "Create a guest" over an existing guest.** On `?invalid-fragment=` or `?capture-error=1`, the shell still shows the error but also renders the stored guest, so the "Create a guest" section stays hidden. Browser test added.
4. **Encryption-key race.** The key is now read and, if missing, added in a single IndexedDB transaction, so two first-visit tabs end up with the same key. A record that won't decrypt reads as absent instead of making every load fail. A browser test runs two concurrent first writes and checks both records read back.
5. **Leftover `guest.html` wording.** `DEPLOYMENT.md`, `deploy/aws/www/index.html` and `designs/clip-shell-framework.md` now describe the bootstrap → shell split. `DEPLOYMENT.md` and design § 4.1 document the `@guestShellAssets` route and its CSP.

I also did three of the should-fix items:
- The legacy-storage migration runs after the link is captured, can't fail the capture, and never overwrites a stored guest.
- The in-memory guest ID is restored if adopting a link guest fails.
- Each record is encrypted with its slot name as authenticated data, so a record can't be moved between slots.

I didn't change the two inline scripts, so the CSP hashes are unchanged.

**Local checks:** typecheck is clean. All 10 browser tests pass. `npm test` has one failure, `test/git-remote/capability.test.ts`, which also fails with my changes stashed. I couldn't run the real-daemon suite (`guest-web-daemon.test.ts`) locally because it needs an Endo checkout; CI covers it, and it passed.

**Should-fix items still open (not blocking):**
- Captured invitations have no expiry.
- `src/web/invitation-session.ts` and its tests still implement the superseded model and should be deleted or wired in.
- Server code imports the parser from `deploy/aws/www/`; it could live under `src/` and be copied out at build.
- `locator-fragment.d.ts` names `Storage` without the DOM lib, and the 128-character label limit is declared in two places.
- § 4.1 doesn't cite the 2026-10-08 maintainer request that authorized the change, because I couldn't verify it. It now cites #56.
- No completion-summary comment, and the earlier fix-up commits aren't squashed.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (3859391 cached reads)
- Output: 27960 tokens
- Cost: $2.2303422000000004
- Wall-clock: 750s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
