---
title: "Formal proof, engineering knowledge, and confinement"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2002-November/
source_snapshot: http://web.archive.org/web/20160730013000id_/http://www.eros-os.org/pipermail/cap-talk/2002-November.txt.gz
source_content_sha256: 1c1a70504c384a987403d72ba94f616309199c58f056114027d8f91bc5822b2c
source_authors: [Jonathan S. Shapiro, Mark S. Miller, Tyler Close, Constantine Plotnikov]
source_date: 2002-11-07 to 2002-11-12
thread_subject: "incompleteness / Knowledge vs Proof"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-theory, capability-security, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Shapiro's long answer to a Gödel-inspired attack on secure operating systems distinguishes proof of a protection model from proof of an implementation. EROS is not known bug-free; the important result is that its simple authority-flow model can enforce a useful confinement policy and can be implemented efficiently, while Unix and Windows lack both an effective protection model and a simple behavioral specification to verify against. Miller then disputes the claim that this was known "for the first time": KeyKOS designers already had convincing informal proofs. Shapiro answers that published verification both falsified prior impossibility arguments and exposed the exact invariants a family of implementations must preserve. The exchange records the transition from tacit capability engineering to the explicit model distinctions soon used in the 2003 papers.

## What the proof establishes

The proof does not certify all EROS code. It establishes that a capability system corresponding to the model can enforce confinement and identifies the correspondence obligations for an implementation. That gives optimization and design work a reference question: does this change preserve the model relation?

## What engineering knowledge established first

Miller argues that Hardy, Drexler, and the KeyKOS community knew factories worked through strong informal reasoning. Shapiro accepts the engineering insight but reserves field-level "knowledge" for an archival explanation that defeats contrary published proofs. Formalization also separates weak from read-only behavior, generalizes beyond one mechanism, and explains which additional discrete capabilities remain safe.

## Confinement is useful but not all of security

Close objects that EROS-style confinement blocks overt collaboration but not every covert channel, and therefore is not a prerequisite for all secure computing. Shapiro's narrower claim survives: inevitable covert channels do not justify arbitrary overt ones. Confinement is necessary when mutually suspicious agents must not collaborate, sometimes insufficient, and not synonymous with the whole security problem.

Source: [cap-talk 2002-November archive](http://www.eros-os.org/pipermail/cap-talk/2002-November/) (Internet Archive original-bytes snapshot `web/20160730013000id_/.../2002-November.txt.gz`, sha256 `1c1a7050`), messages dated 2002-11-07 to 2002-11-12.
