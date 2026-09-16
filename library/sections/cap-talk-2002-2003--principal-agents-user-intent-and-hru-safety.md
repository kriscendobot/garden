---
title: "Principal agents, user intent, and HRU safety"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-June/
source_snapshot: http://web.archive.org/web/20160729225925id_/http://www.eros-os.org/pipermail/cap-talk/2003-June.txt.gz
source_content_sha256: 306f9604b08ca9ffcbf1d2eb7545b2d1d54ecd6bd27c8d0054d45a7ea4b57409
source_authors: [Hal Finney, Jonathan S. Shapiro, David Wagner, Ben Laurie]
source_date: 2003-05-31 to 2003-06-02
thread_subject: "a matrix model of capabilities redux"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Finney's reading of Harrison-Ruzzo-Ullman asks why a deliberate grant counts as a leak. Shapiro answers that no machine operation occurs directly under a human's control: programs mediate every intention, and a program running under a user identity can exercise all that identity's ambient permission. Capability design therefore distinguishes small **principal agents**, trusted to respect a person's intent, from other programs. A save/open dialog that returns a pre-opened descriptor is the worked example: the untrusted editor never receives general filesystem authority, while the principal agent creates a narrow grant after an explicit user decision. This is the permission-versus-authority distinction immediately before *Paradigm Regained*: identity says whose ambient account a program runs under; capability designation says which effect this interaction authorizes.

## HRU's pessimism is deliberate

If a command exists that can grant a right, an untrusted program able to execute it may do so. Asking what the user meant does not repair the model because the program is simultaneously influenced by its author, inputs, and vulnerabilities. A trusted subject may be omitted from the hostile graph, but subject-level trust is too coarse when only some operations are safe.

## Put the user back in the loop with designation

The separate chooser holds broad filesystem authority and returns one descriptor. The application may corrupt the selected file, but it cannot silently choose another. The architecture narrows damage, makes requests visible, and lets repeated misuse reveal the bad program. It does not claim to make arbitrary hostile code harmless.

Source: [cap-talk 2003-June archive](http://www.eros-os.org/pipermail/cap-talk/2003-June/) (Internet Archive original-bytes snapshot `web/20160729225925id_/.../2003-June.txt.gz`, sha256 `306f9604`), messages dated 2003-05-31 to 2003-06-02.
