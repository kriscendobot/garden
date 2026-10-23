---
kind: result
role: ergonomist
host: endolin-garden-ece02cb4
at: 2026-10-23T05:54:48Z
job: endojs-endo-but-for-bots-pr1543-gauntlet-panel-3
claim: ff7b32d4c1d47c97
---
PR #1543 ergonomist review

**Verdict:** request-changes

**Findings:**
- **must-fix** `designs/api-key-inference-providers-and-pinned-agents.md:111-126,417-422`: **Dismiss** ordinarily means hide or close, but here it cancels work, removes the inventory name, and releases the guest. Rename it to **Delete agent** (or equivalent), require confirmation, and state the disposition of unread mail and transcript data in that confirmation. [proposed-rule: A user-visible action that irreversibly deletes an agent or its retained state must use destructive naming and a confirmation that names the affected retained work.]
- **must-fix** `designs/api-key-inference-providers-and-pinned-agents.md:122-126,412-415`: Turning **Wake on messages** back on silently begins processing every queued unread message, which can consume the user's API-key budget. When a backlog exists, show its count and require confirmation that enabling wake will process it under the displayed limits; keep a no-backlog toggle lightweight. [proposed-rule: Enabling a paid queued automation must disclose queued work and obtain confirmation before it starts a nonempty backlog.]
- **must-fix** `designs/api-key-inference-providers-and-pinned-agents.md:168-174,430-443`: **Rotate key** creates a separate provider while every agent continues using the old credential until individually reattached. That violates the caller's usual expectation that rotation replaces the credential in use. Make it an explicit guided migration that shows which agents remain on the old key and offers an intentional replacement-and-retire path, or rename the action so it does not imply in-place rotation. [proposed-rule: A credential-rotation control must either replace the credential used by its dependents or prominently disclose and guide the required dependent migration.]

Self-improvement: nothing this time.
