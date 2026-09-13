---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer

Design authenticated peer identity for host `gateway()` across ALL transports.

Origin: report `deadmail-20260812T232828Z-4f1d09` flagged this and it was routed to
the maintainer rather than auto-jobbed because of its security framing. Maintainer
decision 2026-09-13: design the gateway identity fix. Disclosure timing for the
pushed branch is being held SEPARATELY and is NOT part of this job — do not open a
public PR or publish anything about this work without a further maintainer
authorization. Land the design per the garden's normal design flow.

The gap: host `gateway()` has no authenticated peer identity on any transport. That
absence is what keeps the cross-peer retained-formula-number following gap open — a
peer cannot be held to an identity, so retained formula numbers can be followed
across peers.

Deliverables:
1. Characterize the gap precisely: enumerate the transports, and for each show
   where peer identity is absent and what an unauthenticated peer can therefore
   reach. Ground every claim in the code, with file:line references.
2. Explain the link to cross-peer retained-formula-number following concretely —
   the actual sequence by which the missing identity enables it.
3. Propose the mechanism for authenticated peer identity, uniform across
   transports where possible, and say explicitly where it cannot be uniform.
4. Assess compatibility: what breaks for existing peers, and the migration path.

This is a design, not a build. If the design carries unresolved maintainer-facing
open questions, present it as a review PR per CLAUDE.md's open-questions carve-out
rather than landing it bare.

Skills: skills/design-dependency-walk, skills/regression-evidence,
skills/fully-qualified-github-urls.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-13T14:06:51Z
