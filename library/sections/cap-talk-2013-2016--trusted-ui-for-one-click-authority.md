---
title: "Trusted UI for one-click authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-March.txt.gz
source_content_sha256: 2e505f3a7e8c90d904ad7d9efb0cff7ecbc797dcd71dbcc4bb1fcb83793db107
source_authors: [David Bruant, Eric Jacobs, Sandro Magi, Toby Murray, David Wagner, Alan Karp, Daira Hopwood, Ihab Awad]
source_date: 2013-03-11 to 2013-03-13
thread_subject: "Convenient 'like' button using capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A Facebook “Like” button poses the deployment test for designation-as-authorization: keep the existing one-click experience while preventing a page from clickjacking the user's ambient Facebook cookie. The capability-shaped proposals move the authority-bearing control into trusted browser chrome, a powerbox, or a user-installed social-media widget; the page may designate the subject but must not paint, overlap, transform, or counterfeit the control that exercises the user's authority. Wagner pushes back that this is a large deployment change relative to opt-in browser defenses, and Karp adds that usable authorization also needs a visible record of grants and a revocation surface.

The general lesson is that no cryptographic reference can make an untrusted pixel prove user intent. A low-friction authority gesture needs a trusted path that binds the action, recipient, and scope. The unresolved product question is how much page-level visual freedom must be surrendered, and whether browser chrome can scale across many authorities without becoming another prompt mechanism users ignore.

Source: [cap-talk 2013-March archive](http://www.eros-os.org/pipermail/cap-talk/2013-March/) (Internet Archive original-bytes `id_` snapshot of `2013-March.txt.gz`, sha256 `2e505f3a`), thread "Convenient 'like' button using capabilities", 2013-03-11 to 2013-03-13.
