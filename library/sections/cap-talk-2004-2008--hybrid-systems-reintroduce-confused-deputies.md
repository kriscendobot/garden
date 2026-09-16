---
title: "Hybrid systems reintroduce confused deputies"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2008-February.txt.gz
source_content_sha256: 6311a1d96d5fd5efa6d7e5ab1fd2fdf1d5372b3a5b260450839bf424ca74d3ce
source_authors: [David-Sarah Hopwood, Alan H. Karp, Toby Murray, Jed Donnelley, Jonathan S. Shapiro, Bill Frantz, Mark S. Miller, David Wagner, Sandro Magi, Kevin Reid]
source_date: 2008-02-03 to 2008-02-12
thread_subject: "Confused deputies in hybrid systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages; direct precursor to Close's ACLs Don't caveat."
---

Abstract: The 2008 hybrid-system thread rejects the slogan that a pure object-capability substrate makes every application unconfusable. An application can rebuild ACL-style checks, ambient lookup, firewalls, or implicit rights amplification on top of capabilities. Once it does, a deputy may again combine authority from one source with a designation or policy decision from another.

David-Sarah Hopwood argues that weaker access-control mechanisms are an attractive nuisance when a stronger reference-based mechanism is available. Alan Karp and others examine membranes and inside/outside distinctions, but the list finds no universal wrapper that makes an arbitrary ACL-shaped policy capability-safe. Explicit rights amplification such as an unsealer can be audited at the line that performs it; implicit amplification through surrounding policy is harder because the decisive authority may live elsewhere.

This is the on-list form of Close's later application caveat in [*ACLs Don't*](../sections/papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat--body.md): capability infrastructure is necessary but not sufficient. The diagnostic is whether an attacker-chosen identifier crosses a deputy before the access decision that should have accompanied its construction.

Source: [cap-talk 2008-February archive](http://www.eros-os.org/pipermail/cap-talk/2008-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2008-February.txt.gz`, sha256 `6311a1d9`), messages dated 2008-02-03 to 2008-02-12.
