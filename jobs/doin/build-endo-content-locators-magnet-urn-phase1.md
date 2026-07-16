# Build: content-locator grammar and duality (Phase 1 of endo-content-locators-magnet-urn)

Repo: endojs/endo-but-for-bots, base `llm`, DRAFT PR (auto-gauntlet follows).
Spec: `designs/endo-content-locators-magnet-urn.md` (merged via PR #662, merge
commit cce5f6142b46e776fee6ffab5c50bdb1889f3e3b) — implement **Phase 1, Grammar
and duality** only:

- `externalizeContent` / `internalizeContentLocator` and a `parseContentLocator`
  validator in `packages/daemon/src/locator.js`, mirroring the transport-side
  `externalizeId` / `internalizeLocator` duality of
  `designs/daemon-locator-reference.md`.
- Grammar: `magnet:` URN with `xt` accepting `urn:endo-blob:` / `urn:endo-tree:`,
  plus `dn`, `xl`, and registered source parameters; reject unknown parameters
  with `parseLocator`-matching strictness.
- Round-trip invariant tests; **no network, no `@planes`, no interface methods**
  (those are Phases 2-4 — do not build ahead of this increment).

Posted by the data-plane press driver (endo-daemon-data-plane-press-20260716-175014)
after #662 merged. Design decisions 4, 9-12 in the doc record the settled naming
(`@planes`, the `<verb>Content` method family) — follow them.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  worker_kind: gardener
  claimed_at: 2026-07-16T18:04:26Z
