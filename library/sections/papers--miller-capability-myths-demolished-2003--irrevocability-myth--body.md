---
title: Body
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
parent: papers--miller-capability-myths-demolished-2003--irrevocability-myth
---

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

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
