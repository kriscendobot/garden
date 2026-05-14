---
id: delegates-and-epithets
aliases: ["delegate", "delegates", "epithet", "epithets", "delegate/epithet model", "principal", "Aifred", "Jarvis", "assistant to Alice", "obligatory verifiable deniable", "AI assistant disclosure", "Delegates and Epithets"]
topics: [daemon, capability-security, agent-conventions]
---

# delegates-and-epithets

The Endo Daemon's identity-relationship model. A **delegate** is an
agent (Handle + agency) created by another agent (its *principal*),
carrying obligatory **epithets** (`{relationship: string, principal:
Handle}`) about its relationship to that principal. Epithets are
**obligatory** (delegate cannot remove them), **verifiable** (anyone
holding the principal's Handle can ask `E(principalHandle).verify(...)`),
and **deniable** (the principal decides whether to confirm). Chains
grow monotonically through sub-delegation — a delegate creating a
subordinate must propagate its own chain prepended with the new link;
the daemon (not the delegate) writes the Handle formula, so chain-
stripping is structurally impossible.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dcp/delegates-and-epithets](../sections/endo-but-for-bots--llm-designs-dcp--delegates-and-epithets.md) | Core ideas — the three properties (obligatory + verifiable + deniable); Epithet shape; what distinguishes this from a naive signature scheme. |
| [dcp/handle-agent-foundation-and-the-gap](../sections/endo-but-for-bots--llm-designs-dcp--handle-agent-foundation-and-the-gap.md) | The Handle / Agent / pet-name foundation and the "Handle is opaque" gap that delegates fill. |
| [dcp/recursive-chains-and-enforcement](../sections/endo-but-for-bots--llm-designs-dcp--recursive-chains-and-enforcement.md) | Chain propagation; *attenuation by extension, not contraction*; daemon-as-enforcer. |
| [dcp/verification-and-handle-extensions](../sections/endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions.md) | Verification protocol; `epithets()` and `verify()` Handle methods; HandleControl caretaker for verification policy. |
| [dcp/ai-delegates-connectors-and-anti-impersonation](../sections/endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation.md) | The motivating case (AI agents); service connectors; anti-impersonation invariant. |

## See also

- [[caretaker-pattern]] — Handle (delegate-held, public) + HandleControl (principal-held, sets verification policy + revocation).
- [[revocation-by-withdrawal]] — a revoked Handle breaks the chain at that link cleanly.
- [[per-agent-keypair]] — the cryptographic substrate epithets reference.
- [[pass-invariant-handle-equality]] — the connector guarantee that lets agents detect that two pet names point to the same person.
