---
posted_at: 2026-11-05T01:06:56Z
role: designer
repo: kriscendobot/minion.town
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Design: decide the API-key agent directory authorization boundary

Write a small design-first follow-up for the unresolved authorization finding from the review at https://github.com/kriscendobot/minion.town/pull/244#pullrequestreview-5777291018.

`src/auth/inference-provider-endpoint.ts` derives the owner in `directoryFor(ownerKey)` from `iss`/`sub` and authorizes agent actions through the factory's broad facet. Compare that architecture with attenuated per-agent capabilities and determine whether the existing workbench design intentionally chooses the broad trust boundary or leaves a security gap. Use https://github.com/kriscendobot/minion.town/blob/7a0bcc903026382582afd97fcc3c2a18a0e85e05/designs/api-key-agent-workbench.md as the baseline.

Name and evaluate these options:

1. Keep the broad facet and explicitly document the trust boundary.
2. Introduce an incremental attenuated per-agent facet behind the existing interface.
3. Perform a full capability architecture redesign.

The maintainer's tentative preference is option 2 only if the design establishes a real gap. Do not implement the architecture change in this job; produce the decision surface and any implementation follow-up it warrants.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T01:47:17Z
