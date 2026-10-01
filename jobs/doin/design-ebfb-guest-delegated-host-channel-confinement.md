---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: confinement for capabilities delegated to a guest, and for channel messages a guest reads

Repo: endojs/endo-but-for-bots @ `llm`. Context: PR https://github.com/endojs/endo-but-for-bots/pull/1404 ("guests neither produce nor consume identifiers or locators"). That PR scopes its invariant to the guest's own surface: its `EndoGuest` methods, its mail, and the directories it reaches. Round 3 of its gauntlet panel raised two gaps outside that scope (dispositions: https://github.com/endojs/endo-but-for-bots/pull/1404#issuecomment-5938245962):

1. **Delegated hosts (breaker).** `introducedNames: { '@agent': 'host-agent' }` (lal, fae, jaine, claude-sandbox) binds the full `EndoHost` into a guest. That host has `identify`, `locate`, `storeIdentifier`, `invite`, and `accept`, and mail `send`/`adopt` can pass it on to other guests. Decide whether a confined guest should receive an attenuated host facet instead, and what those agents' provisioning would then need.
2. **Channel messages (purist, wire-watcher).** `EndoChannelMember.listMessages`/`followMessages` return raw `ids: FormulaIdentifier[]`, and `post` accepts ids. Decide whether a guest member should get a redacted member facet, mirroring `guest-redaction.js`.

Deliver a design document (designs/ on `llm`) with a recommendation for each, and open questions for the maintainer.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-01T23:20:41Z
