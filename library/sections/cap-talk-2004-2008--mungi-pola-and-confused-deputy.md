---
title: "Mungi-style APIs, POLA, and confused deputies"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-May/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-May.txt.gz
source_content_sha256: 4225d039ba1cd4375acba0029faf925723b348ee5c35042343a851cba5760f21
source_authors: [Toby Murray, David Wagner, Lorens Kockum, David Hopwood, Jonathan S. Shapiro, Ian Grigg, Charles Landau, Alan H. Karp, Jed Donnelley, Bill Frantz]
source_date: 2005-05-16 to 2005-05-22
thread_subject: "POLA and Mungi / Iguana style APIs"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A system can expose capability primitives yet still frustrate least authority if its APIs make broad authority the convenient or necessary unit. The Mungi/Iguana discussion tests whether a single-address-space design, coarse-grained objects, or legacy calling conventions force applications to receive more authority than each operation needs. Participants repeatedly return to API shape: a capability system does not make an application least-authority by itself.

The confused-deputy subthread sharpens the failure mode. If a service receives a forgeable name or consults caller identity while also holding ambient authority, the service can use the wrong authority for the request. Passing the designated object directly keeps authority bound to the argument. This is the application-level caveat later emphasized by Close: capability infrastructure can host an ACL-shaped application that recreates the old vulnerability.

The practical criterion is not whether the kernel labels something a capability. It is whether ordinary programmers can express each intended operation with a narrow reference, without falling back to global names, implicit principal checks, or a large undifferentiated authority bag.

Source: [cap-talk 2005-May archive](http://www.eros-os.org/pipermail/cap-talk/2005-May/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-May.txt.gz`, sha256 `4225d039`), messages dated 2005-05-16 to 2005-05-22.
