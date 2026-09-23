---
title: "Auditing capability systems"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2003-October/
source_snapshot: http://web.archive.org/web/20160730015229id_/http://www.eros-os.org/pipermail/cap-talk/2003-October.txt.gz
source_content_sha256: 5c3eea510fe625cf0629554a05b5b9e770b6bb912af6d60d4c4f26d19ead7806
source_authors: [Bill Frantz, David Hopwood, Ben Laurie, Eyal Lotem, Jonathan S. Shapiro]
source_date: 2003-10-01 to 2003-10-13
thread_subject: "Auditing Capability Systems"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, process-monitoring]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Frantz proposes auditing an object-capability system by checking whether its reference graph and trusted objects satisfy policy. The discussion turns the seemingly simple graph traversal into three separate problems: obtain a consistent snapshot, recognize behavioral claims about branded objects or confined subgraphs, and preserve the policy invariant as execution resumes. Most importantly, a complete auditor would need authority to inspect nearly every reference. Shapiro argues that no principal can rationally hold that power because the disclosure risk may exceed the risk of an undetected error; prevention and locally maintained invariants can be safer than omniscient after-the-fact inspection.

## What a graph audit would need

EROS and KeyKOS can expose node graphs and consistent checkpoints; a garbage-collected language already distinguishes references from non-reference data. Brands and code pages can help recognize trusted implementations. A snapshot avoids an active object moving a suspicious edge ahead of the traversal, but the system still needs mediation that preserves the checked invariant after the snapshot.

## Attenuating the auditor

Hopwood suggests transitively read-only inspection, omitting functional subgraphs that cannot cause side effects, and branding standard confinement constructions so the auditor can verify the boundary without reading sensitive pure data inside it. These reduce authority but do not erase the fundamental tension: an object able to hide relevant outgoing edges can hide a breach, while a global observer can expose every secret.

## Recovery value and limit

Audit logs and graph checks can bound damage after a vulnerable component is found, show whether security structures changed, and sometimes avoid a full rebuild. They cannot make a vulnerable external-facing library correct. The thread therefore treats audit as one layer of evidence and recovery, not a substitute for safe languages, simpler systems, or prevention.

Source: [cap-talk 2003-October archive](http://www.eros-os.org/pipermail/cap-talk/2003-October/) (Internet Archive original-bytes snapshot `web/20160730015229id_/.../2003-October.txt.gz`, sha256 `5c3eea51`), messages dated 2003-10-01 to 2003-10-13.
