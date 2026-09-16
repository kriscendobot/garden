---
title: "Off-line capability representation versus on-line capability protocol"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2001-July/
source_snapshot: http://web.archive.org/web/20060613194941id_/http://www.eros-os.org/pipermail/cap-talk/2001-July.txt.gz
source_content_sha256: 7e0ec8b293ccc94a2fbef27573b7a83d5e5ab9a38cb00d46e2f0531776f6931e
source_authors: [David L. Nicol, Mark S. Miller, John Stracke, Roland H. Alden, Valerio Bellizzomi, Al Gilman]
source_date: 2001-07-10
thread_subject: "Is there a capability RFC?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, captp]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: David L. Nicol asks (2001-07) whether a standard capability protocol exists, motivated by wanting to secure iCalendar/MIME by tagging events with the capability under which they were posted. Mark Miller's reply draws the distinction that organizes the whole area: a **standard off-line capability representation** (bits you can carry or store in ordinary non-capability media) is a different thing from an **on-line capability protocol** (the live wire protocol that makes possession-authorizes-invocation hold). He then maps the landscape of 2001: SPKI is "approximately a capability system" but falls short; E's `cap://` URI rides the Pluribus/VatTP/CapTP stack; Waterken encodes the same information into an `https:` string. John Stracke supplies the standing counterpoints: capabilities do not stop denial-of-service, and a capability *is* a mutual-trust relationship rather than a way to abolish one. The thread is the primary-source root of the off-line-representation-vs-on-line-protocol split that CapTP and later OCapN keep distinct.

## The distinction Miller draws

Miller: "The rest of your message shows that you are not thinking of a protocol, but rather a standard representation for distributed capabilities that can be carried or stored in conventional non-capability media. Let us call this an off-line capability representation." He then splits the answer by layer.

For off-line capabilities supporting off-line protocols: "start with SPKI. SPKI is approximately a capability system, as explained at ode-pki.html. It falls short of being a capability system in the ways explained at capcert.org ... HP's E-Speak system started as a capability system (actually a split capability system, an interesting variant). But starting with E-Speak 3.0, they are using SPKI certificates as if they are capabilities."

For off-line representations supporting on-line protocols, "there are two": E's `cap://...` URI string, whose on-line protocol is Pluribus / VatTP / CapTP; and Waterken, which "has a very clever way to encode essentially the same information as E's cap: URI into an https: string, and then to layer their protocol on top of https." (See the E [ode-protocol Pluribus section](erights--elib-capability-ode-ode-protocol--distributed-pluribus-cryptographic-protocol.md) and [ode-pki SPKI comparison](erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure.md).)

## What a distributed capability is for (Nicol) and is not (Stracke)

Nicol's working definition: "capability is a robust method for delegating (and rescinding, and tracking) authority of all kinds. Not Authenticity, but Authority." His everyday examples are X session cookies, mailing-list confirmation codes, and CGI shopping-cart cookies. Roland Alden supplies a primer tracing capabilities to the Cambridge Ring, Multics, the Intel 432, and the Symbolics Lisp Machine: "a hard-to-forge / tamperproof pointer-like token which provides the bearer with a certain set of rights over a resource."

John Stracke's counterpoints are the reusable part of the thread:

- **Capabilities do not defeat denial-of-service.** "There is simply no way for an access control mechanism to prevent DoS attacks, because an effective attack can be mounted just by making lots of bogus requests, to force the access control system to come into play. A more sophisticated access control system may actually be a liability, if it requires more computrons to evaluate each request."
- **A capability is a mutual-trust relationship, not its abolition.** "Could you expand on how capabilities would let us do away with mutual trust relationships? It seems to me that a capability actually encodes a mutual trust relationship."
- **Standardization follows experience.** "The IETF generally avoids trying to do things that do not have wide experience yet." Implementers should experiment first; Al Gilman suggests the Global Grid Forum as a more receptive venue.

Valerio Bellizzomi adds the lifetime facets that recur throughout the corpus: a one-time capability is the upper-use-limit set to 1 ("this sounds like Kerberos tickets"), and an expiry date is "an automatic revocation mechanism that forces the capabilities to be invalidated when the duration expires."

## Translation

| cap-talk 2001 term | Endo / OCapN reading |
|---|---|
| off-line capability representation | a serialized/persisted capability (a sturdyref, a swiss-number URL) |
| on-line capability protocol | the live protocol enforcing possession-authorizes-invocation (CapTP) |
| E `cap://` URI + Pluribus | the sturdyref-plus-transport ancestor of CapTP / OCapN locators |
| Waterken `https:` encoding | the web-key discipline (capability-as-unguessable-URL) |
| SPKI "approximately a capability system" | authorization certificate; not an object capability (see [SPKI comparison](erights--elib-capability-ode-ode-pki--capabilities-as-a-public-key-infrastructure.md)) |

Source: [cap-talk 2001-July archive](http://www.eros-os.org/pipermail/cap-talk/2001-July/) (Internet Archive original-bytes snapshot `web/20060613194941id_/.../2001-July.txt.gz`, sha256 `7e0ec8b2`), messages by David L. Nicol, Mark S. Miller, John Stracke, Roland H. Alden, Valerio Bellizzomi, and Al Gilman, 2001-07-09 to 2001-07-16.
