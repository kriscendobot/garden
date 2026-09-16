---
title: "Why determining the invoker is the wrong question"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-May/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-May.txt.gz
source_content_sha256: 4225d039ba1cd4375acba0029faf925723b348ee5c35042343a851cba5760f21
source_authors: [Toby Murray, Jed Donnelley, Mark S. Miller, Alan H. Karp, Norman Hardy, Jonathan S. Shapiro, David Hopwood, Marc Stiegler]
source_date: 2005-05-24 to 2005-05-31
thread_subject: "Where capabilities fall short - determining the invoker"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The thread begins from the claim that capabilities fall short because a callee cannot determine the human or process that ultimately invoked it. The capability response is that this provenance is generally unavailable in the presence of delegation and proxying, and is often the wrong input to authorization. A message proves that some holder exercised a particular reference. It does not prove which human intended the effect or how many forwarding objects lay between initiator and callee.

When attribution matters, the parties can add an explicit, scoped credential or introduction protocol. That statement is weaker than ambient caller identity: it identifies the claim being presented and the authority that vouches for it. Treating a runtime-maintained caller label as ground truth invites the same principal confusion discussed in the archive since 1999.

The unresolved part is accountability. Capability discipline prevents a callee from silently acquiring reliable ultimate-caller identity, but operational systems still need audit records, fraud response, and policy explanations. The list does not converge on a universal attribution layer; it converges on refusing to confuse reference exercise with human causation.

Source: [cap-talk 2005-May archive](http://www.eros-os.org/pipermail/cap-talk/2005-May/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-May.txt.gz`, sha256 `4225d039`), messages dated 2005-05-24 to 2005-05-31.
