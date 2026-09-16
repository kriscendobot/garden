---
title: "Horton: accountability metadata without ambient authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-May/
source_snapshot: https://web.archive.org/web/20160729201833id_/http://www.eros-os.org/pipermail/cap-talk/2007-May.txt.gz
source_content_sha256: d486c7668b0f0e898816984e3080288c954fa23caa52c159a884c7b67562ab21
source_authors: [Mark S. Miller, Charles Landau, Jed Donnelley, Sandro Magi, Alan H. Karp, David Hopwood, Rob Meijer, Kevin Reid, Norman Hardy, Jonathan S. Shapiro, David Wagner]
source_date: 2007-05-15 to 2007-05-28
thread_subject: "Delegating Responsibility in Digital Systems: Horton's Who Done It?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Horton explores how a recipient can learn a delegation chain without turning identity into ambient authorization. Proxies forward ordinary capability calls while sealed descriptions carry who delegated to whom and under what attenuation; the metadata supports responsibility narratives but does not prove the ultimate human cause of an action.

Miller, Karp, and Donnelley's draft prompted detailed review of proxy transparency, callbacks, attenuation, liveness, logging, and the threat model. Participants repeatedly separate authority from accountability: an object should still act only through references it holds, while an optional description can say why a reference was conveyed. Nested sealed boxes can preserve a chain without asking every resource to share a global principal database.

The open question is what evidentiary claim the chain supports. A delegate can proxy, lie outside the protected construction, or be compromised; Horton records a mechanically maintained delegation path, not human intent. Endo can use that distinction when attaching provenance to invitations or formula edges: metadata may explain authority flow without becoming the authority check itself.

Source: [cap-talk 2007-May archive](http://www.eros-os.org/pipermail/cap-talk/2007-May/) (Internet Archive original-bytes snapshot `web/20160729201833id_/.../2007-May.txt.gz`, sha256 `d486c766`), messages dated 2007-05-15 to 2007-05-28.
