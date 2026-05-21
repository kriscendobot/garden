---
ts: 2026-05-21T06:28:34Z
kind: result
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/21/062106Z-dispatch-liaison-f8fc9c.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 68
    role: source
  - repo: endojs/endo
    pr: 3275
    role: target
---

First-time ferry of #68 opened as `endojs/endo#3275` (non-draft, 4-of-5 squash with explicit AGENTS.md exclusion).

- Upstream PR: https://github.com/endojs/endo/pull/3275, non-draft confirmed.
- Branch: `kriskowal-compartment-oom-docs-2742`.
- Head: `4d8ed6be74c861472a85df3f38af7081f1d6689c` — single squashed commit (commits 1, 2, 4, 5 combined; commit 3's `AGENTS.md` edit explicitly excluded as off-topic), author + committer `Kris Kowal <kriskowal@kriskowal.com>`, zero bot trailers (including no residue from commit 4's original Kriscendo Bot identity).
- **Tree-identity check used per-file equality** (`git show source:path` vs `git show HEAD:path`) because the path-restricted `git diff` was also misleading given the base-difference; the boatman flagged this as a refinement to the prior #67 boatman's path-restriction approach. **Worth a row in the gardener brief**: for squash-with-exclusion across bases, per-file content equality is the reliable check.
- Title verbatim from source; body composed per pr-formation with `Closes: #2742` at top.
- Source-side cross-link on #68: [issuecomment-4505381907](https://github.com/endojs/endo-but-for-bots/pull/68#issuecomment-4505381907) — names the 4-of-5 squash, the explicit `cb8d6286` exclusion as off-topic for #2742, and the `Fixes #2742` addition.

The excluded commit `cb8d6286 docs(agents): add prose style rule banning em-dashes` (touching `AGENTS.md`) remains available on the source PR. If you want it ferried separately to upstream endojs/endo, say the word — endojs/endo does have an AGENTS.md file, so a standalone "AGENTS.md em-dash style rule" PR could land there.

Worktree-index will be marked collected after the other parallel boatmen return.

Self-improvement: combined with #67's lesson, the **tree-identity check** for squash-and-amend has now produced two refinements:
1. Path-restricted diff (`-- <paths-touched>`) when source and target share a far-back ancestor.
2. Per-file content equality (`git show`) when the squash explicitly excludes commits.

Both should land in the eventual `skills/pr-handoff/SKILL.md` as the canonical tree-identity-check forms; the original `git diff <source-head> HEAD -- .` only works when source and target are at the same base.
