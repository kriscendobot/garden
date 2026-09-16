---
title: "The petname toolbar as a trusted path"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-February.txt.gz
source_content_sha256: 7df3d075ad7abf606d149c95308b9912d33763b6995524ebaaaf444c66551d4d
source_authors: [Tyler Close, Ka-Ping Yee, Jed Donnelley, Ian Grigg, David Wagner, Trevor Perrin, Mark S. Miller, Alan H. Karp, David Hopwood, Norman Hardy]
source_date: 2005-02-18 to 2005-02-24
thread_subject: "A petname toolbar for Firefox"
ingested: 2026-09-16
ingested_by: scholar
topics: [identity, patterns]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Tyler Close turns the preceding identifiability debate into an executable experiment: a Firefox toolbar where users assign local names to trusted sites. The toolbar treats a globally supplied URL or certificate name as connectivity, not meaning. An unnamed site stays visibly untrusted; a returning endpoint receives the user's own stable label. The implementation is a trusted-path pattern because page content must not be able to forge the label or the chrome that displays it.

The list uses the tool to refine the semantics. A petname should not pretend to encode the user's complete relationship with a site; Norman Hardy suggests linking the compact name to a protected relationship record. Space in browser chrome, the default wording for unnamed sites, and how a relationship survives key changes become security questions because each presentation choice affects what the user can reliably distinguish.

The thread is evidence for a recurring capability method: prototype the security interaction so participants experience the affordance before standardizing terminology. The petname is a local, user-controlled attribution layered over a possession-based reference, not a replacement for that reference.

Source: [cap-talk 2005-February archive](http://www.eros-os.org/pipermail/cap-talk/2005-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-February.txt.gz`, sha256 `7df3d075`), messages dated 2005-02-18 to 2005-02-24.
