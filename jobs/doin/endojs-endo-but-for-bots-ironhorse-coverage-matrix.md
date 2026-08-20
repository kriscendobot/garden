---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=blocked priority=normal at=2026-08-20T21:56:05Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add `ironhorse` and `ironhorse+ses` to the coverage matrix after https://github.com/endojs/endo-but-for-bots/pull/1040 merges.

Use the hardened262 harness delivered by that pull request to measure both modes, preserve comparable coverage reporting, and make the matrix suitable for ratcheting Iron Horse parity and coverage. Look for opportunities to consolidate overlapping test suites while retaining mode-specific results.

Run the relevant local checks, open the implementation pull request through the garden PR workflow, and report the before/after matrix behavior.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-20T21:56:11Z
