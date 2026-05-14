---
title: Problem and permits — TextEncoder/TextDecoder on universalPropertyNames
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
notes: **Status: Not Started** upstream. Sibling of [[endo-but-for-bots--llm-designs-hardened-url-shim]] (split out per PR #84 review on the URL shim). Unlike URL, these codecs have **no ambient-authority static methods and no exposed iterator prototype** — the taming story is straightforward and lands on `universalPropertyNames` directly.
---

Endo's hardened-JavaScript model rests on the premise that **every
intrinsic shared between fearlessly coöperating compartments is
either a powerless data constructor or has been carefully tamed.**
The host's `TextEncoder` and `TextDecoder` are broadly useful — UTF-8
round-tripping for byte-oriented work, the canonical portable
alternative to Node's `Buffer` — and would be welcome additions to
the permitted intrinsics. Unlike `URL`, the text codecs have:

- **No ambient-authority static methods** (URL has `URL.createObjectURL`).
- **No exposed iterator prototype** (URLSearchParams has its own iterator that requires throwaway-instance sampling).

The taming story is therefore the simplest of the three placements
in the permits-bucket framework (see [[permits-buckets]]).

## Three-bucket framework (recap)

`packages/ses/src/permits.js` distinguishes three relevant buckets:

| Bucket | What lives there | When created |
|---|---|---|
| `universalPropertyNames` | Powerless data and constructors that live on **every global** | Start compartment + every post-lockdown compartment |
| `initialGlobalPropertyNames` | **Powered** variants — `Date`, `Error`, `RegExp`, `Math` | Start compartment only |
| `sharedGlobalPropertyNames` | The **tamed, powerless** variants of those same names | Every post-lockdown compartment |

`TextEncoder` and `TextDecoder` are **pure transformations** between
`string` and `Uint8Array`. They have no static side channels, no
ambient-authority methods. They belong on `universalPropertyNames`:
**one identity-equal constructor across the start compartment and
every shared compartment.**

This is the simplest placement — no split between *initial* (powered)
and *shared* (tamed) variants is needed, because there is no powered
variant to tame down to.

## Permits table

| Constructor | Property | Disposition | Rationale |
|---|---|---|---|
| `TextEncoder` | `prototype` | ✓ | Required for instances. |
| `TextEncoder` | `prototype.encode`, `encodeInto` | ✓ | Pure. |
| `TextEncoder` | `prototype.encoding` | ✓ | Pure (always `'utf-8'`). |
| `TextDecoder` | `prototype` | ✓ | Required for instances. |
| `TextDecoder` | `prototype.decode` | ✓ | Pure. |
| `TextDecoder` | `prototype.encoding`, `fatal`, `ignoreBOM` | ✓ | Pure. |

These constructors return `Uint8Array` (already a permitted
intrinsic) or `string`. `TextDecoder`'s constructor accepts a label
and an options bag; both are pure inputs. **No iterator prototypes
are exposed** — which is what distinguishes this case from
[[endo-but-for-bots--llm-designs-hurl--iterator-prototype-sampling]]
(URLSearchParams needed throwaway-instance sampling to seed the
iterator prototype permit).
