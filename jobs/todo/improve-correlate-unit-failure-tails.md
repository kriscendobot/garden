---
posted_at: 2026-11-08T23:21:37Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/mentor.sh
scripts/jobs/mentor.sh:224 supplies only priority-warning records; the 2026-11-08T22:51–22:52Z digest reports five exit-code failures without any child diagnostic.
When that scan finds a failed garden unit, deterministically append one bounded, same-window `journalctl --user -u <unit>` tail per unique unit to the captured digest.
Cap and label those tails so the mentor can diagnose the shared failure without broadening routine progress noise.
