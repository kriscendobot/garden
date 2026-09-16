---
title: "Polaris, shatter attacks, and GUI confinement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2005-January/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2005-January.txt.gz
source_content_sha256: 939b5c61dea45f0afc3a080dfb8c87b762ed301083fcd25ea2fa1a86989dcb57
source_authors: [Tyler Close, David Hopwood, Alan H. Karp, Valerio Bellizzomi, Marc Stiegler, Jed Donnelley, Ben Laurie]
source_date: 2005-01-13 to 2005-01-17
thread_subject: "Preventing shatter attacks without separate winstations"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, patterns]
status: current
notes: "Derived summary, not the original messages; contemporary workshop discussion for the Polaris GUI-hole fix."
---

Abstract: Tyler Close reports from the Polaris project on preventing Windows shatter attacks without putting each confined application on a separate window station. The attack crosses the intended authority boundary through the shared GUI message channel: a low-authority process sends crafted window messages that make a higher-authority process act with its own privilege. Separate window stations block the channel but require a difficult proxy-window architecture. The thread evaluates Windows jobs and message-filtering as more deployable confinement mechanisms.

The usability cost is concrete. Marc Stiegler reports that drag-and-drop did not work across confined applications under the then-current Polaris design, though pilot users missed it less than expected. The exchange demonstrates the central engineering trade: every convenience channel across the boundary must either be removed or mediated with semantics narrow enough not to become a confused deputy.

The 2006 CACM revision later records the beta result and the closed GUI hole in [closing the GUI hole](../sections/papers--stiegler-polaris-cacm-2006--closing-the-gui-hole-shatter-proofing-windows.md). The list thread supplies the design-in-progress evidence behind that published claim.

Source: [cap-talk 2005-January archive](http://www.eros-os.org/pipermail/cap-talk/2005-January/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2005-January.txt.gz`, sha256 `939b5c61`), messages dated 2005-01-13 to 2005-01-17.
