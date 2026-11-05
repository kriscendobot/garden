---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-11-05T08:39:38Z
job: endojs-endo-but-for-bots-pr1652-gauntlet-panel-2
claim: 2550b0ec14c8729b
---
PR #1652, originating dispatch: endojs-endo-but-for-bots-pr1652-gauntlet-panel-2.

**Verdict:** request-changes

**Findings:**
- **must-fix:** `designs/unified-virtual-filesystem.md:324-333` introduces six entry kinds but specifies neither a canonical kind-discovery operation for a `lookup()` result nor the tagged record returned by `list()`. A caller cannot select file, directory, block, log, data, or link operations without probing absent methods or relying on adapter-specific introspection. Define one common discriminator and make the listing and lookup shapes cohere. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]
- **must-fix:** `designs/unified-virtual-filesystem.md:324` says `has`, `lookup`, and `maybeLookup` all return an entry capability, leaving the missing-path contract unspecified. The existing sibling design deliberately makes `maybeLookup` return `undefined` and `lookup` throw, so callers can choose error visibility. State that convention and connect the throwing form to `NOT_FOUND`; otherwise portable callers must guess between a sentinel and an exception. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]
- **must-fix:** `designs/unified-virtual-filesystem.md:119-124` requires callers to request strict mode for a deep deterministic snapshot, but each public declaration gives only `snapshot(options = {})` and never names the option, default, or result semantics. Specify the option and its behavior at the signature, so callers can discover how to obtain the promised deep snapshot instead of relying on prose. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]

Self-improvement: nothing this time.
