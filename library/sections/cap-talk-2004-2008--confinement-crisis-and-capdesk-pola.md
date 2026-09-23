---
title: "Confinement crisis, POLA, and the CapDesk demonstration"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2004-May/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2004-May.txt.gz
source_content_sha256: 6e2fd2dc0f65aea7abf28ea3025fe513ac39c56276874cde06f41c9454f7f30e
source_authors: [Jonathan S. Shapiro, David Wagner, Jed Donnelley, Valerio Bellizzomi, David Hopwood, David Chizmadia, Zooko Wilcox-O'Hearn, Ben Laurie, Marc Stiegler, Alan H. Karp, John Adams]
source_date: 2004-05-05 to 2004-05-25
thread_subject: "What are caps good for? Encapsulation? POLA vs. confinement"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages; cross-linked to the contemporary Miller and Polaris papers."
---

Abstract: Shapiro deliberately reopens the value proposition for capabilities: a hostile holder can proxy any authority it cannot directly transfer, so prohibiting transfer does not by itself constrain effective authority. He calls this a temporary "crisis of confidence" about confinement, while retaining the value of capabilities as a least-authority construction tool. The discussion separates three claims too often bundled together: object encapsulation, limiting the authority initially granted, and preventing a hostile recipient from relaying effects.

The practical counterweight is CapDesk. Participants who had been cold to abstract capability arguments report that its demonstration made dynamic least authority tangible: bind authority to a user's designation at the moment of action, then run the application with only that authority. The discussion repeatedly returns to Miller's phrase "bundle authority with designation" and to the contrast between just-in-time authority and the ambient user authority of ordinary desktops.

The thread is the workshop form of [*The Structure of Authority*](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation--body.md): cooperation and safety are not a forced choice if authority is allocated dynamically. It also precedes the stable Polaris result in [the 2004 report](../sections/papers--stiegler-karp-yee-miller-polaris-2004--abstract-and-the-excess-authority-problem.md). The unresolved part is confinement against a malicious holder with an allowed communication path; POLA remains valuable even when that stronger non-proxying goal is unavailable.

Source: [cap-talk 2004-May archive](http://www.eros-os.org/pipermail/cap-talk/2004-May/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2004-May.txt.gz`, sha256 `6e2fd2dc`), messages dated 2004-05-05 to 2004-05-25.
