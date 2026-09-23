---
title: "Capability URLs in practice: usable sharing and ambient leakage"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-December/
source_snapshot: https://web.archive.org/web/20160729223149id_/http://www.eros-os.org/pipermail/cap-talk/2008-December.txt.gz
source_content_sha256: 876079589fb20f2a41dcc6bf67d1b53be82c3a706aded4c2437b8af3494b304c
source_authors: [Zooko Wilcox-O'Hearn, Bill Frantz, Mike Samuel, Mark S. Miller, Sandro Magi, Alan H. Karp]
source_date: 2008-12-01 to 2008-12-04
thread_subject: "do caps-in-URLs work in practice?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, identity, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Tahoe users showed that bearer capability URLs can be a workable sharing interface, but the browser and surrounding application ecosystem routinely treat URLs as public names. History, referrers, printing, shortening, logging, and wrapper login systems can disclose or replace the capability semantics.

Zooko reports mixed early evidence: users understood direct capability sharing better than feared, while a hosted product wrapped long Tahoe capabilities in conventional accounts and short links. Read, write, immutable, and mutable capabilities also differ in what accidental publication means. URL fragments may keep secrets out of HTTP requests, but UI and extension behavior still require concrete attack testing.

The thread leaves an empirical question rather than a universal verdict. Endo sturdyrefs exposed as URLs need channel-specific redaction, compact aliases, and clear facet semantics; a capability-secure substrate does not prevent a higher layer from rebuilding identity access control or leaking the bearer token.

Source: [cap-talk 2008-December archive](http://www.eros-os.org/pipermail/cap-talk/2008-December/) (Internet Archive original-bytes snapshot `web/20160729223149id_/.../2008-December.txt.gz`, sha256 `87607958`), messages dated 2008-12-01 to 2008-12-04.
