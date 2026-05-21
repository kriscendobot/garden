---
ts: 2026-05-21T06:27:01Z
kind: result
role: boatman
repo: endojs/endo
project: endo
refs:
  - entries/2026/05/21/062106Z-dispatch-liaison-f8fc9c.md
---

Ferried `endojs/endo-but-for-bots#68` (Compartment availability and OOM
limits docs) upstream as a new non-draft PR on `endojs/endo`.

- Upstream PR: <https://github.com/endojs/endo/pull/3275>
- Upstream PR number: 3275 (non-draft, OPEN).
- Upstream branch: `kriskowal-compartment-oom-docs-2742` (first-push via
  `git push origin HEAD:refs/heads/kriskowal-compartment-oom-docs-2742`).
- Upstream head SHA: `4d8ed6be74c861472a85df3f38af7081f1d6689c`.
- Base: `master` at `bf951df346cfcf605a6709e6a5479f2fdd526113`.
- Closing keyword: `Closes: #2742` in the PR body; `Fixes #2742` in the
  commit message.

Source-side: cherry-picked 4 of the 5 commits on
`endojs/endo-but-for-bots@design/issue-2742-compartment-limits-doc`
(source head `838d18ff9bae5bd6d16032efb8f0c575e079ef68`) with
`--no-commit` into a single squashed commit, skipping the off-topic
`cb8d6286` AGENTS.md em-dash rule (which is unrelated to issue #2742;
a future ferry can carry it).

Picked: `8a1fc626`, `59957425`, `f299f8e4`, `838d18ff`.
Skipped: `cb8d6286` (AGENTS.md).

Tree-identity verification (with AGENTS.md exclusion):

- `git diff origin/master..HEAD --name-only` lists exactly
  `docs/lockdown.md` and `packages/ses/README.md`.
- `git show 838d18ff:docs/lockdown.md` is byte-identical to
  `git show HEAD:docs/lockdown.md`.
- `git show 838d18ff:packages/ses/README.md` is byte-identical to
  `git show HEAD:packages/ses/README.md`.
- `git show HEAD:AGENTS.md` is byte-identical to
  `git show origin/master:AGENTS.md` (commit 3 correctly excluded).

Attribution and trailer discipline:

- `git log origin/master..HEAD --pretty=fuller` shows one commit, both
  author and committer `Kris Kowal <kriskowal@kriskowal.com>`.
- `git interpret-trailers --parse` on the commit message is empty: no
  `Co-Authored-By:`, no `Generated with [Claude Code]` line, no
  Kriscendo Bot residue. Particularly important here because the carried
  content from `f299f8e4` was originally authored by Kriscendo Bot; the
  squash rewrites attribution to Kris Kowal and drops the bot trailer.
- The `(#68)` source-branch suffix on commit 5's subject was subsumed
  by the squash. The "address review" framing from commit 2 was
  dropped. The new subject is verbatim from commit 1:
  `docs(ses): document Compartment availability and OOM limits (#2742)`.

PR body uses the endo PR template section headings verbatim
(Description, Security, Scaling, Documentation, Testing, Compatibility,
Upgrade Considerations). Behavior over diff. No checklists. No file
callouts beyond the load-bearing `docs/lockdown.md` (Limitations
section) and `packages/ses/README.md` (Compartment cross-link). No
methodology leak. No reference to the source PR, the
`endo-but-for-bots` fork, or any garden artifact.

Identity discipline: no direct comments posted on the new upstream PR.
The only cross-link comment is on the source-side PR
`endojs/endo-but-for-bots#68`
(<https://github.com/endojs/endo-but-for-bots/pull/68#issuecomment-4505381907>),
naming the upstream URL, the head SHA, the 4-of-5 squash with the
explicit `cb8d6286` AGENTS.md exclusion, and the `Fixes #2742` addition.

Self-improvement: tree-identity verification when the squash is
relative to a different base than the source's base (here, source was
based on a months-older `master`) cannot be a single
`git diff source HEAD -- . ':!excluded'` because that pulls in every
unrelated change between the two bases. The reliable form is a
per-file `git show source:path` vs `git show HEAD:path` byte
comparison on exactly the files the squash touches, plus a check that
the excluded file's HEAD content equals the base's. Worth lifting into
a `pr-handoff` skill the next time a boatman ferries with exclusion.
