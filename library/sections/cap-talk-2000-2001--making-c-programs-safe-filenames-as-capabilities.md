---
title: "Making C programs safe and turning filenames into capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2001-September/
source_snapshot: http://web.archive.org/web/20160729234053id_/http://www.eros-os.org/pipermail/cap-talk/2001-September.txt.gz
source_content_sha256: 18ca20d7672790fc9ebbebaada028c5c1f1d58bdc58c026b4d80e269a065a489
source_authors: [Mark Seaborn]
source_date: 2001-09-18
thread_subject: "Making C programs safe and turning filenames into capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original message. The month otherwise carries only capidl list-administration mail."
---

Abstract: Mark Seaborn announces an early draft of a scheme for translating C programs into a memory-safe language so a program's ambient authority to access memory can be removed and replaced by explicit capabilities to memory. The same translation turns filenames into unforgeable capabilities for files. The motivation is a migration path: converting the large existing body of Unix C programs to run on a capability system without rewriting them by hand. This is the one substantive thread in an otherwise administrative month (the rest is capidl-list logistics).

## The proposal

Seaborn describes a source-to-source transformation that compiles C into a safe target language. Two ambient authorities that ordinary C enjoys are removed and re-expressed as capabilities:

- **Memory access.** A translated program no longer has ambient authority to read or write arbitrary memory; each access is mediated by a capability the program must hold. This is the memory-safety half of the scheme.
- **Filenames.** The same technique converts filenames from strings interpreted against an ambient global namespace into unforgeable capabilities for the files they name. A program can only reach a file it was given a capability to, not any path it can spell.

## Why it matters for capability systems

The thread is an early statement of the *legacy-migration* problem that recurs throughout the 2002 cap-talk archive (see the 2002-February "Saving the Unix API" debate): a capability operating system is only adoptable if the enormous corpus of existing Unix C programs can run on it. Seaborn's angle is mechanical translation rather than emulation or rewrite. Turning filenames into capabilities is the file-store analogue of the object-capability rule that authority must be designated, not named against a shared namespace. The draft was posted for comment with an implementation planned for the following year.

Source: [cap-talk 2001-September archive](http://www.eros-os.org/pipermail/cap-talk/2001-September/) (Internet Archive original-bytes snapshot `web/20160729234053id_/.../2001-September.txt.gz`, sha256 `18ca20d7`), message dated 2001-09-18.
