---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: kriscendobot/minion.town
kind: build
target: PR #47 (weblet publish ocap redesign) — kriskowal marked CHANGES_REQUESTED
design_path: designs/weblet-ocap-synthesis.md (revised commits ff58264, 7973ac3 on the design's home branch)

The design doc for weblet publishing was substantially revised twice in the last
3 days, directly answering kriskowal's CHANGES_REQUESTED review on PR #47. The
new direction: every fresh guest holds a `@sites` power; a weblet IS an Endo
directory the guest holds (`front` = static tree, `back` = a CapTP-reachable
capability); publish is `E(guest).evaluate` of `E(sites).register(directory)`;
upgrade-in-place falls out of the site watching the directory rather than a
content-lookup formula + `weblet_upgrade` verb; identity is keyed on the
directory formula id. The guest INTRODUCES its directory rather than the gateway
resolving a caller-supplied name in its own authority, which is why
`assertValidPowers`/`assertNotHostShaped`/close-code-4012 (PR #44's patch) are
deleted outright rather than kept as a fallback.

Update PR #47's implementation to match the revised §§2-9 of
designs/weblet-ocap-synthesis.md (model, publish flow, watch-based upgrade,
identity, MCP surface, migration, acceptance criteria). Read the full design doc
in the target worktree before touching code — this is a from-scratch direction
change, not an incremental patch on the prior draft. Confirm with the design's
acceptance criteria before marking done, and flag back to the maintainer if the
PR's existing diff conflicts enough with the new direction that a fresh branch
reads cleaner than amending in place.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-21T23:20:49Z
