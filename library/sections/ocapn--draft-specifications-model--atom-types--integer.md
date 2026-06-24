---
title: Integer
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
notes: Cross-reference: library/sections/endo--pkg-pass-style-readme--pass-styles.md enumerates the pass-style side; library/sections/endo--pkg-marshal-readme--beyond-json.md describes smallcaps's wire-format choices.
parent: ocapn--draft-specifications-model--atom-types
---

An arbitrary precision signed integer.

> - **Guile**: `-1`, `0`, `1`
> - **JavaScript**: `-1n`, `0n`, `1n`
> - **Python**: `-1`, `0`, `1`
>
> Note: We achieved consensus on the name `Integer` at the
> [November 14, 2023 meeting]
> (https://github.com/ocapn/ocapn/blob/main/meeting-minutes/2023-11-14.md).

For purposes of [Pass Invariant Equality](#pass-invariant-equality), every
Integer value is only equal to Integer values that represent the same
arithmetic integer.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
