---
title: "Capability accounting, space banks, and the lost-object problem"
source_kind: mailing-list-archive
source_url: http://www.eros-os.org/pipermail/cap-talk/2006-June/
source_snapshot: https://web.archive.org/web/20160729214752id_/http://www.eros-os.org/pipermail/cap-talk/2006-June.txt.gz
source_content_sha256: f8112d1a9e603197f99a4fc3d7a204c217ce39d9c5fd191184b2bde6b003aae0
source_authors: [Jed Donnelley, Norman Hardy, Ian Grigg, John Carlson, Alan H. Karp, Nick Szabo, Tim Freeman, Sandro Magi, David Mercer, Zooko Wilcox-O'Hearn, David Hopwood]
source_date: 2006-06-21 to 2006-06-29
thread_subject: "Capability accounting"
ingested: 2026-09-16
ingested_by: scholar
topics: [capability-security, capability-theory, cap-talk-open-questions]
status: current
notes: "Derived summary, not the original messages."
---

Abstract: Capability systems need an authority story for resource creation as well as resource use. KeyKOS-style space banks and meters let a caller give a deputy a sub-account, charge allocations to the responsible party, retain a service capability for audit or reclamation, and destroy an isolated account to reclaim otherwise lost objects without global tracing garbage collection.

Jed Donnelley compares NLTSS accounting with Norman Hardy's KeyKOS account creation: a new account receives a sub-space-bank and sub-meter while the creator retains service keys. Objects that become unreachable are not free; they remain charged, giving the account owner an incentive and an authority path to recover or destroy them. The discussion distinguishes the capability exercised by software from the economic responsibility held by a human or organization and asks what audit information should accompany delegated budgets.

The unresolved boundary is how to combine fungible sharing, delegation, revocation, and privacy without either partitioning every resource pool or inventing a global principal. For Endo, this is direct provenance for explicit quota/budget capabilities: resource authority should be delegated alongside the service capability, and retention/accounting should remain inspectable even after ordinary application references are lost.

Source: [cap-talk 2006-June archive](http://www.eros-os.org/pipermail/cap-talk/2006-June/) (Internet Archive original-bytes snapshot `web/20160729214752id_/.../2006-June.txt.gz`, sha256 `f8112d1a`), messages dated 2006-06-21 to 2006-06-29.
