---
title: "Attenuated drag-and-drop as designation plus facet selection"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2008-December/
source_snapshot: https://web.archive.org/web/20160729223149id_/http://www.eros-os.org/pipermail/cap-talk/2008-December.txt.gz
source_content_sha256: 876079589fb20f2a41dcc6bf67d1b53be82c3a706aded4c2437b8af3494b304c
source_authors: [Rob Meijer, Alan H. Karp, Mark S. Miller, Brian Warner, Kevin Reid, John Carlson, Raoul Duke, Mike Stay, James A. Donald]
source_date: 2008-12-09 to 2008-12-13
thread_subject: "Drag and Attenuated Drop?"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Drag-and-drop naturally designates an object and a recipient, but ordinary drag-and-drop may convey the source's strongest reference. An attenuating broker can instead mint or select a read-only, append-only, copy-on-write, or revocable facet as part of the drop gesture.

The exchange asks whether attenuation belongs to the source, destination, user gesture, or trusted desktop. The coherent capability pattern keeps the trusted UI in charge of the transfer protocol while the source object supplies supported facets. The destination receives only the selected reference; it does not learn an ambient filename and reopen the object with broader rights.

This extends the PowerBox insight beyond file-open. Endo UI brokers can make ordinary gestures carry narrow authority, provided the attenuation choice is visible and the untrusted application cannot counterfeit either endpoint.

Source: [cap-talk 2008-December archive](http://www.eros-os.org/pipermail/cap-talk/2008-December/) (Internet Archive original-bytes snapshot `web/20160729223149id_/.../2008-December.txt.gz`, sha256 `87607958`), messages dated 2008-12-09 to 2008-12-13.
