from_host: endolin-garden-ece02cb4
from: watchdog:self-heal-claude
sent_at: 2026-08-14T17:38:30Z
watchdog_key: self-heal-garden-regenerate-sections-index
notice_count: 1
first_seen: 2026-08-14T17:38:30Z
last_seen: 2026-08-14T17:38:30Z
---
self-heal: garden-regenerate-sections-index exited rc=1 with no scoped fix. Capture: ec3ec6be53c24e71078e2974bf013e040b2715c1 (git -C /home/kris/garden/.garden-state/self-heal/journal cat-file -p ec3ec6be53c24e71078e2974bf013e040b2715c1). Diagnosis: ## Diagnosis

The failure blob is only two real lines: `land-journal-edit.sh` refused to land the regenerated `library/sections/README.md` because the journal's current tip blob for that file no longer matched the `--base-blob` the script read before regenerating — i.e. some other writer (a scholar/librarian edit, or another producer touching the library tree) landed a change to that file in the window between this run's tip-sync and its land attempt. The "printf: write error: Broken pipe" line is just a side effect of the same event: `land-journal-edit.sh` exited as soon as it detected the conflict, closing its stdin before `printf` finished writing the piped regenerated body.

This is exactly the concurrent-edit race `land-journal-edit.sh`'s CAS discipline is designed to catch and refu
