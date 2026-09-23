---
title: "Capabilities As A Public Key Infrastructure (the SPKI comparison)"
source_kind: web
source_url: https://erights.org/elib/capability/ode/ode-pki.html
source_effective_url: https://erights.github.io/erights-org-website/elib/capability/ode/ode-pki.html
source_fetched_via: mirror
source_content_sha256: 23d89b7958af168db2c3374274295f21f2d546b35c0562c1a876492d0985743d
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: |
  HTML companion chapter of the 2000 Financial Cryptography paper "Capability-Based
  Financial Instruments" (Miller, Morningstar, Frantz), fetched 2026-06-27 from the
  erights.github.io mirror via scripts/jobs/fetch-source.sh (erights.org refuses
  sandbox connections). Idempotency anchor is source_content_sha256. This chapter
  carries material the FC2000 paper section set OMITS: the FC2000 source-index
  explicitly records "§5's PKI comparison ... supporting material that doesn't
  carry distinct theoretical content beyond the three retained sections", so the
  capability-vs-SPKI comparison is absent from the library otherwise. Companion to
  [ode-protocol](erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md);
  the confused-deputy treatment here complements the POLA/confused-deputy section in
  Capability Myths Demolished (papers--miller-capability-myths-demolished-2003).
---

## Abstract

The HTML companion to the FC2000 paper's PKI chapter, and the one Ode chapter whose substance the library's FC2000 paper sections deliberately dropped (the FC2000 source-index flags §5's PKI comparison as supporting material not retained). It compares the object-capability model against a **public key infrastructure**, using **SPKI (RFC 2693)** as the concrete example because it has the most capability-like protocol (the same functions are achievable with X.509 v3). The chapter walks SPKI's authorization-certificate mechanism (an **Issuer** signs a certificate naming issuer key, subject key, the authorization, validity period, and an unenforceable delegation flag; the **Subject** presents a certificate chain to a **verifier**), then reads the **Granovetter Diagram for a PKI** to surface four structural differences from a capability system: **(1) no direct Issuer-to-Subject link** (authorizations can be posted publicly or anonymously, entirely offline, in the clear, with no way to confine the issuer); **(2) the resource need not be an object** (the verifier acts as a gatekeeper applying conventional access control); **(3) auditing falls out naturally** (record the issuer and subject public keys, whereas Pluribus needs intermediary objects to track the authorization path); and **(4) the confused-deputy risk** (because an SPKI authorization carries no direct designation of the resource, it admits Hardy's confused deputy, minimizable only by keeping authorizations narrow). It closes on **cost**: SPKI authorization is expensive (at least two signature verifications per decision plus a challenge signature against replay), versus Pluribus where public-key operations are confined to connection setup; SPKI's Certificate Result Certificate collapses a chain to amortize this. Use this whenever a design weighs capabilities against certificate/PKI authorization, or needs the canonical confused-deputy-from-PKI framing.

## SPKI as the most capability-like PKI

It is illuminating to compare and contrast the capability model with a public key infrastructure. For concreteness the chapter examines **SPKI (RFC 2693, Ellison99)** because it has the most capability-like protocol, though all the functions discussed can also be performed with suitable use of **X.509 version 3**. SPKI is concerned with the specification and transfer of **authorizations**: examples include the ability to access an FTP directory, use a network printer, or log on to a remote system.

In SPKI, the entity wishing to transfer an authorization, the **Issuer**, signs a **certificate** specifying the Issuer's public key, the **Subject's** public key, the authorization, the validity period, and an admittedly unenforceable (Ellison99 §4.1.4) indication of whether the Subject may further delegate. When the Subject wishes to exercise an authorization, it presents a **chain of certificates** to a **verifier**, which checks the signatures and verifies that the Subject holds the private key corresponding to the public key in the certificate. This ensures the Subject received the authorization from an authorized issuer.

## Reading the Granovetter Diagram for a PKI: four differences

When we draw the Granovetter Diagram for a public key infrastructure, several significant differences from the capability diagram appear:

- **No direct link between Issuer and Subject.** The SPKI authorization could be anonymously posted to a USENET newsgroup or sent through an anonymous remailer. Because the Subject identifies itself by possessing the private half of a key pair, the Issuer need only sign the certificate and publicly post it. The entire process can take place **offline**; except for keeping the private keys secret, no secrecy is needed and all communications can be "in the clear". There is **no way of confining the Issuer** to limit the entities it can authorize. The absence of an Issuer-to-Subject line in the diagram reflects this.
- **The resource need not be an object.** The verifier that checks the authorization acts as a **gatekeeper**, the way Pluribus gatekeeps distributed E objects, but the authorizations can be interpreted using conventional access control techniques rather than object references.
- **Auditing falls out naturally.** In an SPKI system, auditing who performed an action and who authorized it falls out of the public-key structure: the auditor records only the public keys of the issuer and subject. Auditing in a Pluribus system instead requires introducing **intermediary objects** that accompany each rights transfer to track the authorization path.
- **Confused-deputy risk.** Because an SPKI authorization does not include a direct designation of the resource being authorized, it introduces the possibility of a **confused deputy (Hardy88)**: a deputy uses an authorization given to it by one party to access a resource designated by a different party, performing an unintended rights transfer. If the authorizations are narrow, this problem can be minimized.

## Cost

Authorization in SPKI is **expensive**. At a minimum each authorization decision requires two signature-verification operations by the verifier: the signature on the certificate must be checked, and the Subject's signature proving possession of the private key must also be checked. In addition, the Subject must sign a challenge from the verifier if the system is to stay safe from replay attacks. Compare this with **Pluribus, where the public-key operations are limited to connection establishment**. In recognition of the cost, SPKI provides the **Certificate Result Certificate**, which collapses an entire certificate chain into a single certificate.

Source: [elib/capability/ode/ode-pki.html](https://erights.github.io/erights-org-website/elib/capability/ode/ode-pki.html) via the erights.github.io mirror; content SHA-256 `23d89b79`.
