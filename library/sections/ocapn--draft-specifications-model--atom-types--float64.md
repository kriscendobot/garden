---
title: Float64
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

([JSON](#json-invariants))

An IEEE 754 64-bit floating point number.

OCapN preserves the distinction between +0 and -0.

| Language       | Negative | Positive |
|----------------|---------:|---------:|
| **Guile**      | `-0.0`   | `0.0`    |
| **JavaScript** | `-0`     | `0`      |
| **Python**     | `-0.0`   | `0.0`    |

OCapN preserves positive and negative infinity.

| Language       | Negative        | Positive       |
|----------------|----------------:|---------------:|
| **Guile**      | `-inf.0`        | `+inf.0`       |
| **JavaScript** | `-Infinity`     | `Infinity`     |
| **Python**     | `float('-inf')` | `float('inf')` |

OCapN collapses the complete set of NaN values to a single abstract NaN.

OCapN provides no support for other floating point precisions.

> - **Guile**: `+nan.0`
> - **JavaScript**: `NaN`
> - **Python**: `float('nan')`
>
> Tracking: https://github.com/ocapn/ocapn/issues/58
>
> OCapN round-trips all floating point numbers representable within IEEE 754
> binary64, except that OCapN considers all NaNs as equivalent, that is, as jointly
> representing a single abstract NaN value.
> So, any concrete NaN representation may validly round trip even if it results
> in a different concrete representation.
> However, we encourage use of a canonical representation for NaN.
>
> Concretely, the canonical NaN is `0x7ff8_0000_0000_0000`, though this is not
> a concern of the abstract syntax and data model.
>
> All real and finite double precision floating point numbers participate in the
> JSON subset of OCapN.
> We expect OCapN-compatible JSON codecs, including the JavaScript `JSON` codec,
> to round-trip all numbers except NaNs, infinities, and negative zero, but all
> other numbers expressible with an IEEE 754 double-precision float to survive a
> round trip without loss of precision.
> We also do not expect integers expressed with higher precision in JSON to
> survive a round-trip through an OCapN-compatible JSON codec.
>
> Consensus on preserving -0:
> - As of May 16, @erights insisted that -0 round trip to 0 https://github.com/ocapn/ocapn/issues/5#issuecomment-1550020450
> - On May 23, @zenhack proposed preserving -0 https://github.com/ocapn/ocapn/issues/5#issuecomment-1560116857
> - We converged out of band and Agoric has committed to preserving -0 https://github.com/endojs/endo/issues/1602

For purposes of [Pass Invariant Equality](#pass-invariant-equality):
- Every finite Float64 is equal to any other Float64 with the same bitwise
  representation.
- Every infinite Float64 is equal to any other infinite Float64 of the same
  sign.
- There is only one NaN value and it is equal to itself.

> JavaScript's `Object.is` is consistent with Pass Invariant Equality, whereas
> `==` and `===` are not.

Source: `draft-specifications/Model.md` in the upstream protocol's specification (held at `kriscendobot/ocapn` locally) at commit `971eadd1`.
