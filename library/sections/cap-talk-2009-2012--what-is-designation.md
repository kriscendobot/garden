---
title: "What is designation: the user act of selecting, and who designates on whose behalf"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2009-February/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2009-February.txt.gz
source_content_sha256: 450ead7831a992ddd5dce7ba9f10736b70db96fc2ce4d388ceee57fa3e4af041
source_authors: [John Carlson, Ben Laurie, David-Sarah Hopwood, Alan Karp, Mark Miller]
source_date: 2009-02-24 to 2009-02-27
thread_subject: "what is designation"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A short definitional thread. John Carlson asks the list to explain what *designation* means for capabilities, guessing "the act of giving authority." The answers correct and sharpen the term. Ben Laurie: designation is the user *selecting* something — a file in an open dialog, a drag-and-drop, a paste. David-Sarah Hopwood generalizes past the human: "From the point of view of an access control system, it is subjects that designate, only sometimes on behalf of a single specific user." The distinction the thread draws is the one at the heart of the whole capability argument: designation (naming/selecting *which* object) is separate from authorization (holding the *authority* to act on it), and the defining property of a capability is that it *fuses* the two so the act of designating is itself the act of conveying authority — which is why capability designation avoids the confused deputy that ACL systems suffer when designator and authority arrive by separate routes.

## The question and the corrections

Carlson's guess conflates designation with granting authority. Laurie's answer separates designation as *selection*: the concrete human acts (file-open dialog, drag-and-drop, paste) by which a user points at the object they mean. This is the "designation is what the user does when they pick a thing" reading that underlies capability-secure UI (the powerbox: the user's act of selecting a file *is* the grant of a capability to that file, so there is no separate ambient file-system authority to confuse). Hopwood widens it: designators are wielded by *subjects* (programs), not only by users, and a subject designates on its own behalf as often as on a user's — so an access-control analysis cannot assume every designation traces to a human intent.

## Why designation is load-bearing

The capability program's core claim (Miller-Tulloh-Shapiro; Miller-Shapiro *Paradigm Regained*) is that authority should be *designated*, not *ambient*: you may act on exactly the objects you can name by holding a reference to them, and holding the reference *is* the authority. When designation and authority travel together (a capability), the confused deputy is eliminated by construction (Property A, "no designation without authority", and Property D, "no ambient authority"). When they travel separately (an ACL: the user supplies a name, the system supplies the permission), the deputy can be fooled into pairing a name with an authority never intended for it. This tiny 2009 thread is the community restating that separation in plain language for a newcomer.

## Bearing on Endo

Endo has no ambient authority: a compartment or guest acts only on the references (capabilities) it has been handed, and the act of passing a reference is the act of designating-and-authorizing. The powerbox pattern — the user selects, and the selection *is* the grant — is the UI-level expression Laurie describes. See [[object-capability]] and [[confused-deputy]].

Source: [cap-talk 2009-February archive](http://www.eros-os.org/pipermail/cap-talk/2009-February/) (Internet Archive original-bytes `id_` snapshot of `2009-February.txt.gz`, sha256 `450ead78`), thread "what is designation", 2009-02-24 to 2009-02-27.
