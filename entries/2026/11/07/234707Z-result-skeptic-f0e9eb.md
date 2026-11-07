---
kind: result
role: skeptic
host: endolin-garden-ece02cb4
at: 2026-11-07T23:47:09Z
---
Originating dispatch: `kriscendobot-minion.town-pr230-gauntlet-panel-3`; PR #230.

**Verdict:** request-changes

**Findings:**
- **must-fix:** `designs/clip-governor-column.md:174-193,284` says mint and revoke are CSRF-checked "like the other mutating `/account` routes", but this checkout's only such route, `PUT /account/clips/order`, accepts a cookie-authenticated request with no CSRF validation or token source. The design therefore assumes an admission mechanism that does not exist and gives neither a token/bootstrap protocol nor `pagehide`/`keepalive` semantics that could carry it. Define the concrete same-origin/Origin or token validation contract, its shell acquisition path, and rejection tests before relying on it to keep a clip from minting or revoking a locator. [proposed-rule: A design that makes a cookie-authenticated mutation security claim must specify the concrete CSRF admission mechanism and test its absent, cross-origin, and valid cases.]
- **must-fix:** `designs/clip-governor-column.md:249-253,501-527,616-621,867-869` assumes every rejected CapTP mutation simply failed. A socket can drop after `clone`, `destroy`, `setOrder`, or a later child mutation commits and before its result reaches the shell. Calling Clone again duplicates a capability-bearing clip; reporting Destroy as failed leaves the owner with the wrong state. Add durable operation identifiers and result lookup, or an explicit reconciliation/outcome-unknown interaction, and inject a post-commit/pre-reply disconnect for every mutating rung. [proposed-rule: Every remotely committed mutation must define and test its ambiguous-result recovery path; transport loss after commit must not be represented as a known failure or allow accidental duplicate authority grants.]

Self-improvement: nothing this time.
