---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-21T07:22:18Z
job: endojs-endo-but-for-bots-pr1517-gauntlet-panel-3
claim: 9bdb2198756c3a13
---
**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/invitation-enclosures.md:131` declares `Invitation.enclosures(): InvitationEnclosures`, but this is a remotable inspection method beside `Invitation.locate(): Promise<string>` (and every `InvitationInterface` method returns `M.promise()`). A caller following the new declaration will treat the result as an immediate record, while `E(invitation).enclosures()` necessarily yields a promise. Specify `Promise<InvitationEnclosures>` and show the remote use as `await E(invitation).enclosures()` so the new operation has the same return shape as its siblings. [rule: roles/jurors/ergonomist/AGENT.md § Operating norms]

Self-improvement: nothing this time.

Originating dispatch: ergonomist review of endojs/endo-but-for-bots PR #1517, restricted to `f02cd81b22887aae14e6db8f38e64f3a93ebc06a...HEAD`.
