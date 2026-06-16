---
title: The three properties
source: designs/daemon-capability-persona.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: bcb6c379325b0f66d211d759ce7d3031fbf94e5b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [daemon, capability-security, patterns]
status: current
parent: endo-but-for-bots--llm-designs-dcp--delegates-and-epithets
---

The model rests on three properties that are *jointly* what make
epithets useful:

| Property | What it means | Why it matters |
|---|---|---|
| **Obligatory** | The delegate's creator sets epithets at creation time; the delegate cannot remove or modify them. They are part of the Handle's identity, not a voluntary self-description. | A prompt-injected delegate cannot shed the claim "I am an AI assistant to Alice." |
| **Verifiable** | Anyone holding the principal's Handle can ask it to confirm or deny the relationship. The verification is a direct interaction between verifier and principal — it does **not** go through the delegate. | The delegate cannot intercept or forge the verification result. |
| **Deniable** | The principal can deny the relationship even if it is true. | A principal may have a delegate they want to deny to certain parties; deniability is under the principal's control, not a bug. |

The deniability property is the one that distinguishes this from a
naive signature-based scheme. A signed claim a delegate carries
*proves* the relationship to anyone who sees the signature; an
epithet only *enables verification on demand* from the principal, and
the principal retains discretion over how to answer. See
[[endo-but-for-bots--llm-designs-dcp--verification-and-handle-extensions]]
for the verification protocol.

The pattern — *obligatory + verifiable + deniable* — is itself a
contribution; the design space of capability-bearing identity
claims does not have a single dominant prior name for this trifecta.
