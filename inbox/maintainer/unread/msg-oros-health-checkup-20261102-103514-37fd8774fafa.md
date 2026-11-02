from_host: oros-studio-garden-ce242c49
from: gardener:oros-health-checkup-20261102-103514
reply_to: oros-health-checkup-20261102-103514
msg_key: msg-oros-health-checkup-20261102-103514-37fd8774fafa
notice_count: 1
first_seen: 2026-11-02T11:59:38Z
last_seen: 2026-11-02T12:00:42Z
sent_at: 2026-11-02T12:00:42Z
---
oros health (11:55Z): the shared garden disk on oros-studio is at 60G free (87%), losing about 1.8G/h since 05:15Z. If that rate holds, it fills in about 33 hours, around 2026-11-03 21:00Z. I can't find the cause from inside the container: what I could measure under the garden mount is small, and removing about 20G of files today did not raise free space. That points to the Mac side (for example snapshots or something outside the garden directory), but this is not confirmed. Please check it from the Mac, for example with `tmutil listlocalsnapshots /` and a size scan of the disk. Your 11-01 notice on this is still unread in the inbox.
