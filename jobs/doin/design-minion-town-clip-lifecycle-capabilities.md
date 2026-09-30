---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: clip lifecycle authority as capabilities (kriscendobot/minion.town)

Repo: kriscendobot/minion.town. Origin: kriskowal CHANGES_REQUESTED review on
https://github.com/kriscendobot/minion.town/pull/85#pullrequestreview-5360873327 —
"If you have to ask who is acting, you have failed. Instead, the right to publish or
upgrade should be modeled as a transferable or attenuatable capability."

PR #85 (head `feat/clip-upgrade-in-place`) now authorizes **upgrade** by a capability:
`publish` returns an unguessable swiss-number `upgradeCapability` (rights
`content`+`powers`), `upgrade` takes `capability` instead of `hash`, and
`attenuateUpgrade` mints narrower capabilities (src/endo/gateway/upgrade-capability.ts).
The rest of the clip lifecycle still asks who the caller is. Design (land in
`designs/`, open questions to the maintainer) how to finish the move:

1. **unpublish** is still owner-gated (`record.owner !== owner` in publish.ts and
   makeDaemonSiteRegistry.unregister; the `owner-<hash>` record in site-registry-exo.ts).
   Should it become an `unpublish` right on the same capability (controller facet
   = upgrade+unpublish), and what happens to the owner field (accounting only?).
2. **listSites** is owner-scoped: is listing a legitimate identity-keyed view
   (accounting/billing) or should the guest's own pet-name store be the list?
3. **Capability representation.** Swiss-number strings travel over MCP and can be
   passed by Endo mail, but land in LLM contexts. Compare a daemon-native form: a
   per-clip controller exo stored under a pet name in the publishing guest
   (transferable by `send`/`adopt`, attenuable by wrapping), and whether the
   publishing guest's directory itself (it already holds `clip-N-*`) is the right
   designator. Also compatibility with the capability-URL locator pivot
   (endo:// / https #v=1 fragment locators).
4. **Migration** for clips published before #85 lands (no capability was ever minted):
   a one-time owner-authorized mint, or none.
5. **Revocation**: whether an attenuated capability should be revocable by its
   issuer (caretaker pattern), and grant cleanup on unpublish.
6. Publishing *new* clips: confirm the `sites` register facet introduced to each
   guest (root-host-socket.ts, owner pinned at grant) is already the capability, and
   whether the pinned `owner` should shrink to an accounting tag.

<!-- garden-productive-cycle -->
---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T03:59:42Z
