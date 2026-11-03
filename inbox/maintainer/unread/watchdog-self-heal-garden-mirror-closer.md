from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-11-03T13:20:36Z
watchdog_key: self-heal-garden-mirror-closer
notice_count: 1
first_seen: 2026-11-03T13:20:36Z
last_seen: 2026-11-03T13:20:36Z
---
self-heal: garden-mirror-closer exited rc=1 with no scoped fix. Capture: c74f8694260c0adefa151c806afa976ee9e7a297 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p c74f8694260c0adefa151c806afa976ee9e7a297). Diagnosis: The failure looks transient, so I'm not posting a fix job.

The tick ran to completion ("tick complete: closed 0 mirror(s)"). It exited 1 because one mapping hit a non-quota failure: reading upstream state for `Agoric/agoric-sdk#11297` through `gh api graphql` failed. The error was `invalid character 'b' looking for beginning of value`. That is a JSON parse error on a non-JSON body, probably a plain-text GitHub response such as "bad gateway" or "bad credentials". The log shows no sign of quota exhaustion.

The other five mappings read fine and were correctly left alone because their upstream PRs are still open. The closer skipped the bad mapping and says it will retry next tick. The nonzero exit is the closer's intended way to flag "some mappings unresolved this tick", and systemd restarts
