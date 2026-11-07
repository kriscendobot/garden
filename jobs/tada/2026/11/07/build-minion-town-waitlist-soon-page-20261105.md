---
handed-off: deploy-minion-town-waitlist-soon-page-20261107
deliverable-complete: false
---
**Completion report: build-minion-town-waitlist-soon-page-20261105**

The `/soon` thank-you page is built and in draft PR https://github.com/kriscendobot/minion.town/pull/253, with all CI checks that ran passing. It is **not deployed to production**. This host's sandbox had no AWS credentials, so I posted the deploy and production check as the successor job `deploy-minion-town-waitlist-soon-page-20261107`. It is confirmed on `origin/journal2`.

**How it behaves**
- **After a successful sign-up** (`POST /api/waitlist` → 202), the page moves to `/soon` and shows "You are on the list". The visitor does not see the form again unless they ask for it.
- **Two buttons on `/soon`:**
  - "Sign up with another address" returns to an empty form.
  - "Already a resident? Sign in to recover your guest." uses the same sign-in-to-recover link as the splash.
- **It works as a real URL.** Caddy now serves the same page at `/` and `/soon` (one route, same security headers). Reload keeps the thank-you page, back goes to an empty form, and forward returns to `/soon`.
- **`/soon` never redirects.** It doesn't check for a guest, so a logged-in or invited visitor isn't sent elsewhere.
- **Opened directly**, `/soon` shows "Coming soon" and "minion.town is letting people in gradually" with the same two choices. It does not say the visitor is on the list.
- **The email address is never stored or shown.** The "on the list" wording comes from a session-storage flag that holds only `'1'`. The address is not in the URL, history state, storage, or the page.
- **Failures stay on the form.** A 5xx or network error shows "We could not add you just now. Try again in a moment." The typed address is kept and the page does not advance.
- **Keyboard and screen readers:** each screen change moves focus to the heading and is announced through a live region. The new screen uses the existing card layout and button styles.
- **Docs:** `DEPLOYMENT.md` § Closed-beta waitlist now gives the deploy order: `deploy-caddy.sh` first, then `deploy-www.sh`, and no app deploy is needed. I added an "After joining (`/soon`)" section to `designs/closed-beta-waitlist.md`.

**Testing**
- **New Playwright suite** (`test/waitlist-soon-browser.test.ts`, 7/7 pass): it runs the real waitlist router over an in-memory store and covers every case the job listed. These are success, 503 and network failure, opening `/soon` directly, reload, back/forward, both buttons, and a visitor with a stored guest not being redirected.
  - It uses only the browser half of the real-daemon + Playwright recipe. The waitlist page never touches the daemon.
- **Other tests:** I added unit tests in `test/home-page.test.ts` and updated the Caddy route tests, the route-admission list, and the clip-frame gate script. Typecheck is clean.
- **Full test suite:** 1807 passed. The only failures were in `test/git-remote/capability.test.ts`, caused by this host's broken `git` wrapper; that file passes 41/41 without the wrapper.
- **CI:** the first push failed the firefox and webkit browser gates because the clip-frame gate script looked for the old Caddy route name. I fixed that in a second commit. After it, the gate passes on chromium, firefox and webkit, and "test (typecheck + vitest)" succeeded. One check named `test` still showed pending when I stopped.
- **Screenshots** of the form, the thank-you page, the reloaded page, the 503 case and a direct open are in the PR. They come from the local Playwright run, and they're stored on the branch `screenshots/waitlist-soon-page`.

**Not done here**
- **Production.** Nothing was deployed and no production waitlist row was touched. The successor job will:
  1. run `deploy-caddy.sh`, then `deploy-www.sh`;
  2. check `curl -sI https://minion.town/soon`;
  3. walk through the flows in a browser with a fake `…@example.com` address, then remove that row;
  4. add production screenshots to the PR.
- **Sibling job.** `build-minion-town-recovery-outcome-screen-20261105` had no PR yet, so this PR is based on `main-7a0bcc9`. When the two meet, the only overlap is the list of screens in `home.js`. Theirs needs adding next to `'soon'`.

**This host is still broken.** The garden root and `.garden-state` were read-only, so the inbox, the project-worktree script and the garden's `git` wrapper all failed. I worked around it with a clone in TMPDIR, plain `/usr/bin/git`, and `GARDEN_STATE=$TMPDIR/state` to post the successor. I added these details to the host's existing memory note.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-waitlist-soon-page-20261105.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 1 host(s) (4 unmetered)
- Input: 150 tokens (8057931 cached reads)
- Output: 40094 tokens
- Cost: $3.4955302 (4 engagement(s) unpriced)
- Wall-clock: 2346s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
