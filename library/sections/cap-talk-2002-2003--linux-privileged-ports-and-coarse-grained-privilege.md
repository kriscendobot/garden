---
title: "Linux privileged ports and the coarse-grained Unix privilege model"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-September/
source_snapshot: http://web.archive.org/web/20160729225259id_/http://www.eros-os.org/pipermail/cap-talk/2002-September.txt.gz
source_content_sha256: 610c0cfe8380a71ed9d6963ccd1a61fca0bc156e2699c3e065305a568991d17e
source_authors: [Jonathan S. Shapiro, Pascal Bourguignon, Eric Hollander, Lorens Kockum]
source_date: 2002-09-13
thread_subject: "Linux privileged ports kernel question"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages. The month's only substantive thread; the parallel 'EROS status?' post was a bare status ping with no answer, and the rest is off-topic spam."
---

Abstract: A practical question ("which kernel file do I edit so any user can bind to a privileged port below 1024?") becomes a case study in why the Unix root-or-user privilege model is too coarse and why capabilities want a fine-grained replacement. The poster calls the privileged-port restriction the dumbest Unix security feature because it forces the daemons that handle the most untrusted input (network data) to run at the highest privilege. Pascal Bourguignon supplies the historical rationale, that privileged ports protected the Internet from local users (preventing a local user impersonating an important service), a threat model that has inverted now that most machines are single-user; he draws the capability-relevant lesson that a security mechanism's effect changes as environment and policy change. Shapiro disagrees on the history but sharpens the point: privileged ports were never a credible security mechanism, and it is the *policy* that shifts over time, not the primitive protection mechanism.

## The complaint

Binding to a TCP/UDP port below 1024 requires root on Unix. The consequence is that network daemons, which process the most dangerous untrusted input, must start at the highest privilege level. On single-user or all-users-are-root server machines this accomplishes nothing positive and is merely an obstacle. The mechanical answer given on the thread: change `IPPORT_RESERVED` in the BSD-derived stack (or `PROT_SOCK` in `include/net/sock.h`) and recompile.

## Historical rationale and its inversion (Bourguignon)

Bourguignon explains that privileged ports were introduced to protect the Internet *from* local users, not to protect users from the Internet: the danger was a local user impersonating an important service and stealing the trust that remote administrators extended to the host. In the old world every machine's administrator was trusted and local users were not. Now, with one user per machine who is also the administrator, and the threat coming from the network, the same mechanism has become the "dumbest security feature." His cap-relevant generalization: any capability-based system faces the same drift, because a setup that perfectly implements the policy at time T may not implement the (changed) policy at time T+dT.

## It is policy that shifts, not the mechanism (Shapiro)

Shapiro respectfully disagrees with the history: privileged ports were *never* a credible security mechanism, only a low-level impediment to casual abuse, understood at introduction to provide no meaningful protection and to be avoidable by any implementation. So the problem is not a shift in the effectiveness of this mechanism; there never was a well-motivated port-protection mechanism matched to the semantics of ports. On Bourguignon's generalization he answers "yes and no": capabilities are just a tool for naming and specifying access to objects; the policy shifts over time will live in the software and tools that manipulate capabilities, not in the primitive protection mechanism. The distinction he insists on is that the *policy* shifts as your picture of what you are protecting shifts, while the primitive mechanism does not. Eric Hollander adds that privileged ports are the single best example of why the Unix root-or-user model should be replaced with a fine-grained one, and Lorens Kockum notes that Linux POSIX "capabilities" like `CAP_NET_BIND_SERVICE` are a makeshift, poor-man's approximation of real capabilities.

Source: [cap-talk 2002-September archive](http://www.eros-os.org/pipermail/cap-talk/2002-September/) (Internet Archive original-bytes snapshot `web/20160729225259id_/.../2002-September.txt.gz`, sha256 `610c0cfe`), messages dated 2002-09-13 to 2002-09-15.
