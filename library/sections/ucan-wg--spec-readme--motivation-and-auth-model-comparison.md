---
title: Motivation, and the ACL / certificate-capability / object-capability comparison
source: README.md
source_repo: ucan-wg/spec
source_commit: 9955aa1fb7b32897f80b57651f4ee8b22ebf35a7
source_date: 2026-07-08
source_authors: [Brooklyn Zelenka, Irakli Gozalishvili, Daniel Holmgren, Philipp Kruger]
ingested: 2026-07-28
ingested_by: scholar
topics: [ucan-authorization, capability-security, capability-theory]
status: current
---

> Abstract: Why UCAN chose a certificate-capability model over both access control lists and object capabilities, in the spec's own words. The decisive line for anyone weighing UCAN against an ocap reference: object capabilities require fail-safe behavior and locality preservation, and "the emphasis on consistency rules out partition tolerance", so UCAN "adopts a certificate capability model related to SPKI" precisely to buy offline operation and self-verifiability.

## The framing quote

> "If we practice our principles, we could have both security and functionality. Treating security as a separate concern has not succeeded in bridging the gap between principle and practice, because it operates without knowledge of what constitutes least authority."
>
> Miller et al, The Structure of Authority

## Why not ACLs

> "Since at least Multics, access control lists (ACLs) have been the most popular form of digital authorization, where a list of what each user is allowed to do is maintained on the resource. ACLs (and later RBAC) have been a successful model suited to architectures where persistent access to a single list is viable. ACLs require that rules are sufficiently well specified, such as in a centralized database with rules covering all possible permutations of scenario. This both imposes a very high maintenance burden on programmers as a systems grows in complexity, and is a key vector for confused deputies."

> "With increasing interconnectivity between machines becoming commonplace, authorization needs to scale to meet the load demands of distributed systems while providing partition tolerance. However, it is not always practical to maintain a single central authorization source."

## The choice

> "Two related models that work exceptionally well in the above context are Simple Public Key Infrastructure (SPKI) and object capabilities (OCAP). Since offline operation and self-verifiability are two requirements, UCAN adopts a certificate capability model related to SPKI."

## The three intuition pumps

The spec offers analogies it flags as "only accurate enough to build intuition", pointing at *Capability Myths Demolished* for the rigorous treatment.

**Access control lists** are "like a bouncer at an exclusive event" with a list of attendees and VIPs, checking government-issued ID. "If there are many such events at many venues, the organizers need to coordinate ahead of time, denials need to be synchronized, and attendees need to show their ID cards to many bouncers."

**Certificate capabilities**, that is UCANs, "work more like movie tickets or a festival pass. No one needs to check your ID; who you are is irrelevant. ... If you cannot attend an event, you can hand this ticket to a friend who wants to see the film instead, and there is no coordination required with the theater ahead of time. However, if the theater needs to cancel tickets for some reason, they need a way of uniquely identifying them and sharing this information between them."

That last clause is the revocation cost, stated up front: transferability without coordination is exactly what makes cancellation require coordination.

**Object capabilities** "use a combination of references, encapsulated state, and proxy forwarding. ... Object capabilities are robust, flexible, and expressive. To achieve these properties, object capabilities have two requirements: fail-safe, and locality preservation. The emphasis on consistency rules out partition tolerance."

## Translation

| UCAN spec term | Nearest Endo / OCapN idiom |
|---|---|
| certificate capability | a signed, transferable authorization token; no direct Endo analogue |
| object capability | an unforgeable reference obtained over CapTP |
| Subject | the vat or object that owns the resource |
| proof chain | the delegation provenance; an OCapN sturdyref has no in-band equivalent |
| Executor | the vat that actually performs the operation |

Source: [`README.md`](https://github.com/ucan-wg/spec/blob/9955aa1fb7b32897f80b57651f4ee8b22ebf35a7/README.md) at commit `9955aa1f`.
