---
title: "Good-guy timers and time as authority"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-March/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-March.txt.gz
source_content_sha256: d09a9d1614b0cfd2fa2a91f7b0bfa99c49b03f77382409e6eead944a40e61a81
source_authors: [Jed Donnelley, David Barbour, Bill Frantz]
source_date: 2014-03-25 to 2014-03-31
thread_subject: "Good guy timers"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A timer is not a neutral convenience in a confined computation. Access to a high-resolution clock or callback scheduler can reveal execution timing, create covert channels, and let a component consume future turns or resources. The thread's “good-guy timer” question is whether a platform can provide enough time authority for deadlines and responsiveness without exposing a globally comparable clock or an unbounded scheduling capability.

The useful capability decomposition is to separate reading a clock, scheduling one callback, recurring scheduling, cancellation, and budget sponsorship. A deadline token or one-shot alarm can be narrower than a global timer service. No construction removes every timing channel on shared hardware; the grant must state the intended precision and resource bounds instead of presenting “time” as one ambient primitive.

Source: [cap-talk 2014-March archive](http://www.eros-os.org/pipermail/cap-talk/2014-March/) (Internet Archive original-bytes `id_` snapshot of `2014-March.txt.gz`, sha256 `d09a9d16`), thread "Good guy timers", 2014-03-25 to 2014-03-31.
