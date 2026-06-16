---
title: Three-bucket framework (recap)
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
