---
title: "Memory accounting without fixed partitions"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-June/
source_snapshot: https://web.archive.org/web/20160729210151id_/http://www.eros-os.org/pipermail/cap-talk/2007-June.txt.gz
source_content_sha256: e1f6735899bf05433c5b3847ecc8afd335a0f315320f0712c2ba2147cb0d3be0
source_authors: [Sandro Magi, Alan H. Karp, Jonathan S. Shapiro, Jed Donnelley, David Hopwood, Pierre Thierry, Marcus Brinkmann, Norman Hardy]
source_date: 2007-06-15 to 2007-06-25
thread_subject: "Memory Accounting without partitions"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Charging memory to mutually suspicious components is harder than allocating fixed heaps because references cross boundaries and shared objects outlive individual callers. The thread compares space banks, ownership transfer, reachability, and per-allocation sponsors, but does not converge on a policy that is simultaneously precise, cheap, fungible, and resistant to denial of service.

The core ambiguity is “whose” memory an object is once several principals retain it. Charging the creator is simple but lets clients pin its budget; charging holders requires reference-sensitive accounting and makes transfer observable; fixed partitions bound damage but waste slack. Reclamation and accounting are therefore security policy, not a transparent implementation detail.

Endo's durable object graphs face the same choice. A retention edge can keep storage alive, but the platform must separately decide which budget sponsors that retention and what happens when the sponsor withdraws. The archive supports explicit budget capabilities and visible sponsorship rather than pretending reachability alone answers responsibility.

Source: [cap-talk 2007-June archive](http://www.eros-os.org/pipermail/cap-talk/2007-June/) (Internet Archive original-bytes snapshot `web/20160729210151id_/.../2007-June.txt.gz`, sha256 `e1f67358`), messages dated 2007-06-15 to 2007-06-25.
