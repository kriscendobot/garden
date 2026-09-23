---
title: "Statement of work, milestones, and deliverables"
source: http://www.combex.com/tech/darpaBrowser.html
source_kind: web
source_url: http://www.combex.com/tech/darpaBrowser.html
source_fetched_via: wayback
source_wayback_url: http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html
source_wayback_timestamp: 20260504023216
source_content_sha256: 3a68fd803bbbddc03fa419d5351ee7a03ac1df9620d96e51257c6862858f86bd
source_authors: [Combex, Inc.]
source_date: 2026-06-28
ingested: 2026-06-28
ingested_by: scholar
topics: [capability-security]
status: current
---

## Abstract

The DarpaBrowser project's statement of work: the components to be built (capBrowseFrame on capWT, the Benign and Malicious Renderers, the Sanitized Linux E Language Machine), the 4/8/12-month milestones, and the deliverables — including the commitment to open-source the Capability Windowing Toolkit (capWT) under the Mozilla license and to deliver a full security audit of the confinement.

## Content

**Scope.** "This project will investigate the application of capability security to a client application problem of moderate complexity, namely, the confinement of an HTML rendering engine in such a fashion that it cannot compromise other parts of the system." The aim is to "demonstrate the flexible power of capability security to enable a broad spectrum of safe, reliable computing without locking the user or the system into a structure that does not allow meeting diverse computing requirements."

**Milestones.**

- **4 months:** a demo of a preliminary `capBrowseFrame` running with the Benign Renderer and an early prototype of the Malicious Renderer (without the Sanitized Linux).
- **8 months:** a preliminary version of the entire E Language Machine running `capBrowseFrame` and both renderers (not yet reviewed by outside consultants, not fully tested).
- **12 months (contract completion):** delivery of all specified items.

**Tasks.** Develop `capBrowseFrame` (based on capWT, which drives the browser frame and mediates the renderer's requests for information); the Benign and Malicious Renderer plug-ins; the Sanitized Linux underpinning the E Language Machine; integrate Sanitized Linux, the Java Runtime Environment, and the E Interpreter into the E Language Machine; load and exercise the whole stack; and "Test and audit capBrowseFrame's confinement of the renderers."

**Deliverables.** Monthly status reports; an architecture report including "analysis made by the outside security reviewers and their attempts at breaching the system" and an analysis of alternative technologies for capability-based clients; full source and binaries for the Sanitized Linux OS, the E virtual machine and interpreter, capWT, capBrowseFrame, and both renderers (the JRE sources excepted for licensing reasons). Combex committed to **open-source capWT under the Mozilla license**: "We believe this will accelerate development of capability systems throughout the industry, and particularly in further work on capability secure military systems." The physical deliverable is "One complete computer that, upon boot-up, becomes a capability-secure E Language Machine and runs Edesk, the E software development environment Ebrowser, and the capBrowseFrame with both the Benign Renderer and the Malicious Renderer plug-ins", plus an installation manual for converting additional computers into E Language Machines.

Source: [The DarpaBrowser](http://www.combex.com/tech/darpaBrowser.html) — captured via the Internet Archive (`source_fetched_via=wayback`) at [web/20260504023216id_/](http://web.archive.org/web/20260504023216id_/http://www.combex.com/tech/darpaBrowser.html), content SHA-256 `3a68fd80`.
