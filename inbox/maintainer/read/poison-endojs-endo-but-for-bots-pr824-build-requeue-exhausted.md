from_host: endolin-garden2-5bcdff64
from: reaper:endolin-garden2-5bcdff64
sent_at: 2026-07-23T00:33:10Z
poison_base: endojs-endo-but-for-bots-pr824-build
poison_signature: requeue-exhausted
notice_count: 1
first_seen: 2026-07-23T00:33:10Z
last_seen: 2026-07-23T00:33:10Z
---
POISON job PARKED in jobs/plan/ (held, gate=go-ahead) after 5 requeue cycles on endolin-garden2-5bcdff64.
Its handler appears to fail every time; the reaper stopped requeueing it.
The work is preserved at jobs/plan/endojs-endo-but-for-bots-pr824-build; it stays HELD until a human promotes it
(promote-plan.sh endojs-endo-but-for-bots-pr824-build) or removes it, so nothing is lost.
Original job base: endojs-endo-but-for-bots-pr824-build

--- original job body ---
# Build @endo/sha256 from the approved platform-neutral hash design

Repository: endojs/endo-but-for-bots
Merged design PR: https://github.com/endojs/endo-but-for-bots/pull/824
Dependent XS-to-Rust PR: https://github.com/endojs/endo-but-for-bots/pull/600

Wear the builder role. Implement the approved designs/platform-neutral-hash.md now merged into llm: add the platform-neutral @endo/sha256 package and the prescribed Node, browser, and XS conditional implementations, host-function contract, tests, documentation, and the scoped blobref migration. Treat unblocking the XS daemon bundle and PR #600 as a required acceptance criterion. Build against current llm, open a DRAFT implementation PR, run proportionate repository verification, and carry this mergeable-feature build through the automatic gauntlet (clean, panel, fix loop, un-draft). Report the implementation PR URL, verification evidence, and the exact follow-up PR #600 needs once this implementation is merged.
