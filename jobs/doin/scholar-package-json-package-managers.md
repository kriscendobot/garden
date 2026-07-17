---
role: scholar
---
# Scholar: how package managers read package.json (Yarn, pnpm, Bun)

Follow-on to scholar-package-json-schema-and-tooling. Ingest as library sources (pinned commits) how Yarn Classic (v1), Yarn Berry (v2+, incl. PnP), pnpm, and Bun consume package.json, and back the matrix/inconsistencies rows flagged (synthesis):
- Yarn Berry: resolutions, packageExtensions, workspace: protocol, PnP strict visibility, publishConfig.
- pnpm: pnpm.overrides / pnpm.packageExtensions / pnpm.peerDependencyRules / pnpm.patchedDependencies, pnpm-workspace.yaml (workspaces divergence), symlinked strict layout.
- Bun: trustedDependencies, bun condition, reads overrides+resolutions, workspaces.
- packageManager field + Corepack.
- Focus: override dialects, peerDependencies auto-install differences, PnP vs node_modules vs pnpm strict layout. Add sections under topic `package-manifest`; update the project report; note remaining synthesis.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 19
  worker_kind: gardener
  claimed_at: 2026-07-17T05:55:50Z
