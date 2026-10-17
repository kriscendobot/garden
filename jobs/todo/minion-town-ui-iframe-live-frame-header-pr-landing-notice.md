---
role: builder
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-17T04:56:24Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
arc: minion-town-ui
---
# Iframe: header PR #194 resolved — post the live-frame build only if it merged

Repo: `kriscendobot/minion.town`. Arc: `minion-town-ui`. Deterministic dependency notice, not the implementation. Parked by `minion-town-ui-iframe-live-frame-landing-notice` blocked on https://github.com/kriscendobot/minion.town/pull/194 — the single PR whose body carries `<!-- garden-job: minion-town-ui-iframe-embed-headers-after-approval -->` (the embedding-header implementation of approved design PR #189). `unblock.sh` promotes this on merge OR close, so branch mechanically:

1. Re-read the PR: `gh pr view 194 -R kriscendobot/minion.town --json state,mergedAt,body`. Confirm the body still contains the exact marker above; if not, notify the maintainer (`message-user.sh`) and post nothing.
2. If `mergedAt` is non-null: post `minion-town-ui-iframe-live-frame-after-headers` with `scripts/jobs/post-job.sh minion-town-ui-iframe-live-frame-after-headers <file>`, where `<file>` holds the build body below **unchanged**.
3. If the PR is closed with `mergedAt` null: post NO build; notify the maintainer via `message-user.sh` that the embedding-header dependency (PR #194) was declined, so the live-frame build is not posted.
4. If the PR is still open (spurious promotion): re-park a fresh notice with `post-plan.sh --blocked --blocked-on https://github.com/kriscendobot/minion.town/pull/194` carrying this same body, and post nothing.

The build body to pass unchanged to `post-job.sh minion-town-ui-iframe-live-frame-after-headers` is:

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: frame the live clip in the main pane after embedding headers land

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Governing design: `designs/clip-shell-framework.md`, including the approved iframe amendment from PR #189. Predecessor: the merged header implementation PR discovered by the notice chain.

Confirm the header implementation is present on current `main` before editing. At the `showClip` sink in `deploy/aws/www/shell.js`, add the live `src` branch. Re-derive the origin from the validated clip id with `clipOrigin`; never trust or store a supplied origin string. Use exactly the sandbox flags approved in the merged design. If the clip fails to load or refuses framing, replace it with the inert card. Preserve section 4's unforgeable-chrome geometry and stacking guarantees. Reconcile the frame key with PR #88's id model first only if #88 has landed. Add load-bearing tests in `test/shell-clip.test.ts`, run the browser-facing verification required by the design, and open a draft PR through `ensure-pr.sh` against a frozen `main-<sha>` base.
