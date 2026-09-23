---
title: Roles, and the Subject as a DID-identified resource manager
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security, identity]
status: current
---

> Abstract: The ten UCAN roles (Agent, Audience, Executor, Invoker, Issuer, Owner, Principal, Revoker, Subject, Validator) and the rule that a Subject "MUST be referenced by DID", which the spec justifies as GUID-plus-public-key-verifiability so that "unforgeability prevents malicious namespace collisions which can lead to confused deputies". Also the resource model: resources are URI-identified and "unless explicitly stated, the Resource of a UCAN MUST be the Subject".

## Roles

| Name | Description |
|---|---|
| Agent | "The general class of entities and principals that interact with a UCAN" |
| Audience | "The Principal delegated to in the current UCAN. Listed in the `aud` field" |
| Executor | "The Agent that actually performs the action described in an invocation" |
| Invoker | "A Principal that requests an Executor perform some action that uses the Invoker's authority" |
| Issuer | "The Principal of the current UCAN. Listed in the `iss` field" |
| Owner | "A Subject that controls some external resource" |
| Principal | "An agent identified by DID (listed in a UCAN's `iss` or `aud` field)" |
| Revoker | "The Issuer listed in a proof chain that revokes a UCAN" |
| Subject | "The Principal who's authority is delegated or invoked" |
| Validator | "Any Agent that interprets a UCAN to determine that it is valid, and which capabilities it grants" |

## Subject

> "A Subject represents the Agent that a capability is for. A Subject MUST be referenced by DID. This behaves much like a GUID, with the addition of public key verifiability. This unforgeability prevents malicious namespace collisions which can lead to confused deputies."

The spec frames this with two epigraphs, Alan Kay's "at the very least every object should have a URL" and Joe Armstrong's "every Erlang process in the universe should be addressable and introspective".

## Resource

> "A resource is some data or process that can be uniquely identified by a URI. It can be anything from a row in a database, a user account, storage quota, email address, etc. Resource MAY be as coarse or fine grained as desired. Finer-grained is RECOMMENDED where possible, as it is easier to model the principle of least authority."

> "A resource describes the noun of a capability. The resource pointer MUST be provided in URI format. Arbitrary and custom URIs MAY be used, provided that the intended recipient can decode the URI."

> "Having a unique agent represent a resource (and act as its manager) is RECOMMENDED. However, to help traditional ACL-based systems transition to certificate capabilities, an agent MAY manage multiple resources."

> "Unless explicitly stated, the Resource of a UCAN MUST be the Subject."

## Issuer and Audience

> "The Issuer (`iss`) and Audience (`aud`) can be conceptualized as the sender and receiver (respectively) of a postal letter. Every UCAN MUST be signed with the private key associated with the DID in the `iss` field."

```js
"aud": "did:key:z6MkiTBz1ymuepAQ4HEHYSF1H8quG5GLVVQR3djdX3mDooWp",
"iss": "did:key:zDnaerDaTF5BXEavCrfRZEk316dpbLsfPDZ3WJ5hRTPFU2169",
```

Note the audience binding: a UCAN names who may use it, so a leaked token is not a bearer credential in the way an unguessable swissnum is. That is the single sharpest structural difference from an OCapN sturdyref.

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
