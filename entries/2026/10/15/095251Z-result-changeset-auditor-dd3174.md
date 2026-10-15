---
kind: result
role: changeset-auditor
host: endolin-garden-ece02cb4
at: 2026-10-15T09:52:54Z
job: endojs-endo-but-for-bots-pr1392-gauntlet-panel-2
claim: 2552efbd2247575b
---
PR #1392 changeset-auditor result, originating from the requested review of `origin/build/sturdyref-ses-accommodation-282679d...HEAD` in `project-wt-endojs--9975551c078e-73e3c927`.

Verdict: request-changes.

- must-fix-loop: `.changeset/pass-style-parcel.md` assigns `@endo/pass-style` a minor bump although its own body correctly says the exported `PassStyle` union adds `'parcel'` and exhaustive consumer switches and `Record<PassStyle, ...>` tables no longer type-check. This is a breaking public type-surface change and needs a major bump. [rule: skills/changeset-discipline/SKILL.md § When to write one]
- summary-fix: the PR has three changeset files for one Parcel pass-style release-cycle change. Consolidate their front matter and release notes into one bundled changeset. [rule: skills/changeset-discipline/SKILL.md § What goes inside]

Self-improvement: nothing this time.
