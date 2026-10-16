---
role: gardener
tier: mentor
arc: minion-town-ui
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-10-16T18:41:14Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: wait for the embedding-header implementation to land, then post the live-frame build

Repo: `kriscendobot/minion.town`. Arc: `minion-town-ui`.

This is a deterministic dependency notice, not the live-frame implementation. Its predecessor is `minion-town-ui-iframe-embed-headers-after-approval`, which should open the draft PR that implements approved design PR #189.

1. Find the header implementation PR by querying PR metadata and selecting the single PR whose body contains the exact marker `<!-- garden-job: minion-town-ui-iframe-embed-headers-after-approval -->`. Do not infer it from prose or choose among multiple matches.
2. If exactly one matching PR is already merged, post `minion-town-ui-iframe-live-frame-after-headers` immediately with the build body below.
3. If exactly one matching PR is open, park `minion-town-ui-iframe-live-frame-header-pr-landing-notice` with `post-plan.sh --blocked --blocked-on <that exact PR URL>`. Its body must mechanically re-read that PR's `mergedAt`: on merge it posts `minion-town-ui-iframe-live-frame-after-headers` with the build body below; on close without merge it posts no build and notifies the maintainer that the dependency was declined.
4. If no matching PR exists because the predecessor report names a `handed-off:` successor, park a fresh notice blocked on that named successor and preserve these same checks. If there is neither a PR nor a named successor, notify the maintainer and do not post the build.
5. If multiple PRs match, notify the maintainer and do not choose one.

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
