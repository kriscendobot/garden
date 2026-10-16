---
gate: blocked
blocked_on: endo-minion-town-federation-live-acceptance
priority: normal
posted_by: builder
posted_at: 2026-10-16T22:12:34Z
---

---
role: builder
requires: host=endolin-garden-ece02cb4
pr: https://github.com/kriscendobot/minion.town/pull/193
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Live run of the minion.town OCapN guest canary (resumes minion-town-ocapn-canary-live-run)

Successor of `minion-town-ocapn-canary-live-run`. That attempt stopped for one
reason: production minion.town answers `GET /account/guest-locator` with
`404 Federation is not enabled` (checked 2026-10-16). Guest-locator federation
is built but not activated (DEPLOYMENT.md, "Guest-locator federation").
Activating it waits on the release gate (the peer-gateway authority fix, the
advertised-address setting, and merged #1124/#1333), which the
`endo-minion-town-guest-locator-federation` orchestration owns. This job stays
blocked until that orchestration's last child,
`endo-minion-town-federation-live-acceptance`, is done.

PR #193 is MERGED (merge 51ad067 on minion.town `main`), so the canary is
`deploy/probe/ocapn-canary.mjs` on `main`. Use a project worktree of `main`.

Work, on `endolin-garden-ece02cb4` (the host the design calls `endolin-garden1`):

1. Get two guest locators. MAINTAINER OVERRIDE 2026-10-16 (kriskowal, liaison
   session; journal message 20261016T143222Z-7b8d25 and the annotation on the
   predecessor job): you may create two throwaway guests yourself. Mechanics
   proven in the predecessor run: in a disposable Playwright profile, open
   `https://minion.town/oauth2/sign_in?rd=%2Faccount%2Fguest-locator` and pick
   "Continue with Ethereum". Inject a `window.ethereum` (`eth_requestAccounts`,
   `personal_sign`) backed by a FRESH viem `generatePrivateKey()` that is
   never stored. siwe-idp.minion.town's "Connect wallet & sign in" button
   completes the flow back to minion.town with no human step. Then
   `GET /account/guest-locator` with the context's cookies. Discard the profile
   and the key. Do this twice. Write both locators to
   `/home/kris/garden/.garden-state/ocapn-canary/guests.json` (directory 0700,
   file 0600) in the shape the canary's header comment documents. NEVER print,
   log, commit, or paste a locator. If guest creation is locked down by then,
   or needs any credential you do not have, STOP and message the maintainer.
2. Make sure an `endo` CLI with `adopt-locator` is on PATH on this host (it was
   absent on 2026-10-16). Run `node deploy/probe/ocapn-canary.mjs` by hand and
   record the result. This checks the live adopt shape, the `endo eval`
   endowment and output form, `E(guest).evaluate("@main", ...)` for the inert
   probe, and `endo net ensure ocapn`. Fix the canary where the live surface
   differs (new minion.town PR via ensure-pr.sh), and post the token-free audit
   record on #193 as acceptance evidence.
3. Add the Claude-operated guest leg (design #191 Section 6, "Several guests";
   `designs/root-canary-reader-identity.md`).
