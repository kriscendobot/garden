---
title: "Confused deputy as ambient-authority failure"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2007-February/
source_snapshot: https://web.archive.org/web/20160730000000id_/http://www.eros-os.org/pipermail/cap-talk/2007-February.txt.gz
source_content_sha256: eb45a908d56a85900169ab30b1eb82afd2548b07fea7c9453c1154e6aafbf74e
source_authors: [Juraj Kosik, Toby Murray, Jonathan S. Shapiro]
source_date: 2007-02-26
thread_subject: "basic question: concerning confused deputy"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: A short introductory exchange restates the confused-deputy problem in its minimal form. A deputy holds authority from one source, accepts a designation from another, and accidentally combines them. The classic compiler can write its billing file and accepts an output filename from an untrusted caller; when both are names in one ambient namespace, the caller can direct the compiler's authority at the billing file.

The capability repair is contextual authority: pass the intended output object, not a forgeable global name that the deputy resolves using its own ambient rights. The deputy no longer asks who the caller is or consults a broad authority set. It invokes the specific reference supplied for that argument.

This compact thread matches the property account in [*Capability Myths Demolished*](../sections/papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy--body.md): no designation without authority plus no ambient authority produces an unconfusable deputy.

Source: [cap-talk 2007-February archive](http://www.eros-os.org/pipermail/cap-talk/2007-February/) (Internet Archive original-bytes snapshot `web/20160730000000id_/.../2007-February.txt.gz`, sha256 `eb45a908`), messages dated 2007-02-26.
