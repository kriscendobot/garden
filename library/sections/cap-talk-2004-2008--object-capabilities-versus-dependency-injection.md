---
title: "Dependency injection is useful capability discipline, not enforcement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-November/
source_snapshot: https://web.archive.org/web/20160729235319id_/http://www.eros-os.org/pipermail/cap-talk/2008-November.txt.gz
source_content_sha256: 914dd217bc472d441362a6f6bdb77baf77ea41441a2494b58d8ff455dfd5e8eb
source_authors: [Rob Meijer, Ihab Awad, John Carlson, Mike Samuel]
source_date: 2008-11-20 to 2008-11-21
thread_subject: "Object capabilities versus dependency injection"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns, compartments]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Dependency injection and object-capability style share a construction pattern: dependencies arrive as references rather than being found through singletons or global registries. Injection improves testability and makes authority visible, but it becomes a security boundary only when the language/runtime also prevents ambient lookup, reflection, static escape hatches, and untamed framework powers.

The thread compares Spring-style inversion of control with Joe-E. Constructor injection can remove setters and global services, and test configurations can substitute narrow implementations. A general Java dependency-injection container, however, commonly reads configuration, reflects over classes, and retains broad setup authority. Taming that container is part of the trusted computing base.

For Endo, compartment endowments are dependency injection with enforcement: they both provide the dependency and ensure omitted powers are unavailable. The distinction is useful when explaining SES to application developers familiar with inversion of control.

Source: [cap-talk 2008-November archive](http://www.eros-os.org/pipermail/cap-talk/2008-November/) (Internet Archive original-bytes snapshot `web/20160729235319id_/.../2008-November.txt.gz`, sha256 `914dd217`), messages dated 2008-11-20 to 2008-11-21.
