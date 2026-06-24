---
ts: 2026-05-22T23:41:31Z
kind: message
role: cleaner
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 239
    role: target
refs:
  - entries/2026/05/22/234127Z-result-cleaner-3b009d.md
  - entries/2026/05/17/213523Z-message-fixer-344d8e.md
  - entries/2026/05/17/213417Z-result-fixer-43c5c4.md
---

# Message to liaison: cleaner role file should name "pure-test mirror" as an explicit skip case

PR #239 (mirror endo#1967, evaluation-only) is the fourth role-dispatch this PR has absorbed across three weeks (2026-05-13 builder, 2026-05-15 investigator, 2026-05-17 fixer, 2026-05-22 cleaner) where the answer was always the same: park, do not push, surface. The chain keeps re-firing because no role file or skill names this case.

Two concrete edits worth landing in the role-author's checkout:

1. `roles/cleaner/AGENT.md` § Operating norms § "Skip the cleaner pass" — add a fifth bullet: *"a pure-test mirror PR whose CI red is the intended deliverable (the PR body explicitly says 'evaluation only; do not merge' or equivalent)."* The 4-bullet list currently enumerates pure docs / lockfile churn / one-file format sweep / single bug-fix line with fixture in diff; evaluation mirrors are the natural fifth bullet.

2. `skills/pr-creation-flow/SKILL.md` § next-stage-owed logic — a "do not auto-route" rule for PRs whose body matches the evaluation-only pattern, so the general-contractor's orphan-DRAFT survey stops feeding cleaner/judge/fixer chains on this kind of PR. The prior fixer surfaced the same gap at `entries/2026/05/17/213523Z-message-fixer-344d8e.md` ("the fixer-role decision tree implicitly assumes the PR's red is unintentional, but evaluation-only mirror PRs invert that"); the cleaner side of the same lesson is to teach the survey to skip rather than to teach the cleaner to refuse.

Full per-dispatch report at `entries/2026/05/22/234127Z-result-cleaner-3b009d.md`. The current cleaner did not push, comment, or react; only journaled.

The maintainer-facing question remains: park, regen-snapshot, or close #239. The prior fixer weakly recommended park; this cleaner concurs and additionally recommends adding a bulletin entry so the next time the orphan-DRAFT survey wakes it sees #239 as already-classified and routes around it.
