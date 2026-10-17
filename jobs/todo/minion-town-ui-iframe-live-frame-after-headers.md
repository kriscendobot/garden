---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Iframe: frame the live clip in the main pane after embedding headers land

Repo: kriscendobot/minion.town (base `main`). Arc `minion-town-ui`. Governing design: `designs/clip-shell-framework.md`, including the approved iframe amendment from PR #189. Predecessor: the merged header implementation PR discovered by the notice chain.

Confirm the header implementation is present on current `main` before editing. At the `showClip` sink in `deploy/aws/www/shell.js`, add the live `src` branch. Re-derive the origin from the validated clip id with `clipOrigin`; never trust or store a supplied origin string. Use exactly the sandbox flags approved in the merged design. If the clip fails to load or refuses framing, replace it with the inert card. Preserve section 4's unforgeable-chrome geometry and stacking guarantees. Reconcile the frame key with PR #88's id model first only if #88 has landed. Add load-bearing tests in `test/shell-clip.test.ts`, run the browser-facing verification required by the design, and open a draft PR through `ensure-pr.sh` against a frozen `main-<sha>` base.
