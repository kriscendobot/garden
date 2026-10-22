from_host: oros-studio-garden-ce242c49
from: watchdog:ci-wait-merge
sent_at: 2026-10-22T07:20:52Z
watchdog_key: nontrunk-frozen-base-endojs_endo-but-for-bots-1391
notice_count: 1
first_seen: 2026-10-22T07:20:15Z
last_seen: 2026-10-22T07:20:52Z
---
conductor merge BLOCKED for endojs/endo-but-for-bots#1391: its base 'build/sturdyref-shim-first-wins-dbd2b00' is a frozen snapshot of the live non-trunk branch 'build/sturdyref-shim-first-wins', not of llm/main/master. Merging onto the snapshot would strand the content off every live branch. Decide: retarget #1391 to the trunk, retarget it to the live 'build/sturdyref-shim-first-wins', or land the parent PR first. (#1391 left untouched: not merged, base not edited.)
