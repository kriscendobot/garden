# Plan: minion.town clip gutter, then the clip iframe (arc `minion-town-ui`)

Job `plan-minion-town-clip-gutter-20261010`. This is a build plan, not a new design.
The design of record is kriscendobot/minion.town `designs/clip-shell-framework.md`.
Every increment below is parked as a plan stamped `arc: minion-town-ui`.

## What exists on `main` (c9a073c, 2026-10-10)

- **Gutter: shipped.** The gated signed-in landing `deploy/aws/www/index.html` +
  `shell.js` (`createClipGutter`) shows a 56px gutter. It sits on the left in
  landscape and at the bottom in portrait. It lists the caller's clips from the
  owner-scoped `GET /account/clips` (`src/auth/guest-self-endpoint.ts`). It also has
  active highlight, Cmd/Ctrl+1..9 quick-switch, a `+` button, and the bottom-left
  chrome overlay. Tests: `test/shell-clip.test.ts`.
- **Gutter gaps.** Records are synthesized from `{hash, serving}` only, so every
  clip is named "Clip N" with a rotating emoji. `order` is the listing order, with no
  reorder. `serving` is carried but not shown. The list loads once per page load. `+`
  shows an inert how-to card and mints nothing (design section 6).
- **Iframe: inert by construction.** `frameConfiguration` always returns an
  empty-sandbox `srcdoc` card, and there is no `src` sink. The live clip opens only in
  a new tab through the derived `https://<id>.ocap.site/` link.
- **Why it is inert.** `src/endo/gateway/isolation-headers.ts` denies framing of
  every `*.ocap.site` response (`frame-ancestors 'none'`, `X-Frame-Options: DENY`,
  `COEP: require-corp`). Relaxing that is the design's open question #1, and the
  maintainer has not decided it.
- **Related open PRs.** #142 (clip lifecycle authority as capabilities), #88
  (fresh-id-on-upgrade / nonce locator), #85 (in-place upgrade, CHANGES_REQUESTED),
  #170 (locator fragments), #174 (publish metering).

## Increments: the gutter first

1. **`minion-town-ui-gutter-clip-labels`** (deferred, builder). Give each clip a
   real display name and icon. Source the name from what the publish/`listSites`
   path already knows (the guest's name for the site, or the front's `<title>`).
   Carry it as an optional, validated, length-capped field on `/account/clips` and
   fall back to "Clip N". Show `serving: false` as a dimmed state.
2. **`minion-town-ui-gutter-live-refresh`** (deferred, builder). Re-read
   `/account/clips` on `visibilitychange`/focus, plus a cheap manual refresh, so a
   clip published over MCP appears without a reload. Keep the selection when the
   clip still exists, and clear it to the empty state when the clip is gone.
3. **`minion-town-ui-gutter-reorder`** (deferred, builder). Drag-reorder plus a
   keyboard reorder (Alt+Arrow). Persist the order server-side, owner-scoped
   (`iss`+`sub`) beside the clips listing, never in `localStorage`. The design's
   resolved question #3 rules that out.
4. **`minion-town-ui-gutter-mint`** (blocked on #142, builder). Wire `+` to a
   browser-reachable guest-publish endpoint that mints a real `front`/`back` pair
   through the guest's own `@sites` power (design section 6). This is blocked
   because the mint and remove authority is exactly what #142 settles.

## Increments: the iframe second

5. **`minion-town-ui-iframe-embed-design`** (deferred, designer). Write a design PR on
   kriscendobot/minion.town that answers open question #1 concretely. The likely
   answer is an opt-in embedding relaxation for clips framed by
   `https://minion.town` only (`frame-ancestors https://minion.town`, a CORP/COEP
   story, and sandbox flags), with the alternatives costed. The PR is the
   maintainer's decision surface. Do not build anything in this increment.
6. **`minion-town-ui-iframe-embed-headers`** (blocked on increment 5, builder).
   Implement the relaxation that the approved design names in
   `isolation-headers.ts`, with tests that keep the floor intact for every other
   embedder. Stop if the design PR is not approved.
7. **`minion-town-ui-iframe-live-frame`** (blocked on increment 6, builder). Add a
   live `src` branch at the `showClip` sink. It sets the origin re-derived from the
   id via `clipOrigin`, uses the approved sandbox flags, and falls back to the inert
   card when the clip fails to load or blocks framing. Before choosing the frame key,
   reconcile the id model with #88 if #88 has landed.

Increments 1 to 3 and 5 can be drawn by the foreman immediately and in any order.
Increments 4, 6, and 7 wait on their blockers through the unblock watcher.
