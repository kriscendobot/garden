---
title: Subject, Resource, and the Powerline pattern
source: README.md
source_repo: ucan-wg/delegation
source_commit: 1cb32dbc9d4d15a23bf9844a02515d760b81e816
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security, identity]
status: current
---

> Abstract: Why a delegation chain is self-certifying ("By default, the Resource of a capability is the Subject"), how an external resource is named instead (through a policy predicate on a `uri` key, with the Subject owning the relationship), and the Powerline pattern (`sub: null`) that forward-delegates all future authority to another agent. Powerline is the multi-device answer to key sharing, and the spec flags it as one of the three most dangerous features alongside `cmd: "/"` and `pol: []`.

## Subject

> "The Subject MUST be the DID that initiated the delegation chain, or an explicit `null`. Declaring a DID is RECOMMENDED."

## Resource

> "Unlike Subjects and Commands, Resources are *semantic* rather than syntactic. The Resource is the 'what' that a capability describes."

> "By default, the Resource of a capability is the Subject. This makes the delegation chain self-certifying."

> "In the case where access to an external resource is delegated, the Subject MUST own the relationship to the Resource. The Resource SHOULD be referenced by a `uri` key in the relevant Conditions, except where it would be clearer to do otherwise. This MUST be defined by the Subject and understood by the executor."

```js
{
  "sub": "did:key:z6MkiTBz1ymuepAQ4HEHYSF1H8quG5GLVVQR3djdX3mDooWp",
  "cmd": "/crud/create",
  "pol": [
    ["==", ".url", "https://example.com/blog/"], // Resource managed by the Subject
  ],
}
```

The self-certifying default is the interesting half. When the Resource is the Subject, no external lookup is needed to know what the capability is about; when it is an external resource, the chain becomes an assertion by the Subject that it controls that resource, and the executor must check that at execution time (per the high-level spec's "the executor MUST verify the ownership of any external resources at execution time").

## Powerline

> "Similar to `cmd: '/'` and `pol: []`, this feature (`sub: null`) is very powerful. Use with care."

> "A 'Powerline' is a pattern for automatically delegating *all* future delegations to another agent regardless of Subject. This is achieved by explicitly setting the Subject (`sub`) field to `null`. At Validation time, the Subject MUST be substituted for the directly prior Subject given in the delegation chain. All other fields MUST continue to validate as normal (e.g. principal alignment, time bounds, and so on)."

> "Powerline delegations MUST NOT be used as the root delegation to a resource. A priori there is no such thing as a `null` subject."

> "A very common use case for Powerline is providing a stable DID across multiple agents (e.g. representing a user with multiple devices). This enables the automatic sharing of authority across their devices without needing to share keys or set up a threshold scheme. It is also flexible, since a Powerline delegation MAY be revoked."

The spec's own footnote makes the ocap lineage explicit: "For those familiar with design patterns for object capabilities, a 'Powerline' is like a Powerbox but adapted for the partition-tolerant, static token context of UCAN."

Powerline may itself be restricted by time bounds, Commands, and Policies. The narrowed example, forward-delegating read-only CRUD access:

```js
{
  "iss": "did:key:z6MkiTBz1ymuepAQ4HEHYSF1H8quG5GLVVQR3djdX3mDooWp",
  "aud": "did:key:zQ3shokFTS3brHcDQrn82RUDfCZESWL1ZdCEJwekUDPQiYBme",
  "sub": null,
  "cmd": "/crud/read",
  "pol": [],
}
```

Source: [`README.md`](https://github.com/ucan-wg/delegation/blob/1cb32dbc9d4d15a23bf9844a02515d760b81e816/README.md) at commit `1cb32dbc`.
