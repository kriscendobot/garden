---
title: "POLA versus creator authority, visibility, and revocation"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-January/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-January.txt.gz
source_content_sha256: ab55d60dbe97a5b53df7c9920f9ea9aba4fe67d974408eb676f3727ab5da3324
source_authors: [David Barbour, Rob Meijer, William Leslie, Eric Jacobs, Bill Frantz]
source_date: 2013-01-10 to 2013-01-11
thread_subject: "Over-commitment to a single security principle (POLA)?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The thread disputes whether creating an object implies permanent authority to inspect and revise it. Barbour argues that POLA is not the only secure-design principle: visibility, revocability, maintenance, and recovery from mistaken abstraction boundaries favor retaining creator access. Meijer and Jacobs answer that a creator may deliberately instantiate code into a separately confined domain; letting the creator inspect later inputs would break the very abstraction and secrecy the confinement was meant to provide. Frantz's KeyKOS account breaks the assumed single-parent tree: the class factory and instance creator contribute different authorities, and debugging the instance can require their cooperation.

The dispute exposes three meanings hidden by “parent”: authorship of code, sponsorship of resources, and possession of reflective authority. They need not coincide. A runtime may technically have power over everything it hosts while declining to expose that power to the object that requested creation. Conversely, erasing every maintenance facet in the name of least authority can make upgrades and audits needlessly brittle. The thread does not settle one universal rule; it favors explicit creation protocols that say which party contributes endowments and which diagnostic, revocation, or inspection facets survive.

Source: [cap-talk 2013-January archive](http://www.eros-os.org/pipermail/cap-talk/2013-January/) (Internet Archive original-bytes `id_` snapshot of `2013-January.txt.gz`, sha256 `ab55d60d`), thread "Over-commitment to a single security principle (POLA)?", 2013-01-10 to 2013-01-11.
