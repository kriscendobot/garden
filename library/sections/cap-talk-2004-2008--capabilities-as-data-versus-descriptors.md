---
title: "Capabilities as data versus descriptors"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2004-May/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2004-May.txt.gz
source_content_sha256: 6e2fd2dc0f65aea7abf28ea3025fe513ac39c56276874cde06f41c9454f7f30e
source_authors: [David Hopwood, Ian Grigg, David Wagner, Alan H. Karp, Jed Donnelley, Valerio Bellizzomi, Jonathan S. Shapiro, Norman Hardy, Tyler Close, Ka-Ping Yee, Ben Laurie, Jerome Saltzer]
source_date: 2004-05-01 to 2004-05-14
thread_subject: '"capabilities" as data vs. as descriptors - OS security discussion, restricted access processes, etc.'
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: The May 2004 thread distinguishes a transferable password-like representation from a descriptor whose authority is maintained by the execution environment. Both can implement object capabilities, but they expose different confinement and leakage risks. A confined process remains useful because its creator controls its outward references; confinement does not mean total silence. If the process can encode a password capability into an ordinary byte channel, however, the distinction between authority-bearing data and harmless data becomes part of the confinement boundary.

The disagreement is partly about where enforcement lives. Descriptor systems can prevent a process from forging or serializing a reference unless the environment explicitly provides a transfer operation. Password-capability systems use large unguessable bit strings and can cross ordinary protocols, but a core dump, debugger, log, or accidental serialization may copy their authority. Tyler Close argues that local execution environments can proxy or scrub such references; critics answer that this makes the local runtime part of the security case.

Norman Hardy's closing observation is pedagogical: capabilities are simple but alien to a Unix-trained reader, and the absence of a ground-up machine model makes apparently basic disputes recur. The thread does not converge on one representation as universally superior. It converges on a more precise question: which channels may carry authority, and which component prevents unplanned conversion between authority and data?

Source: [cap-talk 2004-May archive](http://www.eros-os.org/pipermail/cap-talk/2004-May/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2004-May.txt.gz`, sha256 `6e2fd2dc`), messages dated 2004-05-01 to 2004-05-14.
