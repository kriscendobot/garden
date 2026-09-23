---
title: "Web-keys: mashing with permission"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-January/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2008-January.txt.gz
source_content_sha256: ce38d02ecb86b616cd368323276a011c99b960681b19f6cafd5f9c6ebc4d4949
source_authors: [Tyler Close, Toby Murray, Jed Donnelley, Alan H. Karp, James A. Donald, Sandro Magi, Mark S. Miller, Jonathan S. Shapiro, Bill Frantz, John Carlson, Kevin Reid, David-Sarah Hopwood]
source_date: 2008-01-15 to 2008-02-01
thread_subject: "A paper on web-keys"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, patterns]
status: current
notes: "Derived summary, not the original messages; cross-linked to Tyler Close's later ACL analysis."
---

Abstract: Tyler Close presents the rejected WWW 2008 paper *web-key: Mashing with Permission* for list review. A web-key is an unguessable URL whose possession authorizes a REST operation. It moves the access decision to the point where a reference is constructed or handed out, so independently developed web applications can compose without a shared identity database or ambient cookie authority.

The discussion focuses on discretionary control, revocation, persistence, and developer expectations. A capability holder can delegate by copying the URL or proxying requests, so a server generally cannot enumerate every effective holder. Revocation therefore needs indirection, expiry, rotation, or application-specific structure. Transparent persistence also requires object graphs and references to survive restarts without silently widening authority.

The later [web-attacks section of *ACLs Don't*](../sections/papers--close-acls-dont-2009--web-attacks-csrf-clickjacking-clickfraud-and-the-web-key-fix--body.md) gives this idea its published confused-deputy framing: CSRF's anti-forgery token is a transition from ACL-by-cookie toward capability-by-reference. The list thread preserves the design review that precedes that formulation.

Source: [cap-talk 2008-January archive](http://www.eros-os.org/pipermail/cap-talk/2008-January/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2008-January.txt.gz`, sha256 `ce38d02e`), messages dated 2008-01-15 to 2008-02-01.
