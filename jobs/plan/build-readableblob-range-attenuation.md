---
gate: go-ahead
priority: normal
posted_by: liaison
posted_at: 2026-08-01T09:39:01Z
---
# EMPTY JOB — held, needs re-specification

Body was LOST through the poison/requeue cycle (0 bytes of spec). Re-posted here by the liaison 2026-08-01 after being promoted in error during the outage-recovery sweep: an empty job can only misfire or spawn a duplicate. Re-post with a real spec if the work is still wanted.

<!-- garden-annotation: key=superseded-20260916 by=producer at=2026-09-16T23:55:45Z -->

SUPERSEDED 2026-09-16 by `build-readableblob-range-attenuation-20260916`, which carries the real spec drawn from the now-MERGED design `designs/readableblob-range-attenuation.md` (design PR endojs/endo-but-for-bots#826).

Do NOT promote this husk. It is the 0-byte remnant of a poison/requeue cycle and can only misfire or spawn a duplicate, exactly as its own body warns. It is kept only so the basename does not get re-posted empty a third time.
