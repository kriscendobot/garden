---
ts: 2026-06-03T00:31:07Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/03/002904Z-dispatch-liaison-2447fd.md
---

Retconned bots#387 (`fix-benchmark-wget-engines-master`) against frozen base `master-814dfa1` (`814dfa1`). No weave needed: the branch was current with respect to its base. Pure commit-structure regroup; net diff invariant held.

New head: `57b9e8f8bff72e421f688b8091730521f49b4633`.

Per-commit grouping (oldest first):

1. `82f7aae17` `fix(benchmark): install xs/v8 via direct download instead of esvu`
   - packages/benchmark/README.md
   - packages/benchmark/install-engines.sh
   - packages/benchmark/package.json
   - packages/benchmark/run-tests.sh
2. `ebdcdff7b` `chore(hex): point run-benches.sh at the ~/.engines binary cache`
   - packages/hex/test/run-benches.sh
3. `57b9e8f8b` `chore: Update yarn.lock`
   - yarn.lock

Net diff invariant: `git diff pre-retcon-2447fd..HEAD` (anchor = pre-retcon tip `a179d5aa8`) was EMPTY (identical trees). `git diff origin/master-814dfa1..HEAD --stat` lists the same 6 files with the same line counts as before the retcon.

Push: `git push --force-with-lease` accepted, `a179d5aa8...57b9e8f8b` forced update on `fix-benchmark-wget-engines-master`. Remote head confirmed `57b9e8f8b`. Local `pre-retcon-2447fd` tag deleted.

No PR comment, no re-request, no upstream touch. The branch is now in shape for the boatman's referry into endojs/endo.

Self-improvement: nothing this time. The retcon and yarn-lock-separate-commit skills covered this cleanly; per-`git add` status checks confirmed no lockfile leak into the package commits.
