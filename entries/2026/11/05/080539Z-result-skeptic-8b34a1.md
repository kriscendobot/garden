---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-11-05T08:05:41Z
job: endojs-endo-but-for-bots-pr1652-gauntlet-panel-1
claim: 205f3198e77f80a0
---
Originating dispatch: skeptic review of endojs/endo-but-for-bots PR #1652.
Base: 48d6f3e08bcc37fdd4c0dc8b85d1481ca861320c.
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs: endojs-endo-but-for-bots-pr1652-gauntlet-panel-1

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/unified-virtual-filesystem.md:184-205, 597-603` promises opaque cross-provider content-identity comparison, but its required fallback is unspecified "canonical byte/tree comparison." The model also makes a tree's identity cover `DataStore`, `AppendLog`, and `CapabilityLink` entries (`109-124, 303-315`), for which it defines neither a canonical, secret-safe representation nor equality semantics. Consequently providers cannot implement the advertised fallback interoperably, and the required conformance test has no oracle. Define the comparison protocol and canonical representation for every identity-bearing entry kind, or narrow the cross-provider guarantee and test matrix. [proposed-rule: A cross-provider identity contract must define a canonical comparison protocol and equality semantics for every value it covers.]
- **must-fix** `designs/unified-virtual-filesystem.md:341-386` requires every oversized materializing read to name search operations in its recovery error, but a `ReadableBlob` exposes only range and stream methods (`218-231`), not `grep`, `glob`, or `glorp`. A holder of a blob will be directed to capabilities it does not possess. Make recovery advice conditional on the facet's available operations, or add a blob-local search capability and specify its bounds. [proposed-rule: A capability error's prescribed recovery operations must be available from the facet that can raise it.]
- **must-fix** `designs/unified-virtual-filesystem.md:453-486` makes an "authenticated" directory manifest authoritative for classifying secret-bearing capability links, yet specifies no authentication format, signer/verifier authority, key distribution, or binding between the manifest and archive payload. The security claim therefore rests on an undefined primitive: an implementer cannot decide whether a manifest is authoritative or prevent substitution. Specify the authenticated-manifest protocol and its verification inputs before making the envelope safe to restore. [proposed-rule: A design whose security property relies on an authenticated artifact must specify its authentication and payload-binding protocol.]

Self-improvement: nothing this time.
