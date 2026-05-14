---
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
section_count: 5
status: current
notes: **Status: Not Started** upstream. Internal title is *"Delegates and Epithets: Ideas and Directions"* — the document is broader than the filename suggests, covering identity/relationship claims attached to agent Handles. Referenced by [[endo-but-for-bots--llm-designs-daemon-agent-network-identity]] as the design that motivates per-agent network identity. Builds on per-agent keypairs ([[endo-but-for-bots--llm-designs-daemon-256-bit-identifiers]]) and per-agent NETS ([[endo-but-for-bots--llm-designs-daemon-agent-network-identity]]); both supply the *who-am-I* substrate that delegates/epithets layer relationships on top of. Several open questions (Handle vs. EpithetInterface split, cross-OCapN verification, voluntary vs. obligatory epithets) remain unsettled.
---

> Abstract: Design for **delegates and epithets** — agent identity that carries verifiable, deniable claims of relationship to a principal. A delegate is an agent created by another agent (a *principal*), carrying obligatory epithets (`{relationship: string, principal: Handle}`) that the delegate cannot shed. Anyone holding the principal's Handle can verify the relationship via `E(principalHandle).verify(delegateHandle, "relationship")`; the principal answers at its own discretion (confirm / deny / silence). Chains grow monotonically — a delegate creating a sub-delegate must propagate its own chain prepended with the new link. The daemon (not the delegate) writes Handle formulas, so chain-stripping is structurally impossible. The **caretaker pattern** splits Handle (delegate-held, public) from HandleControl (principal-held, sets verification policy + revocation). For AI agents specifically: service connectors translate Endo mail to platform APIs, read the sender's epithet chain, and render it into platform disclosure (Slack bot name, email signature, Discord bio). Credentials are connector-custodied — the delegate never holds raw tokens. The anti-impersonation invariant *every externally visible action carries the epithet chain* rests on three structural properties: epithets immutable, credentials custodied, profile editing separated.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [handle-agent-foundation-and-the-gap](../sections/endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap.md) | daemon, capability-security, agent-conventions | current |
| [delegates-and-epithets](../sections/endo-but-for-bots--llm-designs-dcp--delegates-and-epithets.md) | daemon, capability-security, patterns | current |
| [recursive-chains-and-enforcement](../sections/endo-but-for-bots--llm-designs-dcp--recursive-chains-and-enforcement.md) | daemon, capability-security, patterns | current |
| [verification-and-handle-extensions](../sections/endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions.md) | daemon, capability-security, patterns, agent-conventions | current |
| [ai-delegates-connectors-and-anti-impersonation](../sections/endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation.md) | daemon, capability-security, agent-conventions, patterns | current |

## See also

- `daemon-256-bit-identifiers.md` (`d256`) — per-agent keypairs are the cryptographic substrate epithets reference
- `daemon-agent-network-identity.md` (`dani`) — per-agent NETS pairs with per-agent identity; this design supplies the relationship claims
- `daemon-persistence.md` (`dp`, PR #3121) — Formula Persistence; the epithet chain lives in the Handle formula and follows formula lifecycle
