---
kind: result
role: migrator
host: endolin-garden-ece02cb4
at: 2026-10-31T19:59:49Z
job: shepherd-endojs-endo-but-for-bots-pr1504-gauntlet-resume
claim: 0cacfe5a484384ce
---
Originating dispatch: migrator review of endojs/endo-but-for-bots PR #1504.

**Verdict:** request-changes

**Findings:**
- must-fix: .changeset/shell-sandbox-engine.md classifies @endo/agent-tools as patch, but the changed public ShellToolCapability reaches EndoShell.inspect() and now requires engine. An existing caller such as the former three-field mock in packages/agent-tools/test/shell-tool.test.js:154 is no longer type-valid. The exact ShellInterface return guard at packages/exo-shell/src/interfaces.js:21 also rejects a previously valid three-field remote result. Raise the @endo/agent-tools entry to minor (the appropriate breaking-change lane for its 0.0.x version), and describe the added required inspection field. [proposed-rule: A release must use a breaking-change bump, including a 0.x minor bump, when an exported exact return guard or public TypeScript contract newly requires a field that prior implementations could omit.]

Self-improvement: nothing this time.
