---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-11-05T08:59:12Z
job: fu-minion-town-older-draft-triage-20261105-1
claim: 288f698ce1d44ca5
---
The current landing-page defect reproduced and is fixed in draft PR https://github.com/kriscendobot/minion.town/pull/252 at `755d017997d34c46348938764d9628bb30492d00`.

- Reproduction: the new real-Chromium browser check failed before the fix: after changing the already-open landing page to `#v=1&guest=...`, the splash remained and the bearer stayed in the URL. This is the same fragment-only, same-document navigation defect identified in older draft PR #129.
- Change: `home.js` now reloads on `hashchange`, allowing normal startup to validate, store, and scrub the guest credential. `history.replaceState` cleanup paths do not emit `hashchange`, so they do not loop. The clip-frame browser gate now retains this same-tab recovery case.
- Verification: `pre-push-gates.sh --summary --base-ref origin/main .` passed all 12 stages (including build and typecheck); `npx vitest run test/home-page.test.ts` passed 41/41; the real Chromium gate passed 31/31, including the new rendered-DOM recovery check. Before the fix that check failed with the credential still in the URL. The full Vitest suite made extensive passing progress but was stopped after it ceased producing output; it is not claimed as passed. GitHub's five CI checks remained queued behind the single busy self-hosted runner after a bounded foreground wait.
- Follow-up: PR #252 remains draft on frozen base `main-7a0bcc9`; CI is queued.

Self-improvement: nothing this time.
