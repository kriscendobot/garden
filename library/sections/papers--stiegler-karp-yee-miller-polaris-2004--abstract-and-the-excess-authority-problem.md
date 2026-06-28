---
title: "Abstract and the excess-authority problem"
source: "Polaris: Virus Safe Computing for Windows XP (HPL-2004-221)"
source_kind: paper
source_authors: [Marc Stiegler, Alan H. Karp, Ka-Ping Yee, Mark Miller]
source_year: 2004
source_venue: HP Laboratories Palo Alto Technical Report HPL-2004-221
source_url: http://www.hpl.hp.com/techreports/2004/HPL-2004-221.html
source_pdf_sha256: 6c95faf19fefde7dbbe3b52d409fc8bc921fcd555f59db0f5d7cdaba75edce71
source_fetched_via: wayback
source_wayback_timestamp: 20220423221140
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-theory, capability-security]
status: superseded
superseded_by: papers--stiegler-polaris-virus-safe-computing-2004--excess-authority-the-virus-problem-and-permission-versus-authority
superseded_on: 2026-06-28
superseded_reason: |
  Duplicate ingest of the same report. The 2004 HP Labs report HPL-2004-221 was
  ingested twice by two gardeners racing the same cycle, under two source slugs with
  the identical source_pdf_sha256 6c95faf19fef (9 pages, four authors). The canonical
  cluster is papers--stiegler-polaris-virus-safe-computing-2004, cross-referenced by
  the concepts/polaris.md and concepts/powerbox.md concept pages. Kept, not deleted:
  the journal is append-only.
---

## Abstract

Polaris's diagnosis and thesis: the viruses that arrive via email attachments, document macros, and web scripts are not exploiting code flaws — they "are using the system the way it was designed to be used", because every program runs with the full authority of the logged-in user. The root problem is *excess authority*. Sandboxing fails because its rules are static and it cannot distinguish requests made by the user from requests made by the software (the "May I?" dialog problem). Polaris's thesis is that enforcing the Principle of Least Authority per-program gives so much protection that the security dialogs become unnecessary.

## Content

The paper's abstract: "Polaris is a package for Windows XP that demonstrates that we can do better at dealing with viruses than has been done so far. Polaris allows users to configure most applications so that they launch with only the rights they need to do the job the user wants done. This simple step, enforcing the Principle of Least Authority (POLA), gives so much protection from viruses that there is no need to pop up security dialog boxes or ask users to accept digital certificates. Further, there is little danger in launching email attachments, using macros in documents, or allowing scripting while browsing the web. Polaris demonstrates that we can build systems that are more secure, more functional, and easier to use."

**The diagnosis.** Viruses that run when you launch an attachment, edit a macro-bearing file, or visit a scripted web page "aren't exploiting flaws; they're using the system the way it was designed to be used." Why: "All widely used operating systems, not just Windows, base their security on the identity of the logged in user. That means every program you run can do anything you can do, whether you want it done or not." The paper states the principle directly: "The problem is the excess authority that every program gets. There's no reason Solitaire needs the ability to search your disk for secrets and send them to your competition. There's no reason Excel needs the ability to put a Trojan horse in your startup folder." It quotes the first of Microsoft's *10 Immutable Laws of Security* — "If a bad guy can persuade you to run his program on your computer, it's not your computer anymore" — as evidence of how ingrained the excess-authority assumption is. (This is the same critique CapDesk's [edesk](combex--edesk--pola-and-the-winix-problem.md) makes of "Winix", and the formal Property D, *No Ambient Authority*.)

**Why sandboxing fails.** "A common means of dealing with this problem is sandboxing, which involves setting up a set of rules for each program, as in Java 2 Security. A failing of sandboxing is that the rules are static. Adding authorities to a running program, such as to open a file, is often difficult in such systems." The alternative — controlling access to individual resources — has historically "been too hard to use", nagging users with "May I?" dialog boxes (Java Web Start is the figure-1 example). The deeper flaw: "the fact that it is needed at all indicates that there is no distinction between requests made by the user and those made by the software." Grouping authorities into "relatively large chunks" looks easy to use but becomes hard once you try to stop viruses abusing the excess: virus scanners to update, firewalls to configure, advisories that say "Don't launch email attachments", "Disable macros", "Turn off scripting" — each reducing functionality, and the final dialog box "asks you to choose between not getting your work done and losing control of your machine."

Source: Polaris: Virus Safe Computing for Windows XP, HP Laboratories technical report HPL-2004-221 (December 2004); PDF fetched via the Internet Archive original-bytes capture (`source_fetched_via=wayback`, [web/20220423221140id_/](http://web.archive.org/web/20220423221140id_/http://www.hpl.hp.com/techreports/2004/HPL-2004-221.pdf)), PDF SHA-256 `6c95faf1`.
