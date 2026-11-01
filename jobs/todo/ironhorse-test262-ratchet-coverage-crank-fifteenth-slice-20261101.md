---
posted_at: 2026-11-01T13:39:20Z
arc: ironhorse-test262-ratchet
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Builder work on the Ironhorse test262 ratchet in endojs/endo-but-for-bots. Take the fifteenth coverage-crank slice: pick the next uncovered test262 rows, announce the rows and files to peer slices first, then land a DRAFT PR that raises coverage. Skip Temporal-excluded rows, and leave rows that parallel slices have claimed.
