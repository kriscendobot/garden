from_host: endolin-garden-ece02cb4
from: reaper:endolin-garden-ece02cb4
sent_at: 2026-08-28T17:13:09Z
doom_base: local-verify-endo-test-xs-cargo-parity
doom_signature: deadline-overrun
notice_count: 1
first_seen: 2026-08-28T17:13:09Z
last_seen: 2026-08-28T17:13:09Z
---
DOOM job PARKED in jobs/plan/ (held, gate=go-ahead) after 1 handler wall hit(s) on endolin-garden-ece02cb4.
The handler returned rc=124 at its applied 7200s wall-clock budget without productive progress.
One such observation is conclusive, so the reaper did not spend another full handler budget.
Split the work into claim-sized stages or raise its handler-timeout.
The work is preserved at jobs/plan/local-verify-endo-test-xs-cargo-parity; it stays HELD until a human promotes it
(promote-plan.sh local-verify-endo-test-xs-cargo-parity) or removes it.
Original job base: local-verify-endo-test-xs-cargo-parity

--- original job body ---
---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

Close the remaining local-verify environment parity exposed after `test:xs` coverage landed in commit 4c1c39ee15. A real run against endojs/endo-but-for-bots@llm used the CI-pinned Moddable 5.0.0 xst successfully, then `@endo/hardened262` failed before exercising Ironhorse because the garden image has no `cargo`; the isolated worktree also has the CI-required `c/moddable` submodule uninitialized. Mirror the `test-xs` workflow prerequisites generically, preserve silent-on-success, and add regression coverage. Evidence blob in project worktree at the originating job was deeb55ea4c940dbbd69335b23b48ed8cac441563.
