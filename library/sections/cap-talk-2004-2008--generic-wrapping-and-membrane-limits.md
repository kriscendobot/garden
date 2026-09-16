---
title: "Generic wrapping and membrane limits"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-January/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-January.txt.gz
source_content_sha256: be281f3e6a7d6713a9751304edbb15cddf46adfe070a5384084d45cc36d31d99
source_authors: [Jonathan S. Shapiro, David Wagner, Sandro Magi, Jed Donnelley, Bill Frantz]
source_date: 2007-01-01 to 2007-01-06
thread_subject: "Claim: correct generic wrapping is not possible in principle"
ingested: 2026-09-16
ingested_by: scholar
topics: [patterns, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The generic-wrapper thread asks whether a transparent mediator can safely wrap an arbitrary object without knowing its protocol. A wrapper can forward ordinary calls, but identity tests, callbacks, returned references, exceptions, equality, and protocol-specific invariants make full transparency impossible in the general case. A correct membrane therefore needs a defined value-translation boundary and assumptions about the language's reference semantics.

The dispute is not whether useful wrappers exist. Read-only facets, revocable forwarders, logging proxies, and membranes are established patterns. The open claim concerns universality: can one wrapper preserve every observable property while changing authority? If code can observe wrapper identity or obtain unwrapped references through callbacks, the answer depends on the runtime and protocol.

For Endo this is a warning against treating JavaScript `Proxy` as a complete security abstraction. Mediation must specify which operations cross, how returned and argument references are recursively wrapped, how identity is preserved, and which invariants intentionally change. Later membrane work formalizes that recursive transformation; this thread preserves the original boundary argument.

Source: [cap-talk 2007-January archive](http://www.eros-os.org/pipermail/cap-talk/2007-January/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-January.txt.gz`, sha256 `be281f3e`), messages dated 2007-01-01 to 2007-01-06.
