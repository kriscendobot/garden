---
title: "Confused-deputy redux: who assigns the namespace index"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-May/
source_snapshot: http://web.archive.org/web/20160729215956id_/http://www.eros-os.org/pipermail/cap-talk/2002-May.txt.gz
source_content_sha256: 331ae0c65a01bd248aaa0a0f7ecfba285daa6c2ec63476b1db7c7087ed726a4b
source_authors: [Alan Cox, Ben Laurie, Dave Long, Kragen Sitaker, Mark S. Miller, Bill Frantz]
source_date: 2002-05-01 to 2002-05-16
thread_subject: "interesting Unix confused-deputy problem / Yet another reason not to depend on the caller's privileges"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages. Continues the 2002-April thread indexed as cap-talk-2002-2003--unix-file-descriptor-confused-deputy."
---

Abstract: The May 2002 continuation of the descriptor confused-deputy thread hardens the diagnosis reached in April: the bug is not the reused file but who assigns the name. Alan Cox reports the flaw is old history (independently rediscovered many times since Henry Spencer documented it in 1987) and that getting it right is hard because Unix passes so much implicit environment and offers no "trust no one" library call. Ben Laurie offers the practical hack — `while(open("/dev/null") < 2) ;` to reserve the low descriptors — while conceding Unix "wasn't really designed to be properly secure." The list reaffirms the capability reading Miller stated: because Unix's `open()` picks the lowest free descriptor, the process cannot lexically bind returned authority, unlike KeyKOS/EROS c-list indices, which behave like lambda-calculus names bound by the namespace owner. Bill Frantz's follow-up ("Yet another reason not to depend on the caller's privileges") supplies a fresh instance: a SuSE shadow-package advisory where a caller-set file-size limit derails a privileged utility, fixed by writing to a temp file and renaming.

## The reaffirmed root cause

The thread converges on Shapiro's rule from April: the owner of a namespace should control the assignment of names within it. Unix violates it by having the kernel choose the descriptor number, so a privileged deputy cannot tell inherited-slot conventions apart from authority it deliberately opened. The workarounds discussed — reserving descriptors 0–2 by opening `/dev/null` in a loop, or `dup2` to force a chosen slot — are patches over a missing property, not the property itself.

## Depending on the caller's environment is the recurring hazard

Frantz generalizes the lesson beyond descriptors. The shadow-utilities bug is the same shape: a privileged program trusts a piece of caller-controlled environment (here, a resource limit) and is derailed by it. The capability discipline answer is the same as the descriptor answer — do not inherit authority or constraints implicitly from the caller; take exactly the references you need, explicitly bound.

Source: [cap-talk 2002-May archive](http://www.eros-os.org/pipermail/cap-talk/2002-May/) (Internet Archive original-bytes snapshot `web/20160729215956id_/.../2002-May.txt.gz`, sha256 `331ae0c6`), messages dated 2002-05-01 to 2002-05-16.
