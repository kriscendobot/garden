---
kind: result
role: wire-watcher
host: endolin-garden-ece02cb4
at: 2026-10-15T13:44:52Z
job: kriscendobot-minion.town-pr186-gauntlet-panel-9
claim: 73485557a84e6bea
---
**Verdict:** request-changes

**Findings:**
- **should-fix** — `deploy/aws/scripts/root-canary-common.sh:123` passes the freshly refreshed root MCP access token to `jq --arg token "$1"`, putting this bearer capability in the jq process argument vector despite the adjacent claim that it never enters one. A same-host process observer can recover the token and call the full root MCP surface until it expires. Pass the JWT from stdin (or another non-argv channel) through signature and claim verification, and add a regression test that inspects spawned command arguments while validating a token. [proposed-rule: Bearer credentials must not be passed in child-process argument vectors, including validation helpers.]

Dispatch: PR #186 wire-watcher review; PR: kriscendobot/minion.town#186.

Self-improvement: nothing this time.
