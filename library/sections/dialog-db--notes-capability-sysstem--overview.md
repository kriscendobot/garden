---
title: Capability system — effects, platform/application separation
source: notes/capability-sysstem.md
source_repo: dialog-db/dialog-db
source_commit: f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53
source_date: 2026-07-05
source_authors: [Irakli Gozalishvili]
ingested: 2026-07-06
ingested_by: scholar
topics: [capability-security, ucan-authorization]
status: current
---

> Abstract: Dialog's capability-system sketch borrows the platform/application split from Roc (and its cousins, Unison's algebraic effects and Elm's commands): an **effect** is an application telling a **platform** "do this thing", which the platform performs only because it holds the corresponding **capability**. This matters to Dialog for two reasons — it already has platform-code separation in the form of pluggable storage-backend implementations, and the [object-capability model] is "the only viable way to manage access in non-centralized, potentially offline settings." The proposed design replaces backends with a set of platform capabilities provided by **environments**, making application code referentially transparent, environment-agnostic, and easy to test and embed.

Roc's clear separation between platform and application code (and the kindred algebraic-effects-in-Unison and commands-in-Elm designs) is the model Dialog reaches for. Effects are essentially commands: a way for an **application** to tell a **platform** "Hey, I want you to do this thing!". For this to work the platform must provide a corresponding **[capability]** so the application can [invoke] it.

This is relevant to Dialog for two reasons:

1. Dialog already has platform-code separation in the form of various storage-backend implementations.
2. The [object-capability model] is the only viable way to manage access in non-centralized, potentially offline settings.

**Proposed design sketch**: define a set of platform capabilities (as a replacement for backends) that can be provided by various **environments** (Dialog's term for "platform"), making application code [referentially transparent], environment-agnostic, and straightforward to test and embed.

The organizing definition, aligned with the UCAN model: **a capability is the association of an ability to a subject** — `subject x command x policy`. The following sections decompose that triple (subject, ability, policy), then the effect/provider mechanism that performs capabilities, and the proposed concrete capability set.

This is the ocap common ground with Endo: like Endo's object-capability discipline, authority here is a held, delegable, unforgeable reference (a UCAN delegation over a DID:key subject) rather than an identity checked against an access-control list, and confinement follows from what an environment is willing to provide.

Source: [notes/capability-sysstem.md](https://github.com/dialog-db/dialog-db/blob/f777fe7cbdf363ba3718abcfb1e3bf7e1aa8bb53/notes/capability-sysstem.md) at commit `f777fe7c`.

[capability]: https://github.com/ucan-wg/spec?tab=readme-ov-file#capability
[invoke]: https://github.com/ucan-wg/invocation
[object-capability model]: https://en.wikipedia.org/wiki/Object-capability_model
[referentially transparent]: https://en.wikipedia.org/wiki/Referential_transparency
