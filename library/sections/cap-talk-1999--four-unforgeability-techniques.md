---
title: "Four techniques for unforgeable capabilities"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/1999-July/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/1999-July.txt.gz
source_content_sha256: 3262da95439fd9dab4a1736482fa651abb9f59818a159ea2bb168092e6137a45
source_authors: [Jonathan S. Shapiro]
source_date: 1999-07-28
thread_subject: "EROS: expressibility question"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security]
status: current
notes: "Derived summary, not the original message."
---

Abstract: Shapiro classifies four mechanisms for making a capability unforgeable: **sparsity** (unguessable values in a large space), **encryption** (only valid cryptographic encodings resolve), **partitioning** (capabilities never inhabit application data and data operations cannot manufacture them), and **tagging** (hardware maintains a capability tag bit that ordinary writes clear). EROS chooses partitioning, so no cryptographic validation occurs on invocation. The taxonomy cleanly separates the object-capability runtime model from serialized password capabilities.

## Security and observability tradeoffs

Sparse and encrypted capabilities admit a nonzero guessing probability. Encryption also imposes validation cost and makes inspection difficult because any random-looking data might encode a capability. Partitioning makes guessing irrelevant: even the correct bits cannot be placed where the kernel interprets them as a capability. Tagged memory obtains the same separation in hardware.

For Endo, the closest analogue is runtime partitioning by language semantics: ordinary JavaScript data cannot forge an object reference, while marshal turns selected references into explicitly mediated slots. Confusing this with an unguessable URL skips the enforcement layer that makes object references unforgeable.

Source: [cap-talk 1999-July archive](http://www.eros-os.org/pipermail/cap-talk/1999-July/) (Internet Archive original-bytes snapshot, sha256 `3262da95`), message by Jonathan S. Shapiro, 1999-07-28.
