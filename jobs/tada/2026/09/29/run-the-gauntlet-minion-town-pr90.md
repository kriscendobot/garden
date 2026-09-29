PR #90 is already done. On 2026-09-04 the maintainer (kriskowal) commented "Please conduct" and "And, deploy". The conductor job `kriscendobot-minion.town-pr90-c713f8f2` then took the PR out of draft and merged it at my fix head `fb9f7d9`, as merge commit `2e63b45e` at 22:45Z. The deploy that followed is confirmed on the PR, along with a completion receipt. There was nothing left for me to do, so I made no further changes on this resume.

**What I did in the earlier attempts:**
- **Panel round 1** (29 seats, single-round mode): the verdict was **must-fix**. All the findings I acted on were real problems inside this PR's scope, not the deferred § 6 items.
- **Fix commit `fb9f7d9`**, pushed to `build/clip-shell-framework`:
  - `deploy-www.sh`: a file name was placed unquoted into a script run as root over SSM. I now quote it and reject names outside `[A-Za-z0-9._-]`. A file too big for one SSM command now fails with its name. HTML files deploy last so a page's script is in place before the page. The comment explains that a failed deploy can leave the files half-updated and that re-running fixes it.
  - `shell.html`: the settings layer (`#chrome`) now has its own `position` and `z-index`. Before, it stayed above the clip frame only because of its place in the page, so a later z-index on the main pane could have let a clip draw over it. I also dropped `viewport-fit=cover`, honoured reduced motion, and stopped the backdrop catching clicks while it closes.
  - `shell.js`:
    - The unused live-`src` path is removed, so a live origin cannot be framed at all.
    - A new clip's position is now one past the highest existing one; after a dropped record it used to collide with an existing clip.
    - The settings overlay now keeps Tab focus inside it and returns focus to the button on close.
    - Clip ids are limited to 63 characters, the DNS label limit.
    - The Ctrl/Cmd+1–9 shortcut uses physical keys, so it works on non-US keyboard layouts.
    - "Signed in" stays hidden until the account lookup succeeds.
    - The gutter is set up before the overlay, so a missing overlay element can't leave a dead gutter.
  - Docs:
    - `DEPLOYMENT.md` and design § 8 no longer claim "no Caddy change"; they now say a shell change must also run `deploy-caddy.sh`.
    - The Caddy comment is narrowed to the static pages it actually covers.
    - The design's § 4 z-index claim is corrected.
    - Open question #2 is marked decided for the static pages. Protecting the sign-in page from being framed stays open.
    - Stale `frameConfig` and `src/account/router.ts` references are fixed.
    - The unrelated character churn in the secrets tables is reverted.
  - Tests: 13 new tests, 336 passing. They include checks that fail if the anti-framing header or the in-page frame-bust is deleted. Before this, both could be removed without any test failing.
  - Typecheck and pre-push gates passed.
- **Redeployed** the review surface with `deploy-www.sh`. The live `/shell.html` returned 302 to sign-in and sent `frame-ancestors 'none'` and `X-Frame-Options: DENY`.
- **Panel round 2**, against `origin/main` so it covered the whole PR, was cut off when the earlier session was reaped. No second panel verdict was ever recorded. The PR went out of draft through the maintainer's direct conduct request, not a clean panel pass.

**Follow-ups** (tracked in the design's Open questions and code comments):
- Add the anti-framing headers to the site as a whole, so the `/oauth2/*` sign-in page is protected too (Open question #2).
- Replace the file-by-file deploy with one staged switch-over (noted in the `deploy-www.sh` comment).
- The existing § 6 deferred items: live `*.ocap.site` framing, a shared `account.js`, account-scoped clip storage, canonical base32 ids, and reconciling the clip-id model with #85/#88.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/run-the-gauntlet-minion-town-pr90.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s) (1 unmetered)
- Input: 6 tokens (534207 cached reads)
- Output: 2141 tokens
- Cost: $2.1579973999999997 (1 engagement(s) unpriced)
- Wall-clock: 2433s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
