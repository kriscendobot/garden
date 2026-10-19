---
slug: identity-gated-authority
category: security-hardening
status: open
count: 2
members:
  - kriscendobot-minion.town-pr85-review-9f17a419
  - kriscendobot-minion.town-pr191-review-93f9e308
prs: [85, 191]
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

**Threshold rationale:** **Threshold rationale (2026-10-19, retro of kriscendobot-minion.town-pr191-review-93f9e308):**
Held. No second improvement round was dispatched. This is a genuine post-fix
recurrence: the 2026-10-15 review came after the 2026-10-07 improvement, and
the writer reopened the cluster and alerted the maintainer under
review-miss-recurrence-identity-gated-authority. The cluster now has count=2
across two PRs (#85, #191). That is below the K≥3 floor. Per the skill § 6, a
reopened cluster waits for the maintainer and does not start a second round
on autopilot.

The evidence points to a narrow gap for that round. The prevention line
exists but is code-shaped: it names owner, subject, or caller allowlists. It
did not bind on a design that put authority in an AWS IAM trust-policy
principal and inherited that from an accepted design. The sensing check
(C-locksmith.sh) matches code tokens, so it cannot fire on design prose such
as "trust policy permits only X" or "which principal may read". Candidates:
(a) extend the designer brief line to infrastructure-identity gates (IAM
trust policies, host or instance identity) when a capability secret held on
the host would do; (b) add a design-panel prose arm to the locksmith probe;
(c) review why #191's design-PR gauntlet halted on a floating `main` base and
reached the maintainer with no panel.
