---
title: "Google Docs share links as incomplete webkeys"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-January.txt.gz
source_content_sha256: 57a1878237df49ba47d5b3708f4115f2f3f6110271a37f704fdb5decb1dce700
source_authors: [Jed Donnelley, Tony Arcieri, Kenton Varda, Marc Stiegler, Dirk Pranke, David Barbour, Rob Meijer, Alan Karp, Domenico Rotondi, Raoul Duke, David Bruant, Bill Frantz]
source_date: 2014-01-26 to 2014-01-31
thread_subject: "Google Docs as capabilities as data"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, revocation]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Google Docs “anyone with the link” sharing demonstrates that users value bearer-style delegation even when a product did not set out to build an object-capability system. Varda, formerly on the sharing team, names the missing pieces: one URL selects only one global access level, distinct recipients cannot receive separately revocable links, a leak cannot be repaired by rotating one recipient's reference, and logged-in identity is deliberately hidden to prevent identity harvesting. Stiegler argues that per-recipient webkeys and a visible grant list would restore the same individual revocation users expect from ACL interfaces without making identity the access check.

The thread also catalogs browser leakage. Secret path components can enter history, autocomplete, logs, and `Referer` headers; putting the secret in a URL fragment keeps it out of HTTP requests, after which trusted client code can move it into an authorization channel. TLS protects transport but does not stop the browser and application from mishandling the bearer secret.

Source: [cap-talk 2014-January archive](http://www.eros-os.org/pipermail/cap-talk/2014-January/) (Internet Archive original-bytes `id_` snapshot of `2014-January.txt.gz`, sha256 `57a18782`), thread "Google Docs as capabilities as data", 2014-01-26 to 2014-01-31.
