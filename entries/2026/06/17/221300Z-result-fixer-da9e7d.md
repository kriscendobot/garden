---
ts: 2026-06-17T22:13:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/213200Z-dispatch-fixer-da9e7d.md
  - entries/2026/06/17/215200Z-result-fixer-da9e7d.md
---

Follow-up to the earlier result. After the Copilot-review push
(62b5eefcb), the CI lint run on the new SHA failed at the shellcheck
step. Root cause: the `actual/master` → `llm` merge `f9ff85c` landed on
the base branch at 2026-06-17T21:31Z (between the two CI runs for this
PR), bringing the new shellcheck gate (`scripts/shellcheck.sh`,
`yarn lint:sh`, and the workflow step that depends on it). The PR's
merged-CI state therefore exposes preexisting `-S warning` shellcheck
findings the gate did not exist to catch before.

Resolution: a single `chore(lint)` commit (73c22d89c) addressing every
finding under `git ls-files -z '*.sh' | xargs -0 shellcheck -S warning`.
The fixes are mechanical:

- Missing shebangs (`SC2148`, hard errors) on four scripts.
- Two unchecked `cd` (`SC2164`) in `*-audit-fix.sh`.
- Four dynamic `source` (`SC1090`) on env-file loads; split
  `set -a; source; set +a` so the directive lands on the source line.
- Find/xargs warnings (`SC2044`, `SC2038`) with scoped directives
  explaining why the pattern is safe in context.
- One empty-string assignment (`SC1007`).
- Three unused-variable patterns (`SC2034`) consumed externally.

The full `shellcheck -S warning` pass is now clean (exit 0). None of
the touched scripts is iroh-related or was modified by this PR; the
gate is new and the PR's merge state inherited the obligation.

Pre/post head SHAs: f24c54713 → 62b5eefcb (Copilot fixes) → 73c22d89c
(lint fixes).

Updated PR comment trail:
- Inline replies to Copilot: https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3431671802, https://github.com/endojs/endo-but-for-bots/pull/452#discussion_r3431671999
- Teardown answer: https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735846280
- Initial top-level summary: https://github.com/endojs/endo-but-for-bots/pull/452#issuecomment-4735868204
- Lint follow-up: to be posted with this entry.

Recommended next stage: `next: cleaner` (gamut stage 1) once the
maintainer is satisfied with the teardown answer. The lint gate should
now pass on the next CI run (73c22d89c head).

Self-improvement: nothing this time.
