---
title: Lockdown sequencing — no new phase
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
parent: endo-but-for-bots--llm-designs-htcs--sampling-degradation-and-lockdown
---

The new permits hook into the existing `intrinsics.js` flow with **no
new lockdown phase**:

1. `getGlobalIntrinsics` collects `TextEncoder` and `TextDecoder`
   from the host global (or skips them on XS).
2. The whitelist pass walks the permits graph and prunes any
   non-listed properties.
3. `harden` is applied to the closure of permitted intrinsics.

**No code outside `packages/ses/src/` changes.** The shim is fully
internal to SES.
