---
title: "CSS anchor positioning browser-support matrix (mid-2026)"
source_kind: web-reference
source_url: https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning
source_content_sha256: 313a128acf3b66e31dcfaf61e7b5344987739ede890097cb0b35d9c8a9c0524d
source_author: MDN contributors
source_date: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
notes: "Support state is fast-moving; gate any skill that uses these features on @supports rather than a UA sniff, and re-confirm the matrix at authoring time. Snapshot composed from MDN compat data and the cross-checked browser caveats in web--goldilocks-select-height--final-css-and-browser-support (Jake Archibald, 2026-06-29)."
---

The support state of CSS anchor positioning as of mid-2026, the gate a skill must respect. The headline: **Chrome ships the full feature; Firefox and Safari support the core and the `flip-*` fallbacks but lag on the newer pieces** (Safari has no anchored container queries; `position-try-order` does not work in Firefox or Safari). Because the gaps are per-feature, progressive enhancement is per-feature too — `@supports` gating around `calc-size()`, `stretch`, and anchored container queries, not a single "supports anchor positioning" check (see `supports-feature-query-progressive-enhancement` and `web--goldilocks-select-height--viewport-margin-and-flip-fallbacks`).

## Matrix

| Capability | Chrome | Firefox | Safari |
|---|---|---|---|
| Core anchor positioning (`anchor-name`, `position-anchor`, `anchor()`, `anchor-size()`, `position-area`) | ✅ shipped | ✅ shipped | ✅ shipped |
| `position-try-fallbacks` with `flip-*` tactics | ✅ | ✅ | ✅ |
| `position-try-order: most-*` | ✅ | ❌ not yet (spec was unclear; open ticket) | ❌ not yet (open ticket) |
| `position-visibility` | ✅ | partial / in progress | partial / in progress |
| Anchored container queries (`container-type: anchored`, `@container anchored()`) | ✅ | in progress | ❌ not supported |
| `calc-size()` (used to clamp anchor-positioned sizes) | ✅ Chrome only | ❌ open ticket | ❌ open ticket |
| `max-block-size: stretch` (fill the anchor cell) | ✅ | ❌ not supported (use `calc(100% - margin)` fallback) | ✅ |
| Customizable `<select>` / `::picker(select)` (built on these primitives) | ✅ shipped | implementing, not released | implementing, not released |

## Consequences for a skill

- **Gate on the narrowest feature, not the family.** `flip-*` fallbacks are universal, so a popover that only flips on overflow works everywhere; but anything that wants `position-try-order` proactive selection, anchored container queries, or `calc-size()` clamping must `@supports`-gate and ship a fallback path.
- **Prefer `flip-*` property-flipping over anchored container queries for fallback-conditional margins/insets**, because Safari lacks anchored container queries but supports the flip tactics (the goldilocks margin-on-flip decision).
- **Firefox needs a `stretch` fallback.** Where the Chrome/Safari path uses `max-block-size: stretch`, Firefox falls back to `max-block-size: calc(100% - var(--viewport-margin))`.
- **Re-confirm at authoring time.** These rows move fast; the durable rule is the `@supports`-per-feature discipline, not the exact cells.

Source: [CSS anchor positioning — Browser compatibility](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning), MDN contributors, developer.mozilla.org, cross-checked against [The Goldilocks customizable select height](https://jakearchibald.com/2026/goldilocks-select-height/) (Jake Archibald, 2026-06-29); fetched 2026-06-29 via direct curl, content SHA-256 `313a128a`.
