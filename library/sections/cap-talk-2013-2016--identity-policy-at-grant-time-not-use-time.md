---
title: "Identity policy at grant time, not use time"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2014-October/
source_snapshot: http://web.archive.org/web/2id_/http://www.eros-os.org/pipermail/cap-talk/2014-October.txt.gz
source_content_sha256: f8ffa91e247c32d1b81a3c058a55100702720f9669c0391424afcf98d9c67cf1
source_authors: [Neal Walfield, Raoul Duke, Marc Stiegler, Alan Karp, James Donald, Domenico Rotondi, Rob Meijer]
source_date: 2014-10-14 to 2014-10-29
thread_subject: "Avoiding IBAC"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: An OwnCloud policy — let Alice share a file with coworker Bob but warn or block sharing with outsider Carol — appears to require identity-based access control. Karp's distinction resolves much of the tension: identity, roles, or labels may inform the **grant decision** without becoming the **access decision**. A file's `delegate` facet can check a proposed recipient when minting a capability; later use of that capability remains possession-based and does not repeatedly consult the caller's identity. This keeps designation coupled to authority while allowing administrative policy to narrow delegation.

Stiegler and Karp also reject an absolute prohibition when Alice is not malicious and can always exfiltrate by email or camera. Voluntary Oblivious Compliance makes the safe path easiest, warns on exceptional grants, records accountability, and preserves an override for legitimate emergencies. The still-open boundary is whether object-to-recipient labels are merely an ACL moved earlier in time. The thread's answer is conditional: they are compatible with ocaps only when they can subtract grants and never manufacture authority at invocation time.

Source: [cap-talk 2014-October archive](http://www.eros-os.org/pipermail/cap-talk/2014-October/) (Internet Archive original-bytes `id_` snapshot of `2014-October.txt.gz`, sha256 `f8ffa91e`), thread "Avoiding IBAC", 2014-10-14 to 2014-10-29.
