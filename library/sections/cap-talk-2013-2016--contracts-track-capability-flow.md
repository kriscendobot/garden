---
title: "Contracts that track capability flow through higher-order channels"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-October.txt.gz
source_content_sha256: f8ffa91e247c32d1b81a3c058a55100702720f9669c0391424afcf98d9c67cf1
source_authors: [Anton Burtsev, Scott Moore]
source_date: 2014-10-10
thread_subject: "Contracts and communication channels in Shill"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Shill's contracts can constrain capabilities passed as function arguments, returns, or wallet entries, and dependent contracts can reject a particular capability when a callback is invoked. The hard case is higher-order authority hidden in closures: checking that a callback is not directly given `bar` is insufficient if the callback closes over `bar`, or if another wrapper later releases it. Moore therefore treats closed-over capabilities as part of a function's authority and points to provenance-tracking contracts that constrain which components may pass a capability onward and assign blame when the flow violates the declared pattern.

The section's general rule is that an interface guard over immediate arguments is not a confinement proof. Authority can travel through returned closures, mutable cells, callbacks, and capabilities obtained from arguments. A sound contract must either bound those transitive paths or state that it checks only the surface call.

Source: [cap-talk 2014-October archive](http://www.eros-os.org/pipermail/cap-talk/2014-October/) (Internet Archive original-bytes `id_` snapshot of `2014-October.txt.gz`, sha256 `f8ffa91e`), thread "Contracts and communication channels in Shill", 2014-10-10.
