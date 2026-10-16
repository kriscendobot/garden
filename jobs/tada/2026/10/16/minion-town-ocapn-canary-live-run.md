---
handed-off: minion-town-ocapn-canary-live-run-2
deliverable-complete: false
---
## Completion report: minion-town-ocapn-canary-live-run

**Outcome: blocked, handed off.** The live canary could not run because production minion.town won't hand out guest locators yet. `GET /account/guest-locator` answers `404 Federation is not enabled`. Guest-locator federation is built but not activated (DEPLOYMENT.md, "Guest-locator federation"). Turning it on waits on a security release gate: the peer-gateway authority fix, the advertised-address setting in Endo, and endojs/endo-but-for-bots#1124 and #1333 merged. The orchestration `endo-minion-town-guest-locator-federation` owns that, and I did not try to enable it.

**What I did**
- **PR state:** https://github.com/kriscendobot/minion.town/pull/193 is already merged (merge `51ad067` on `main`). The canary is now `deploy/probe/ocapn-canary.mjs` on `main`. I checked the guests-file shape it reads, so the successor can fill it in correctly.
- **Guest creation (maintainer override):** I signed in with a disposable Playwright profile using "Continue with Ethereum" and a freshly generated wallet key that was never stored. Sign-in completed end to end with no human step and no real credential. The only blocker is that the locator route itself is closed.
- **Leftover accounts:** two throwaway accounts now exist on prod and were abandoned:
  - an anonymous guest, created when I tested `POST /api/guest`;
  - one Ethereum-login account, whose key is gone.
- **Secrets:** no locator was ever obtained, printed or stored. `~/.garden-state/ocapn-canary/` exists (0700) and is empty, and the temporary tooling is deleted.
- **Missing tool:** the `endo` CLI is not on PATH on `endolin-garden-ece02cb4`, so the canary could not have run here today anyway.

**Handoff**
- **Successor job:** `minion-town-ocapn-canary-live-run-2` is parked, blocked on `endo-minion-town-federation-live-acceptance` (the last step of the federation orchestration). It carries the maintainer's override, the working sign-in recipe, a note to install an `endo` CLI with `adopt-locator`, and both remaining tasks: the live run with acceptance evidence on #193, and the Claude-operated guest leg.
- **Maintainer:** I sent a message explaining the blocker and the abandoned accounts, and asking whether they want a different guest source to get the canary sooner.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-ocapn-canary-live-run.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1718005 cached reads)
- Output: 11182 tokens
- Cost: $1.1230890000000002
- Wall-clock: 198s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
