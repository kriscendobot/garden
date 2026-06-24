---
title: OCapN Model (overview)
source: draft-specifications/Model.md
source_repo: kriscendobot/ocapn
source_commit: 971eadd133f36b0d57bd32d29d83f221e81b9c1b
source_date: 2025-06-23
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
project: ocapn
topics: [ocapn, marshal, pass-style]
status: current
notes: Overlap with the Endo passable data model is the user-flagged reason for ingesting this spec. See library/topics/pass-style.md and the per-section notes below for the mapping.
---

> Abstract: Frame for the upstream protocol's value-model spec. Defines what kinds of values cross the wire and how they relate. Direct overlap with Endo's pass-style classification: every OCapN model category maps to one or more pass-styles in the Endo realization. The detailed mapping is covered in the per-section notes below.


This document captures a summary of consensus and remaining contention for the
OCapN data model and abstract syntax, excluding the concern of concrete
representation of these on the wire, but including non-normative
representations in a selection of implementation languages.

Commentary in block quotes is not normative.

> Non-normative commentary.


Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
