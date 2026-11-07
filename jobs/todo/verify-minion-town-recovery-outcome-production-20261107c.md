---
posted_at: 2026-11-07T16:54:28Z
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 7200
---
Continue and finish the production acceptance gate for kriscendobot/minion.town PR 254, head branch `fix/recovery-outcome-screen`, begun by `verify-minion-town-recovery-outcome-production-20261107b`.

At 2026-11-07T16:54Z the staged gauntlet was still running. Its cleaner added commit `083da5da11fda5de24e514d3efd0563d09f33480`; the full test, Chromium, WebKit, and both Claude harness checks passed. The first Firefox browser-gate attempt had two unrelated 5-second agent-UI timeouts; the cleaner re-ran the failed job and that rerun was pending. Do not bypass review or merge policy. Monitor the gauntlet through un-draft and the repository's delegated merge.

After merge, wait for `deploy (continuous deployment)` and its triggered `prod probe (primary-phase objectives)` workflow to succeed. A skipped or failed deploy/probe is not acceptance. Confirm the probe summary records `wait-list-store-accepts-signup` passing.

Then verify https://minion.town/ in an actual Playwright Chromium run, using request interception for GET `/account/guest-recovery` to return a synthetic 404 with `identityProvider: GitHub` (never mutate a maintainer account or guest). Confirm exact copy `We signed you in with GitHub, but no minion.town guest is attached to that sign-in.`, cleared query/fragment, focused `recovery-unavailable-title`, `role=status` and `aria-live=polite`, one reload persistence followed by consumption on the next reload, the working alternate-provider link, and the wait-list action opening/focusing the form.

Submit the dedicated fixed address `prod-probe@minion.town` twice to the production `/api/waitlist`. Accept only HTTP 202 and the exact privacy-preserving body `{ "ok": true, "message": "Thanks. You are on the list; we will write when a spot opens." }`; the repeated response must be identical and disclose neither the address nor whether the row was new. The implementation's conditional put makes this the single idempotent fixed-address row.

Save desktop/mobile production screenshots as durable evidence (a commit on the already-merged PR head branch is acceptable evidence without changing deployed `main`). Update PR 254's phase/evidence ledger from `orchestrated-slice` to `deliverable`, adding merge/deploy/probe run URLs and observations, then post one concise top-level completion comment with the evidence. This continuation explicitly authorizes those PR edits/comments.

If the bounded claim still cannot reach production, re-arm exactly one further continuation before handing off.
