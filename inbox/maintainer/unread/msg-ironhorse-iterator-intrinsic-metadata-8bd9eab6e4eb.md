from_host: endolin-garden2-5bcdff64
from: gardener:ironhorse-iterator-intrinsic-metadata
reply_to: ironhorse-iterator-intrinsic-metadata
msg_key: msg-ironhorse-iterator-intrinsic-metadata-8bd9eab6e4eb
notice_count: 1
first_seen: 2026-09-17T00:32:49Z
last_seen: 2026-09-17T00:32:55Z
sent_at: 2026-09-17T00:32:55Z
---
Job ironhorse-iterator-intrinsic-metadata (endojs/endo-but-for-bots): engine fix
landed on branch llm-fix-iterator-intrinsic-metadata (commit acb67ae347, pushed).
Draft PR open is pending a transient shared-bot GraphQL rate limit — will retry
ensure-pr.sh shortly.

Fixed two real Ironhorse intrinsic-shape bugs:
 1. Array.prototype had no [Symbol.iterator] ([][Symbol.iterator]() threw
    TypeError) — aliased to Array.prototype.values.
 2. No %AsyncIteratorPrototype% — interposed it between %AsyncGeneratorPrototype%
    and %Object.prototype% with the [Symbol.asyncIterator] identity method.

Result: the two job probes (IteratorPrototype, AsyncIteratorPrototype) — plus,
as a side effect of bug 1, MapIteratorPrototype and SetIteratorPrototype — now
agree with XS and move failed->passed in every scenario the Ironhorse agent
executes (sloppy, strict). cargo test -p ironhorse-vm: 106 passed.

Scope reality vs the "Done when": the "48 recorded failures" cannot all be
removed. Only the ~8 bare-Ironhorse sloppy/strict entries were removable. The
rest are the corpus-wide structural:scenario-not-supported failures under
SES/lockdown/module/compartment scenarios — NO Ironhorse test passes there yet
(bare agent has no `lockdown`; the sesIronhorse SES-shim agent aborts inside the
548KB shim; modules/compartments are unported). Those are a separate engine
effort, not an iterator-metadata divergence. "Pass under Ironhorse+SES" is
likewise blocked by that shim gap. The actual metadata divergence this job names
is fully fixed wherever the engine can execute the probe.

test:xs: my baseline changes produce zero divergence; the only local red is a
pre-existing xst-version flip on xs/module globalThis/defaults.js (left untouched
to match CI).
