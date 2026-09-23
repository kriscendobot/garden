---
job: 234bf0
posted_by_role: solicitor
posted_by_host: endolinbot
posted_at: 2026-05-23T00:44:57Z
verb: fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 343
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
  - general-contractor
preconditions: []
refs: []
---

Summary-fix bundle for design PR #343 (`design/gateway-package.md`) after the solicitor's 2026-05-23 panel review (round post-fixer-7-OQ-resolutions). Four items; no must-fix-loop; no panel re-run required after this fixer dispatch. PR was un-drafted on this round.

Branch: `design/gateway-package` on `endojs/endo-but-for-bots` (currently at `ba4c81236`).

## Bundle (four items)

1. **critic — orphaned `setVirtualHostAllocationPolicy`.** `designs/gateway-package.md:630-631, 862` — OQ3's resolution (virtual hosting is gateway-assigned, not DNS-based) eliminated the operator-policy collision-resolution shape. The `GatewayAdmin.setVirtualHostAllocationPolicy(policy: AllocationPolicy)` method and the `AllocationPolicy` type are now orphaned by the OQ3 rewrite. Either delete both (and the line-862 entry in the Capability Surface listing) or re-justify the method as governing gateway-side allocation of identifiers (a different concern; would need its own paragraph and type definition). The clean delete is the lower-risk option absent a positive case for keeping it. [rule: skills/changeset-discipline/SKILL.md § scope-by-coherence]

2. **critic + copyeditor — OQ5 has two contradictory paragraphs.** `designs/gateway-package.md:1115-1130` — the pre-fix sentence "the gateway-side cache shape is still underspecified." sits one blank line above the post-fix "Resolved framing: the long-term intent is to use **Git** for the CAS itself." A reader cannot tell whether the OQ is open or resolved. Fold the two paragraphs into one with a brief lede ("Earlier framing flagged the cache shape as underspecified; the resolution below names Git as the long-term CAS.") or delete the obsolete sentence outright and lead with the resolution. [rule: skills/changeset-discipline/SKILL.md § no-dead-prose]

3. **ergonomist — Feature 2: name the alias-vs-identifier distinction at the `bind('chat', ...)` example.** `designs/gateway-package.md:243-310` — the example at line 297 reads `await E(apps).bind('chat', chatWebletId)` and OQ3's clarification says routing keys are gateway-assigned identifiers. Add one sentence at the introduction of the `bind` example, between lines 293 and 294: "The short name `chat` is a local alias on the user's `@apps` NameHub; the gateway routes by the bound `webletFormulaId`, not by the alias." This closes the loop between the user-facing API and the routing surface. [proposed-rule]

4. **novice — OQ7: name what downstream readers must adjust.** `designs/gateway-package.md:1137-1154` — the resolution paragraph leads with "the daemon does **not** come with a web server; it can be extended by one" and immediately drops into phase-1 mechanics. Between those, add one sentence naming the consequence for downstream readers: "What this changes for downstream readers: the Familiar must bundle its own gateway, and the developer install transitions from in-daemon HTTP to embedded `@endo/gateway`." [proposed-rule]

## Acceptance

After the fixer's commits land, the panel is satisfied; no panel re-run. The fixer should:

- Push to `design/gateway-package` (PR #343's head branch).
- Submit a top-level summary comment citing each addressing SHA per `roles/COMMON.md` § External-repo etiquette fixer norm; the per-action authorization for thread replies is implicit in this summary-fix job's framing.

The PR is already un-drafted on this round; addressing the bundle does not require another solicitor pass.

## Origin

- Solicitor formal review on PR #343 submitted at 2026-05-23T00:43:48Z (comment, 11644 bytes; no must-fix-loop dispositions).
- Maintainer's `CHANGES_REQUESTED` review: 2026-05-22T00:30:43Z by @kriskowal (the trigger for the seven OQ-resolution commits 6fe0f04 through ba4c812).
