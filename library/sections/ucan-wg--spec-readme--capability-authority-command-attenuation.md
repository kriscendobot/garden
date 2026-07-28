---
title: Capability, authority, command paths, and attenuation
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security]
status: current
---

> Abstract: The UCAN capability model at the high-level-spec layer: a capability is `subject x command x policy`; the "authority" of a UCAN is the set union of its capabilities and is always additive; Commands are slash-delimited lowercase paths where a shorter path proves every longer path nested under it; `/` is "top" and grants everything including the power to rewrite the Subject's DID document; and attenuation requires each direct delegation to "either directly restate or attenuate (diminish) its capabilities".

## Capability

> "A capability is the association of an ability to a subject: `subject x command x policy`. The Subject and Command fields are REQUIRED. Any non-normative extensions are OPTIONAL."

The spec's worked example, the ability to send email from a certain address to recipients at `example.com`:

| Field | Example |
|---|---|
| Subject | `did:key:z6MkhaXgBZDvotDkL5257faiztiGiC2QtKLGpbnnEGta2doK` |
| Command | `/msg/send` |
| Policy | `["or", ["==", ".from", "mailto:me@example.com"], ["match", ".cc", "mailto:*@example.com"]]` |

## Authority

> "Whether to enable cooperation or to limit vulnerability, we care about *authority* rather than *permissions*. Permissions determine what actions an individual program may perform on objects it can directly access. Authority describes the effects that a program may cause on objects it can access, either directly by permission, or indirectly by permitted interactions with other programs."
>
> Mark Miller, Robust Composition

> "The set of capabilities delegated by a UCAN is called its 'authority.' To frame it another way, it's the set of effects that a principal can cause, and acts as a declarative description of delegated abilities."

> "Merging capability authorities MUST follow set semantics, where the result includes all capabilities from the input authorities. Since broader capabilities automatically include narrower ones, this process is always additive. Capability authorities can be combined in any order, with the result always being at least as broad as each of the original authorities."

> "Every unique delegated capability MUST have equal or narrower capabilities from their delegator."

## Command

> "Commands are concrete messages ('verbs') that MUST be unambiguously interpretable by the Subject of a UCAN. Commands are REQUIRED in invocations. Some examples include `/msg/send`, `/crud/read`, and `/ucan/revoke`."

> "Much like other message-passing systems, the specific resource MUST define the behavior for a particular message. For instance, `/crud/update` MAY be used to destructively update a database row, or append to a append-only log."

Segment structure: "Commands MUST be lowercase, and begin with a slash (`/`). Segments MUST be separated by a slash. A trailing slash MUST NOT be present." Valid examples include `/`, `/crud`, `/crud/create`, `/crypto/sign`, and non-ASCII paths.

> "Segment structure is important since shorter Commands prove longer paths. For example, `/` can be used as a proof of *any* other Command. For example, `/crypto` MAY be used to prove `/crypto/sign` but MUST NOT prove `/stack/pop` or `/cryptocurrency`."

Note the deliberate non-prefix-matching: `/crypto` does not prove `/cryptocurrency`. Path segmentation, not string prefix, is the relation.

## Top

> "'Top' (`/`) is the most powerful ability, and as such it SHOULD be handled with care and used sparingly."

> "The wildcard ability grants access to all other capabilities for the specified resource, across all possible namespaces. The wildcard ability is useful when 'linking' agents by delegating all access to another device controlled by the same user ... It is extremely powerful, and should be used with care. Among other things, it permits the delegate to update a Subject's mutable DID document (change their private keys), revoke UCAN delegations, and use any resources delegated to the Subject by others."

The `/ucan` command namespace is reserved, covering "any ability string matching the regex `^\/ucan\/.*`", to keep space for community-blessed commands such as Revocation.

## Attenuation

> "Attenuation is the process of constraining the capabilities in a delegation chain. Each direct delegation MUST either directly restate or attenuate (diminish) its capabilities."

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
