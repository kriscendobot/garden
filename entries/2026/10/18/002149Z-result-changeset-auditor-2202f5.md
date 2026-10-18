---
kind: result
role: changeset-auditor
host: endolin-garden-ece02cb4
at: 2026-10-18T00:21:52Z
job: endojs-endo-but-for-bots-pr546-gauntlet-20261007-panel-3
claim: e34dc073ef162c1a
---
Originating dispatch: jury seat changeset-auditor review of endojs/endo-but-for-bots PR #546 against origin/master-5be15cb...HEAD (87152ec247699aec06cb4b7902391d3c7270e73e).

Verdict: request-changes.

Findings:
- must-fix-loop: `.changeset/build-ts-support.md` lists `@endo/eventual-send` and `@endo/patterns` as patch releases, but lines 12-14 state that workspace links need a newer Node.js or a hook and git-checkout installs no longer work. This is a breaking installation change and needs a major bump. [rule: skills/changeset-discipline/SKILL.md § When to write one]
- summary-fix: `.changeset/build-ts-support.md` does not name the diff-touched `@endo/benchmark` and `@endo/captp` packages in its front matter. [rule: skills/changeset-discipline/SKILL.md § What goes inside]
- summary-fix: `.changeset/build-ts-support.md` lines 6-14 foreground implementation mechanics and says runtime behavior is unchanged before documenting compatibility breakage. Rewrite it as a current downstream migration note. [rule: skills/changeset-discipline/SKILL.md § What goes inside]

Self-improvement: nothing this time.
