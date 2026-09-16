---
title: "Authodox and formal analysis of object-capability patterns"
source_kind: mailing-list-archive
source_urls: [http://www.eros-os.org/pipermail/cap-talk/2008-May/, http://www.eros-os.org/pipermail/cap-talk/2008-June/]
source_snapshots: [https://web.archive.org/web/20160729233944id_/http://www.eros-os.org/pipermail/cap-talk/2008-May.txt.gz, https://web.archive.org/web/20160730013556id_/http://www.eros-os.org/pipermail/cap-talk/2008-June.txt.gz]
source_content_sha256: [13c48bf7017b5ee38ad427e2973467e30a03d4ed082784e6b4125def1a67bac6, a4cfb1b917b31df724056579d31a283113e1190719cb30ce760a6cc39f5926d5]
source_authors: [Toby Murray, Mark S. Miller, Matej Kosik, Bill Frantz, Jonathan S. Shapiro, Neal H. Walfield, Charles Landau, David Wagner, David-Sarah Hopwood]
source_date: 2008-05-20 to 2008-06-02
thread_subject: "Announcing Analysing Object-Capability Security and Authodox v0.2.0"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
notes: "Derived summary across two monthly bundles, not the original messages."
---

Abstract: Toby Murray's Authodox work models interacting objects in CSP to check capability-pattern security across concurrency semantics. The central finding is portability-sensitive: a revoker, membrane, or other pattern that preserves its property under one call/return model can subtly fail when moved to a system with different interleaving, reentrancy, or concurrency rules.

The announcement frames patterns as composable security-enforcing abstractions and argues that earlier formalisms cannot express properties such as revocation while varying the host execution model. Review turns on how faithfully CSP represents references, identity, calls, and the powerbox/membrane structures being analyzed. CSP is the modeling language, not itself the object-capability language.

For Endo, the durable lesson is that a pattern name is not a proof. A caretaker or membrane implementation must state the turn model and reentrancy assumptions under which its authority claim holds, then test the implementation against those assumptions.

Source: cap-talk [2008-May](http://www.eros-os.org/pipermail/cap-talk/2008-May/) and [2008-June](http://www.eros-os.org/pipermail/cap-talk/2008-June/) archives (Internet Archive original-bytes snapshots, sha256 `13c48bf7` and `a4cfb1b9`), messages dated 2008-05-20 to 2008-06-02.
