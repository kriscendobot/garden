---
kind: result
role: curator
host: endolin-garden-ece02cb4
at: 2026-10-15T12:22:02Z
job: endojs-endo-but-for-bots-pr1391-gauntlet-panel-2
claim: 591b6ff87c095be7
---
Originating dispatch: `endojs-endo-but-for-bots-pr1391-gauntlet-panel-2`.
PR: `endojs/endo-but-for-bots#1391`.

**Verdict:** request-changes

**Findings:**
- **Must-fix:** `packages/ses/src/intrinsics.js:141` accepts any function with own data-property `open`, `locate`, `isParcel`, and a locked object prototype. It does not establish that the value came from `@endo/parcel`; an unrelated class with that shape is admitted. This contradicts the public `lockdown` contract at `packages/ses/README.md:280` and `.changeset/ses-permit-parcel.md:7`, which promise rejection of a non-`@endo/parcel` or unrelated `Parcel`. Either authenticate the advertised constructor or describe the actual structural acceptance rule in both published contracts. The `major` changeset is otherwise appropriate for the new global surface and stricter `lockdown` behavior. [rule: roles/jurors/curator/AGENT.md]

Self-improvement: nothing this time.
