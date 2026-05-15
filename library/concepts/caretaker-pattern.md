---
id: caretaker-pattern
aliases: ["caretaker pattern", "caretaker", "Handle vs HandleControl", "identity / action facet split", "facet split", "control facet vs action facet"]
topics: [patterns, capability-security]
---

# caretaker-pattern

A capability-security pattern: **split one capability into two
facets** — an *action* facet (held by the delegate / user of the
capability) and a *control* facet (held by the granter / caretaker).
The action facet does the work; the control facet sets policy,
attenuates, or revokes. The two facets reference the same underlying
state but expose disjoint surfaces. Endo's daemon uses this pattern
in several places:

| Capability | Action facet (delegate-held) | Control facet (principal-held) |
|---|---|---|
| Handle (delegates / epithets) | `Handle` — receive mail, support `verify()` with whatever policy the creator set | `HandleControl` — update verification policy, revoke |
| Connector (external platform) | A pet name in the agent's directory that resolves to the connector's Handle | The credential held in the daemon's credential store, never exposed to the delegate |

The pattern is what makes revocation effective without requiring the
delegate to cooperate: the principal's control facet acts on the
underlying state and the action facet (still held by the delegate)
loses its effect.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [dcp/verification-and-handle-extensions](../sections/endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions.md) | Handle / HandleControl as the canonical Endo example: delegate gets Handle (receive + verify-as-policy-allows), principal gets HandleControl (set policy, revoke). |
| [dcp/ai-delegates-connectors-and-anti-impersonation](../sections/endo-but-for-bots--llm-designs-dcp--ai-delegates-connectors-and-anti-impersonation.md) | The identity / action facet split for connectors: delegate has the action facet (send messages), connector / daemon has the control facet (credentials, profile editing). |
| [dp/acyclic-formula-graph-and-revocation](../sections/endo--designs-dp--acyclic-formula-graph-and-revocation.md) | Names the caretaker as one of three pre-existing revocation mechanisms (alongside revocation lists and expiry) — the comparison table that *contrasts* caretakers with revocation-by-withdrawal lives here. |
| [dp/six-aspects-of-sharing-and-related-work](../sections/endo--designs-dp--six-aspects-of-sharing-and-related-work.md) | Same caretaker-as-existing-mechanism framing in the Karp/Stiegler/Close revocable-aspect treatment. |

## See also

- [[delegates-and-epithets]] — the model that uses the caretaker pattern to give the principal verification-policy control without the delegate's cooperation.
- [[revocation-by-withdrawal]] — caretakers contrast with revocation-by-withdrawal: caretakers must remain alive to enforce; withdrawal-of-constructor does not.
