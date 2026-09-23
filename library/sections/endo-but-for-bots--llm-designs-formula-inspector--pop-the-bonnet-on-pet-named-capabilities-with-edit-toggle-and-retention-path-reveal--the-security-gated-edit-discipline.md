---
section: pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
source: endo-but-for-bots--llm-designs-formula-inspector
topics: [daemon, agent-conventions, tooling]
status: current
title: The §security-gated-edit discipline
parent: endo-but-for-bots--llm-designs-formula-inspector--pop-the-bonnet-on-pet-named-capabilities-with-edit-toggle-and-retention-path-reveal
---

§Security Considerations:

> *Formula editing is a highly privileged operation. It must
> be gated behind host-level authority and should log an audit
> trail.*

The §host-level-authority-required discipline: revising a
formula isn't *guest-accessible*. Only the host can call
`revise()` directly; guests must request host approval.

The §audit-trail-on-revise discipline: every `revise()` call
*logs* the before/after formula. Recovery from a mistaken
revise depends on having a record of what was there before.

The §inspection-vs-editing-security-asymmetry: *inspection*
exposes formula structure to the *owning user/host* (not
guests without explicit policy); *editing* is host-level only.
Two different authority gates for two different operations.
