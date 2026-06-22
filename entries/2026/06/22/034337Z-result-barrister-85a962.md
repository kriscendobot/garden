---
ts: 2026-06-22T03:45:00Z
kind: result
role: barrister
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/22/dispatched-by-liaison
---

Code-panel review submitted on endojs/endo-but-for-bots#486 (kumavis: feat: add @endo/claude-sandbox).

PR: open, isDraft: true. Author: kumavis (external). Review: CHANGES_REQUESTED.

Panel execution: in-band-fallback (Agent tool not available to subagent).
Panel kind: code-panel.
Panel-hints: all 26 seats + 2 cross-panel fired (suppressed: benchmarker only).

Disposition counts:
  must-fix-loop: 3
  summary-fix: 4
  follow-up: 12
  acknowledge: 16
  drop: 0

Must-fix items (fixer brief):

1. src/claude-client-module.js:186-194 -- Replace __getMethodNames__ introspection
   with direct E(credCap).kind() call. kind() is in CredentialsInterface; the
   fallback-to-apiKey silent misconfiguration is the failure mode for oauthToken
   credentials from non-introspectable remotes.

2. src/claude-credentials-module.js:118 -- Add outstanding.delete(handle) after
   materialised = true. The in-process path (claude-credentials-factory.js:240)
   does this; the module path does not. Handle leak on long-running daemons.

3. src/parse-rootfs.js / factory form -- Default blank rootfs resolves to
   node:22-bookworm-slim which lacks the claude CLI. Fix: remove the default
   (force explicit image) or add an inline warning in the form field label/example.

Summary-fix items (post after review; no panel re-run needed):
  - assertSafeCredentialName: use makeError(X`...`) not new Error(...)
  - package.json exports ".": point to ./factory.js not ./src/claude-sandbox-factory.js
  - package.json exports "./src/claude-client.js": gate or document as non-public

Formal review submitted as CHANGES_REQUESTED (review ID 4540929027).
@copilot reviewer added.

Next stage: next: liaison (external PR; fixer dispatch requires maintainer decision).

Self-improvement: the __getMethodNames__ introspection anti-pattern on Endo capability
interfaces is worth encoding as a project-level rule. Gardener message drafted inline
with 8 proposed-rule items. Outstanding handle leak divergence between in-process and
module-path credential implementations is a recurring class of bug (two implementations
of the same interface diverging on a single cleanup step); consider a shared issueCap
helper for both paths to keep them in sync.
