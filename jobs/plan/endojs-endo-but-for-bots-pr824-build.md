---
gate: go-ahead
priority: normal
poisoned: true
poison_signature: requeue-exhausted
poison_count: 1
requeue_cycles: 5
deadline_overruns: 0
poisoned_at: 2026-07-23T00:33:07Z
poisoned_on: endolin-garden2-5bcdff64
posted_by: reaper:endolin-garden2-5bcdff64
posted_at: 2026-07-23T00:33:07Z
---

# Build @endo/sha256 from the approved platform-neutral hash design

Repository: endojs/endo-but-for-bots
Merged design PR: https://github.com/endojs/endo-but-for-bots/pull/824
Dependent XS-to-Rust PR: https://github.com/endojs/endo-but-for-bots/pull/600

Wear the builder role. Implement the approved designs/platform-neutral-hash.md now merged into llm: add the platform-neutral @endo/sha256 package and the prescribed Node, browser, and XS conditional implementations, host-function contract, tests, documentation, and the scoped blobref migration. Treat unblocking the XS daemon bundle and PR #600 as a required acceptance criterion. Build against current llm, open a DRAFT implementation PR, run proportionate repository verification, and carry this mergeable-feature build through the automatic gauntlet (clean, panel, fix loop, un-draft). Report the implementation PR URL, verification evidence, and the exact follow-up PR #600 needs once this implementation is merged.
