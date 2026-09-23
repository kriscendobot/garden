---
ts: 2026-05-14T02:18:46Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

PR #129 title and description redrafted per the pr-formation skill, in response to kriskowal's CHANGES_REQUESTED review at 2026-05-14T02:16:38Z ("Please refresh the title and description consistent with standing instructions"). No code changes.

New title: `feat(daemon,cli): formula-type introspection and worker-tenants lookup`.

Body now follows the upstream PULL_REQUEST_TEMPLATE.md sections (Description, Security, Scaling, Documentation, Testing, Compatibility, Upgrade). The previous body's `## Summary` bullet list of verbs and `## Commits` list have been replaced by a single Description paragraph that describes the daemon-side host API additions (`identifyType`, `listWithTypes`, `inspect`, `listWorkerTenants`) and the CLI surfaces that consume them (`endo list --types`, `endo inspect <name>`), framed as behavior rather than diff. The re-open-under-bot history is retained as a one-line `Refs: #39` lead-in. No checklists, no per-file callouts.

Top-level neutral summary comment posted at https://github.com/endojs/endo-but-for-bots/pull/129#issuecomment-4446857039 noting that the refresh is per the standing PR-formation discipline and that no code changes accompany this update.

Per the dispatch brief, this is the cycle-9 PR-#128 precedent applied to #129: redraft only, no re-request of review, no inline CR-item handling.

Self-improvement: nothing this time.
