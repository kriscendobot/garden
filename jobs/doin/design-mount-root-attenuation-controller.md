---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: filesystem mount attenuation with a root-controller facet

Repo: endojs/endo-but-for-bots @ llm. Role: designer.

Follow-up requested by kriskowal in review
https://github.com/endojs/endo-but-for-bots/pull/1340#discussion_r4149165593
(PR #1340, designs/agent-confined-application-makers.md).

Today a `Mount` confines to one root and hides/rejects symlinks that escape it,
so a pnpm symlinked `node_modules` store cannot be read confined (#1340 now
requires a hoisted layout when reading from a mount). Design a fuller
filesystem mount attenuation that does NOT deny the existence of the full
POSIX namespace but makes all but some chosen roots invisible, so links into
another visible root resolve, plus a **controller facet** that adds and removes
visible roots. Relate it to designs/daemon-mount.md,
designs/daemon-mount-capabilities.md, the existing `makeRevocableMount` /
`EndoMountControl` caretaker pattern, and agent-confined-application-makers
(the symlinked-store case it would unlock). Open a design PR on llm.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-30T22:37:05Z
