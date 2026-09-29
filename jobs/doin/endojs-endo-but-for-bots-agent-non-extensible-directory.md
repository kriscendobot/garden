---
role: builder
dispatch: automatic
tier: mentor
fallback-tier: minion
---
Introduce an agent-maker option, in endojs/endo-but-for-bots (`llm` and/or the daemon-provisioning-grants line), that makes a newly created agent's OWN pet-name directory (its `petStore`) non-extensible — the agent may still resolve and use its existing names but cannot add new pet names to its own directory.

Context: requested by kriskowal in https://github.com/endojs/endo-but-for-bots/pull/1102#issuecomment-5884356929 alongside the unified-endowments work (PR #1343, now landed on the `issue982-build-special-names` head). It is the natural companion to the retained-guest endowment surface: a host that endows a fixed capability graph plus indelible special names may also want the guest unable to grow its own namespace.

Scope: add the option to `provideGuest`/`provideHost` (or the shared agent-maker options) — name it sensibly (e.g. `nonExtensibleDirectory` / `sealDirectory`) — thread it through the guest/host formula so it persists across restart, enforce it at the petStore boundary (attempts to store a new name fail closed with a clear error), and cover it with daemon tests plus lint/types and the repo pre-push gates. Confirm the exact option name and whether it belongs on both hosts and guests with the maintainer if ambiguous.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-29T16:56:55Z
