---
slug: identity-gated-authority
category: security-hardening
status: closed
count: 1
members:
  - kriscendobot-minion.town-pr85-review-9f17a419
prs: [85]
improvement_job: review-improve-identity-gated-authority
improved_by: 2782d6294d86452b1b2bb3181c1e1d514a96461d: roles/builder/AGENT.md, roles/designer/AGENT.md, roles/jurors/locksmith/AGENT.md, skills/panel-hints/SKILL.md, skills/panel-hints/probes/C-locksmith.sh, scripts/jobs/test/identity-gated-authority-probe-test.sh
---



A per-action authorization decides by asking WHO the caller is (an owner/identity equality check such as record.owner === caller) instead of by possession of a transferable, attenuable capability, contrary to the ocap premise.

**Threshold rationale:** # Dispatch rationale: identity-gated-authority (2026-10-07, retro of kriscendobot-minion.town-pr85-review-9f17a419)

Floor not met (count=1, one PR). Dispatched under the **severity bypass**: the miss
is `severity: major` (security-class authority model), and its grounds cite a
standing rule that already existed and did not bind. That rule is minion.town
designs/mcp-endo-guest.md § Access-control directive (maintainer, 2026-07-09):
per-action authority comes from held capabilities, and denial is the absence of a
capability. The builder still shipped an owner-identity gate on clip upgrade,
copying unpublish's existing owner gate. The pattern is foundational to the
garden's ocap domain and likely to recur, because sibling identity gates remain
(unpublish and listSites on minion.town). Neither the builder brief nor the
locksmith brief/probe names identity-keyed authorization, so prevention and
sensing are both missing. The fix is cheap: a brief line, a seat line, and a
probe. Not held: the in-flight fixer and the lifecycle-capabilities designer job
fix this instance only, not the review cycle.
