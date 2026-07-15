---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-15T05:25:17Z -->

# Design: make `endo store` drive `writeFile`

Repository: endojs/endo-but-for-bots
Originating directive: https://github.com/endojs/endo-but-for-bots/pull/658#issuecomment-4977137707

Draft a self-contained design for `endo store` to drive `writeFile`. Ordinary `EndoDirectory` instances, not only mounts or name hubs, should support `writeFile`. Define the capability and API model, behavior and error cases, compatibility and migration considerations, implementation boundaries, and verification plan. Surface unresolved choices as explicit open questions.

<!-- garden-reaped: 2 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 20
  worker_kind: gardener
  claimed_at: 2026-07-15T13:33:27Z
