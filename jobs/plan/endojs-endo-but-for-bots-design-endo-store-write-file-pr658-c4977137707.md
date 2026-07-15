---
gate: orchestrated
orchestrated_by: endojs-endo-but-for-bots-pr658-c4977137707-design-followups
priority: normal
role: designer
posted_by: gardener
posted_at: 2026-07-15T05:23:47Z
---

# Design: make `endo store` drive `writeFile`

Repository: endojs/endo-but-for-bots
Originating directive: https://github.com/endojs/endo-but-for-bots/pull/658#issuecomment-4977137707

Draft a self-contained design for `endo store` to drive `writeFile`. Ordinary `EndoDirectory` instances, not only mounts or name hubs, should support `writeFile`. Define the capability and API model, behavior and error cases, compatibility and migration considerations, implementation boundaries, and verification plan. Surface unresolved choices as explicit open questions.
