---
title: "Sandstorm's per-grain isolation and layered confinement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-August/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-August.txt.gz
source_content_sha256: eed5f60f84ef1a9cca64e6748abd00792556292b853748abf401c7ac8382f303
source_authors: [Mark S. Miller, Thomas Leonard, Kenton Varda, Bill Frantz, Rob Meijer, Ihab Awad]
source_date: 2014-08-04 to 2014-08-06
thread_subject: "A practical and compelling distributed cap platform: Sandstorm on Cap'n Proto"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, compartments, distributed-objects]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Sandstorm's deployment model makes each user document or “grain” a lightweight Linux container, maps application code read-only, leaves only instance data writable, and starts grains on demand. The platform owns authentication and sharing so legacy web applications can enter a capability-shaped environment without first being rewritten in an ocap language. Varda imagines language-level isolation eventually allowing many instances in one process; Frantz, Meijer, and Awad argue for retaining OS isolation as defense in depth because the compiler and language runtime otherwise join the security kernel.

The thread's durable architecture is layered migration. A process boundary can confine legacy code today, while typed capability RPC and narrower in-process objects improve composition over time. Language safety can reduce per-instance overhead, but should not casually replace an independent containment layer when mutually distrustful applications share a runtime.

Source: [cap-talk 2014-August archive](http://www.eros-os.org/pipermail/cap-talk/2014-August/) (Internet Archive original-bytes `id_` snapshot of `2014-August.txt.gz`, sha256 `eed5f60f`), thread "A practical and compelling distributed cap platform: Sandstorm on Cap'n Proto", 2014-08-04 to 2014-08-06.
