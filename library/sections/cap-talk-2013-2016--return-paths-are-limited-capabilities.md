---
title: "Return paths are limited capabilities, not ordinary introductions"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2013-May/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2013-May.txt.gz
source_content_sha256: 5fd900ed69fc73a40f1cb4e1c580e3a0ed7370d2ad3adab9fa909b733c99198e
source_authors: [Chip Morningstar, Mark S. Miller, Jonathan Shapiro, Bill Frantz, Rob Meijer, William Leslie, Toby Murray, Dean Tribble]
source_date: 2013-05-07 to 2013-05-08
thread_subject: "Return is not quite introduction"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, eventual-send, distributed-objects]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Morningstar observes that a call/return protocol gives the callee a way to affect the caller without necessarily giving it a general reference to the caller. In a continuation-passing translation the return continuation is explicit, but in a direct-style model it is easy to mistake “can return one result” for full Granovetter introduction. Spiessens's formalization, endorsed in the thread by Miller, treats the return channel as a limited authority in its own right rather than pretending the callee acquired the caller.

This matters for authority graphs and protocol review: a reply path may authorize one value, one exception, or one use, while a callback reference authorizes a wider future conversation. Modeling both as the same edge overstates authority; ignoring the reply edge understates influence. Promise resolvers and result continuations should therefore appear as explicit, attenuated capabilities in any analysis that reasons about who may affect whom.

Source: [cap-talk 2013-May archive](http://www.eros-os.org/pipermail/cap-talk/2013-May/) (Internet Archive original-bytes `id_` snapshot of `2013-May.txt.gz`, sha256 `5fd900ed`), thread "Return is not quite introduction", 2013-05-07 to 2013-05-08.
