---
title: "User intent, designation, and authorization"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-October/
source_snapshot: https://web.archive.org/web/20160730012319id_/http://www.eros-os.org/pipermail/cap-talk/2007-October.txt.gz
source_content_sha256: c270c69102ee19101b91f59301e09295df39a63ccffaa6d59849997c6416ecd2
source_authors: [John Carlson, Marc Stiegler, Jed Donnelley, Mark S. Miller, Ka-Ping Yee, Ihab Awad, Alan H. Karp, David Hopwood, James A. Donald, Jonathan S. Shapiro]
source_date: 2007-10-02 to 2007-10-07
thread_subject: "getting authorization from the user and the great insight"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Not every click is a separate authorization prompt. The capability insight is to interpret a user's act of designation in context: opening a document authorizes the selected application instance to manipulate that document, while entering a URL authorizes a constrained network/display interaction, not arbitrary file access.

John Carlson asks where authorization begins in ordinary GUI actions. The replies reject both extremes: ambient authority silently overgrants, but prompting for every effect makes the user approve meaningless implementation details. CapDesk and Polaris instead couple designation with a narrow grant at a trusted UI boundary, then let subsequent actions operate within that grant. Undo, transactional UI, and secure window identity can make the consequences legible without turning the user into an access-control administrator.

The open design problem is inferring scope from gesture without letting an untrusted application counterfeit the gesture or its recipient. Endo's powerboxes should therefore mint authority only from trusted UI events and carry the resulting reference directly to the intended component.

Source: [cap-talk 2007-October archive](http://www.eros-os.org/pipermail/cap-talk/2007-October/) (Internet Archive original-bytes snapshot `web/20160730012319id_/.../2007-October.txt.gz`, sha256 `c270c691`), messages dated 2007-10-02 to 2007-10-07.
