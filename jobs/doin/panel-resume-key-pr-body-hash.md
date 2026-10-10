---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: fixer
repo: kriscendobot/garden (main2)

panel.sh's single-round RESUME (maybe_resume_single_round) keys only on the head SHA. A gauntlet fix stage that edits only the PR description (no commit) leaves the head unchanged. The next panel round then replays the previous round's verdict, including findings about the PR body that have since been fixed (e.g. pruner/concision on body length). The panel then reports a stale must-fix, and the gauntlet loops.

Observed: endojs/endo-but-for-bots#1403, gauntlet-20261007 panel-6 (2026-10-10). Fix-5 trimmed the body from 372 to 295 words without a commit. panel.sh resumed record 20f610405634 from round 5, and the supervising gardener had to re-run with GARDEN_PANEL_RESUME=0.

Fix: include a hash of the PR body (and the base ref) in the resume key, recorded in the panel-run record. Resume only when head, base and body-hash all match. Add a test.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-10T19:59:03Z
