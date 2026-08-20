---
gate: blocked
blocked_on: https://github.com/endojs/endo-but-for-bots/pull/1040
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-08-20T21:41:06Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add `ironhorse` and `ironhorse+ses` to the coverage matrix after https://github.com/endojs/endo-but-for-bots/pull/1040 merges.

Use the hardened262 harness delivered by that pull request to measure both modes, preserve comparable coverage reporting, and make the matrix suitable for ratcheting Iron Horse parity and coverage. Look for opportunities to consolidate overlapping test suites while retaining mode-specific results.

Run the relevant local checks, open the implementation pull request through the garden PR workflow, and report the before/after matrix behavior.
