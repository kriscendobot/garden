---
title: "Capabilities As A Cryptographic Protocol (the Pluribus distributed handshake)"
source_kind: web
source_url: https://erights.org/elib/capability/ode/ode-protocol.html
source_effective_url: https://erights.github.io/erights-org-website/elib/capability/ode/ode-protocol.html
source_fetched_via: mirror
source_content_sha256: ff1dbcf5e0bc3327d33e73c53b8c767559f2992532c9530f91b023e66ea17fc3
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [captp, capability-security, capability-theory]
status: current
notes: |
  HTML companion chapter of the 2000 Financial Cryptography paper "Capability-Based
  Financial Instruments" (Miller, Morningstar, Frantz), fetched 2026-06-27 from the
  erights.github.io mirror via scripts/jobs/fetch-source.sh (erights.org refuses
  sandbox connections). Idempotency anchor is source_content_sha256. SOFT-FLAG
  cross-source overlap with the FC2000 paper section
  [pluribus-rights-taxonomy-and-covered-call-option](papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option.md):
  that section SUMMARIZES Pluribus (VatID + swiss number + subjective aggregation)
  as one argument cluster; this chapter is the standalone, step-by-step protocol
  treatment (proxies, the four-step message encode/decode, the SSL-like handshake
  without certificates and with perfect forward secrecy, the impostor problem in
  both directions). Kept current because it adds the protocol mechanics the
  collapsed paper section omits. Subjective aggregation also has its own concept
  page [subjective-aggregation](../concepts/subjective-aggregation.md).
---

## Abstract

The HTML companion to the FC2000 paper's distributed-protocol chapter: how **Pluribus**, E's communications protocol, provides the Granovetter Operator (Alice introduces Bob to Carol by sending `bob.foo(carol)`) with all its security properties even when Alice, Bob, and Carol live in separate vats on separate machines. This chapter is the step-by-step protocol mechanics the collapsed FC2000 library section only summarizes: vats as persistent address-spaces of objects each with a public/private key pair (the public-key fingerprint is the **VatID**); **proxies** as the local representatives of remote objects; the four-step encode-send-decode-deliver message path; the unguessable per-object **swiss number** assigned at first export; and the inductive handshake that establishes a secure Bob-to-Carol arrow from preexisting Alice-Bob and Alice-Carol arrows. The handshake follows SSL's shape but uses **no certificates** and adds **perfect forward secrecy**: VatB contacts the alleged VatC, verifies its public key against the VatID fingerprint, the two run Diffie-Hellman to a per-connection session key, and only then does VatB reveal Carol's swiss number. The chapter names the **impostor problem in both directions** (the VatID stops a fake Carol; the swiss number stops a fake Bob) and closes with the **subjective aggregation** argument ("only trust makes distinctions"). Use this to ground claims about how E/CapTP enacts capability semantics across machines, the role of VatID vs swiss number, or why Pluribus needs no certificate authority.

## Distributed objects: vats and proxies

Objects are aggregated into units called **vats**. Each E object exists in exactly one vat (its host); a vat typically hosts many objects. Each vat exists on one machine at a time, but a machine may host many vats. A good first approximation is to think of a vat as a process full of objects, an address space full of objects plus a thread of control. Unlike a typical OS process, a vat **persists**: its state is saved to persistent storage when its hosting process is terminated or interrupted, so a vat-hosting OS process is an *incarnation* of the vat, and the vat maintains its identity and state as it passes serially through a sequence of incarnations.

To let objects in separate vats send messages to each other, the protocol bridges from local intra-address-space language implementation to network communication. Each vat contains a communications system that makes and accepts connections to other vats. That system contains objects called **proxies**. When an object in one vat refers to an object in a different vat, it actually refers to a proxy, the local representative of the remote object. When a proxy `b1` is sent a local message (step 1), it encodes the message arguments `c1` into a packet and sends it as a network message (step 2). When the receiving vat (VatB) receives the network message, it decodes it into a message local to VatB, **handshaking with remote vats (VatC) as necessary to create the needed proxies** (`c2`, step 3). The decoded message is finally delivered to the target object Bob (step 4).

This four-step path describes equally well many distributed object systems (CORBA, RMI) that have no capability-security ambitions. The rest of the chapter is what makes it a *secure* protocol.

## Cryptographic capabilities: VatID, swiss number, and the handshake

On creation, each vat generates a **public/private key pair**. The fingerprint of the vat's public key is its **vat Identity (VatID)**. The VatID designates only a vat that knows and uses the corresponding private key according to the protocol.

Within a single vat a capability-arrow is a traditional memory-address pointer, and intra-address-space capability security is built from safe-language techniques (popularized by Java, going back to LISP 1.5 and ALGOL 60). A capability-arrow can also cross between vats: if Alice, Bob, and Carol are in three separate vats, Alice talks to Carol only because VatA can talk to VatC over a secure, authenticated inter-vat connection. The interesting property is **inductive correctness**: assuming a preexisting secure connection between Alice and Bob, and another between Alice and Carol, can we establish a similarly secure connection between Bob and Carol?

When VatC first exported a capability to Carol across a vat boundary, it assigned Carol an unguessable, randomly chosen **swiss number** (named for the knowledge-is-authority logic loosely attributed to Swiss bank accounts). When VatA first received that capability, VatA thereby learned Carol's swiss number and VatC's VatID.

When Alice sends Bob a reference to Carol, VatA tells VatB Carol's swiss number and VatC's VatID. VatB now wants the tail of a vat-crossing capability-arrow that refers directly to Carol, so it can deliver that arrowtail to Bob. The handshake:

1. VatB contacts an alleged VatC (using location routing/hint information that Pluribus allows to travel with the VatID) and asks for VatC's public key.
2. VatB verifies that the key matches the fingerprint it was told is VatC's VatID.
3. The handshake then proceeds along the lines of **SSL, but without certificates and with perfect forward secrecy**: VatC proves knowledge of the corresponding private key, then **Diffie-Hellman** key agreement produces a shared session key for the duration of the inter-vat connection.
4. Only once an authenticated, secure data pipe exists between them does VatB reveal Carol's swiss number to VatC, letting VatC associate messages (sent inside VatB to the proxy `c2`, encoded over the network to VatC) with Carol.

## The impostor problem in both directions

A capability is an arrow, and an arrow has two ends; there is an impostor problem at each end. The **VatID** ensures that the vat Bob is speaking to is the one hosting the object Alice meant to introduce him to (no fake Carol). The **swiss number** ensures that the entity allowed to speak to Carol is the one Alice chose to enable (no fake Bob). Together they make the inductive step sound: a new secure Bob-to-Carol arrow is built from the two preexisting arrows without trusting the network.

## Subjective aggregation: only trust makes distinctions

The chapter closes with the **subjective aggregation** argument (covered at the same level by the FC2000 paper section and given its own [subjective-aggregation](../concepts/subjective-aggregation.md) concept page; recorded here for chapter completeness). Carol's swiss number is not revealed to VatB until someone reveals it to an object such as Bob that VatB hosts, yet Alice must trust that VatB does not then leak Carol's access to other objects (Joe) it hosts, because by sending VatB the swiss number Alice has enabled it to do so. There are two simultaneous forms of mutual suspicion: inter-vat (inter-machine) and inter-object. It is a mistake to trust Bob more than you trust VatB: to the objects within a vat, the hosting vat is their **Trusted Computing Base**, and their operation is entirely at its mercy. So Bob's behavior is an aspect of VatB's behavior. Only if Alice trusts VatB to play by capability rules does it make sense for her to reason about Bob as separately trusted from Joe; if she does not, she should model VatB as a single monolithic composite with Bob and Joe as facets, and Pluribus grants that composite exactly the authority capability rules say it should get. Put another way, **mistrust of a vat is equivalent to ignorance of the internal relationships among its objects**: a malicious vat hosting one set of objects can only cause external effects equivalent to a correct vat hosting some different (maliciously coded) set. This is the main economy of the distributed capability model: we can, without loss of generality, reason as if we are only suspicious of objects.

Source: [elib/capability/ode/ode-protocol.html](https://erights.github.io/erights-org-website/elib/capability/ode/ode-protocol.html) via the erights.github.io mirror; content SHA-256 `ff1dbcf5`.
