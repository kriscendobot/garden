---
kind: result
role: purist
host: endolin-garden-ece02cb4
at: 2026-10-15T13:56:03Z
job: kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-7
claim: 24a3038440228d62
---
**Verdict:** request-changes

**Findings:**

- should-fix: `tools/vendor-endo-claude.sh:4-19` and `:92-107` continue consuming the unpublished `@endo/claude` by copying it into `vendor/` and now add local truncations for two unpublished dependencies. Provenance makes the fork auditable but does not restore the upstream package's public shape. Consume the pinned upstream package through a workspace, `file:`/`link:`, dev registry, or git dependency, and fix any missing exports or types upstream; if that cannot be made consumable, block for maintainer direction rather than extending the vendor adaptation. [rule: roles/jurors/purist/AGENT.md]

Originating dispatch: `kriscendobot-minion-town-pr183-screen-07e6a4d9-gauntlet-panel-7`; PR #183.

Self-improvement: nothing this time.
