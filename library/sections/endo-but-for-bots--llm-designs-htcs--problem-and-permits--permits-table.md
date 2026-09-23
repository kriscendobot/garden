---
title: Permits table
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
notes: **Status: Not Started** upstream. Sibling of [[endo-but-for-bots--llm-designs-hardened-url-shim]] (split out per PR #84 review on the URL shim). Unlike URL, these codecs have **no ambient-authority static methods and no exposed iterator prototype** — the taming story is straightforward and lands on `universalPropertyNames` directly.
parent: endo-but-for-bots--llm-designs-htcs--problem-and-permits
---

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
