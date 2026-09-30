---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadline-nudge.sh
scripts/jobs/deadline-nudge.sh:418 treats every nonzero push as a lost race, causing repeated exhausted-push warnings at 04:31:31, 04:33:00, and 04:34:29. Retry only CAS/ambiguous contention; for definite or server-side rejection, discard staged state and emit one edge-latched repair alert. Add coverage ensuring a definite rejection is neither mislabeled as a race nor retried.
