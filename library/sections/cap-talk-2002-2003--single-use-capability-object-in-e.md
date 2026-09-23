---
title: "A single-use capability object in E"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-October/
source_snapshot: http://web.archive.org/web/20160730015229id_/http://www.eros-os.org/pipermail/cap-talk/2003-October.txt.gz
source_content_sha256: 5c3eea510fe625cf0629554a05b5b9e770b6bb912af6d60d4c4f26d19ead7806
source_authors: [Valerio Bellizzomi, Mark S. Miller]
source_date: 2003-10-05
thread_subject: "Sngle-use capabilities"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns, e-language]
status: current
notes: "Derived summary, not the original messages. The subject's typo is preserved only in thread_subject."
---

Abstract: The October continuation turns the previous month's survey into an E implementation. `makeSingleUse` closes over a mutable target. Its catch-all matcher first copies that target into a local, replaces the stored target with a broken reference labeled "Used up," and only then forwards the original verb and arguments. Mutating before dispatch makes reentrant or later calls fail while preserving transparent forwarding for the one accepted message.

## Consume before forwarding

The ordering is the pattern's security property. Clearing the slot after the call would let the target reenter the wrapper before consumption. Copy, break, then call gives the first invocation sole access even when forwarding fails or invokes adversarial code. The example shows composability directly: a reusable target can be attenuated to one use by an ordinary object, without kernel support.

Source: [cap-talk 2003-October archive](http://www.eros-os.org/pipermail/cap-talk/2003-October/) (Internet Archive original-bytes snapshot `web/20160730015229id_/.../2003-October.txt.gz`, sha256 `5c3eea51`), message dated 2003-10-05.
