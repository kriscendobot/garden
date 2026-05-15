---
title: The Irrevocability Myth (the forwarder/revoker pattern, a.k.a. caretaker)
source: Capability Myths Demolished (SRL2003-02)
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_year: 2003
source_venue: JHU SRL Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
---

## Abstract

The Irrevocability Myth claims "capabilities cannot revoke access." The paper acknowledges the literal version is correct — "the capability alone is sufficient to establish access to the resource. These two facts might lead one to reasonably believe that there is no opportunity to revoke access." But the literal version misses the right question: in object-capability systems, an indirect capability *can* revoke. The construction the paper presents is the **forwarder + revoker pair** (Figures 6 and 13 of the paper): Alice gives Bob access not to Carol directly but to a forwarder facet F; Alice retains a revoker facet R; both F and R reference Carol. When Alice wants to revoke Bob's access, she invokes R, which tells F to drop its reference to Carol. F still exists but is now useless. The paper notes "this scheme is not a recent invention. Redell described exactly this method for revoking access in 1974 [18]," and KeyKOS and EROS both implemented optimized versions.

The Endo lineage knows this pattern as the **caretaker pattern**, and this paper is the upstream origin citation for that name's referent.

## Body

### The challenge stated

The paper opens with a 2001 quote (Chander, Dean, Mitchell [3]): "Capability systems modelled as unforgeable references present the other extreme, where delegation is trivial, and revocation is infeasible." The authors concede the surface plausibility:

> This belief stems from the fact that, once a subject holds a capability, no one but the subject can remove that capability, not even the creator of the corresponding resource. It is true that the capability tokens themselves are not literally revocable. Further, we know that the capability alone is sufficient to establish access to the resource.

But this framing answers the wrong question. Capability tokens are not revoked; *the resource the token references* is replaced with one that no longer forwards.

### The forwarder/revoker construction

The paper's Figure 6 shows Alice's solution:

> Suppose once again that Alice wants to give Bob access to Carol, but Alice also wants to have the option to revoke this access at some time in the future. To accomplish this, Alice could simply create a pair of forwarders, F and R, connected as shown. ... Of this pair, we may call F the *forwarding facet* and R the *revoking facet*. Alice would send Bob access to F, and retain R for herself. Any messages sent to F get forwarded through R to Carol, so Bob may use F as if it were Carol. This works as long as inter-object interactions are mediated by messages, and messages are handled generically, so that a reusable mechanism can forward any message.

The revocation is then trivial:

> When Alice wants to revoke Bob's access to Carol, she invokes R, telling it to stop forwarding. R then drops its pointer to Carol, and F becomes useless to Bob.

The argument generalizes to *delegated* revocation: "This revocation mechanism also works for delegated authorities. Suppose Bob delegates to Ted his access to Carol. Since Bob only ever has access to F, not to Carol herself, Bob can only give F to Ted... When Alice invokes R in order to disable F, this action prevents further access to Carol by Ted, by anyone to whom Bob sent his capability, just as much as it prevents access by Bob."

### The historical lineage

The paper situates the construction in historical perspective:

> This scheme is not a recent invention. Redell described exactly this method for revoking access in 1974 [18], and it was later implemented in the CAP-III system [12]. Karger addresses the concern that "indirection through a large number of revoker capabilities could adversely affect system performance" by suggesting that "a properly designed translation buffer, however, could cache the result of the capability indirections and make most references go quickly". KeyKOS [9] and EROS [21] both employ this optimization technique.

So by 2003 the construction had a 30-year track record across at least three implemented operating systems.

### Property F is required

The paper notes parenthetically that the forwarder/revoker construction depends on Property F (Access-Controlled Delegation Channels): "Observe that without Property E [composability of authorities], we cannot construct revocable forwarders to solve the revocation problem." The forwarder's ability to receive a message *and forward it via its own capability* requires composability — F must be both subject (it sends to Carol) and resource (Bob sends to it). The capabilities-as-keys model (Model 3) does not have this property; that is why the Irrevocability Myth seems true under Model 3 (see Section: four-models-and-seven-properties).

## Translation

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| forwarder F + revoker R | the [[caretaker-pattern]]: Handle (action facet, action-side) + HandleControl (control facet, principal-side) |
| forwarding facet | "action facet" in Endo's [[delegates-and-epithets]] vocabulary |
| revoking facet | "control facet" in Endo's vocabulary; held by the principal not the delegate |
| forwarder caches the result of indirection | the daemon's GC + retention-accumulator design implicitly does this for live references; on cohort-destruction the cache resets |
| invoke R to stop forwarding | call `revoke()` on the HandleControl; daemon stops vending the underlying capability |

## Implications for Endo

This paper is the **canonical upstream citation** for the caretaker pattern in the Endo lineage. The Endo daemon's specific revocation discipline — Handle / HandleControl, vendor-side credentials retained in the control facet, action-side reference held by the delegate — is the same forwarder/revoker construction with names that emphasize the *agent identity* application of the pattern rather than the bare access-control mechanic.

The Endo daemon adds one variation the paper does not name: [[revocation-by-withdrawal]]. The paper's forwarder/revoker pattern requires the revoker R to remain alive to enforce revocation. Endo's formula-graph design adds a structurally distinct revocation mechanism: withdraw the *constructor* (the formula's recipe), and the next time the cohort tries to reconstruct, the dependency is gone. Where caretakers require the principal to remain online to enforce, withdrawal-of-constructor does not. See [[revocation-by-withdrawal]] for the contrast with the caretaker pattern, and the section on `dp/acyclic-formula-graph-and-revocation` for the design's explicit list of three pre-existing mechanisms (caretakers, revocation lists, expiry) it contrasts with.

The phrase the paper coins for the F-and-R decomposition — *forwarding facet* and *revoking facet* — is the source of Endo's *facet* vocabulary in `defineExoClassKit`. An exo class kit defines multiple facets sharing state; the canonical example is the {forwarder, revoker} kit, which is exactly the paper's construction expressed in modern E / Endo idiom.

## Common confusions

- **"Capability tokens are not revocable."** Literally true; capability *access* is revocable, by replacing the reachable resource with one that no longer forwards. The Endo-lineage primary terminology emphasizes the latter (we speak of revoking *access* or *the delegate's ability to act through this handle*), not the former.
- **"Caretakers must remain alive to enforce revocation."** Holds for the paper's basic forwarder/revoker construction. Endo's `revocation-by-withdrawal` is a *structurally distinct* mechanism that does *not* require the principal to remain alive — see [[revocation-by-withdrawal]].

## See also

- [[caretaker-pattern]] — the Endo / E name for this construction; this paper is the origin citation.
- [[revocation-by-withdrawal]] — the formula-graph mechanism that contrasts with caretakers (does not require the principal to remain alive).
- [[delegates-and-epithets]] — the Endo daemon's specific application of caretakers to agent / connector identity.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
