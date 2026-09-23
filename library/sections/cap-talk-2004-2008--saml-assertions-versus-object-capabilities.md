---
title: "SAML assertions versus live object capabilities"
source_kind: mailing-list-archive
source_urls: [http://www.eros-os.org/pipermail/cap-talk/2008-April/, http://www.eros-os.org/pipermail/cap-talk/2008-June/]
source_snapshots: [https://web.archive.org/web/20160730000846id_/http://www.eros-os.org/pipermail/cap-talk/2008-April.txt.gz, https://web.archive.org/web/20160730013556id_/http://www.eros-os.org/pipermail/cap-talk/2008-June.txt.gz]
source_content_sha256: [bd1eab915fd5818954c5696ea629419eb03854f6afdf544ed2bdcc398f122872, a4cfb1b917b31df724056579d31a283113e1190719cb30ce760a6cc39f5926d5]
source_authors: [Alan H. Karp, Mark S. Miller, Kevin Reid, Jed Donnelley, Toby Murray, Baldur Johannsson, David Chizmadia]
source_date: 2008-04-23 to 2008-06-05
thread_subject: "SAML assertions as capabilities vs. ocaps"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, captp]
status: current
notes: "Derived summary across two monthly bundles, not the original messages."
---

Abstract: A signed SAML assertion can act as an offline bearer authorization, but it is not by itself an object capability system. It carries a statement to be interpreted by a policy-aware service, while live ocap references compose through object protocols, local forwarding, attenuation, and revocation without requiring each target to recover a global subject identity.

The comparison focuses on delegation chains. SAML can serialize claims and move them across disconnected boundaries, but chains grow and each verifier must understand issuers, scopes, and residual rights. An ocap chain can remain a graph of forwarders inside one vat or connected system; Kevin Reid sketches serializing an offline-delegation proxy only when the reference must cross that boundary.

The useful synthesis is layered rather than equivalent: an assertion may bootstrap or serialize a capability, after which invocation should proceed through a live reference protocol. For Endo, this mirrors the sturdyref/CapTP split: durable authorization material locates or restores authority, while CapTP enforces reference-based communication.

Source: cap-talk [2008-April](http://www.eros-os.org/pipermail/cap-talk/2008-April/) and [2008-June](http://www.eros-os.org/pipermail/cap-talk/2008-June/) archives (Internet Archive original-bytes snapshots, sha256 `bd1eab91` and `a4cfb1b9`), messages dated 2008-04-23 to 2008-06-05.
