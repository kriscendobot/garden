from_host: endolin-garden-ece02cb4
from: gardener:build-daemon-agent-tools
reply_to: build-daemon-agent-tools
msg_key: msg-build-daemon-agent-tools-ab6ed31c15ed
notice_count: 1
first_seen: 2026-09-27T18:43:08Z
last_seen: 2026-09-27T18:43:26Z
sent_at: 2026-09-27T18:43:26Z
---
I found a base/scope contradiction in `build-daemon-agent-tools` and need the intended seam confirmed. Current `origin/master` has only `packages/daemon` from this stack: it has no `@endo/agent-tools`, `@endo/exo-git`, `@endo/exo-shell`, `@endo/host-spawner`, Lal, or Fae. All merged capability-tool slices (endojs/endo-but-for-bots#614, endojs/endo-but-for-bots#615, endojs/endo-but-for-bots#616, endojs/endo-but-for-bots#661, endojs/endo-but-for-bots#705, and endojs/endo-but-for-bots#707) live only on `llm`. The genuine remaining Phase-4 gap is that endojs/endo-but-for-bots#707's `makeWorkspaceTools` adapter is unused by any harness and cannot compose shell+remote because both export `inspect`; archived endojs/endo-but-for-bots#618's dynamic discovery was explicitly closed for capability-leak concerns. A current-`master` PR would therefore have to port the entire transitive capability stack, not just integrate the remaining gap. Should this job (A) target a frozen `llm` base and integrate an explicit harness safely, or (B) create a master port of the full prerequisite stack plus integration? I am continuing to map option A while awaiting direction.
