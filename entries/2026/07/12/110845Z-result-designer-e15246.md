---
ts: 2026-07-12T11:08:45Z
kind: result
role: designer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/709
---

Authored the daemon-git-clone design record (job
design-endo-but-for-bots-daemon-git-clone-provide-git-clone-bootstrap-and-commit-identity-boundary).
Draft PR #709 (design/daemon-git-clone -> llm) adds designs/daemon-git-clone.md:
the record of the shipped host-mediated provideGitClone bootstrap (#538; destMount
x sealed GitRemoteEndpoint -> formula-backed Git + origin-pre-bound GitRemote,
with the mount-as-input deviation from the roadmap sketch recorded) and the
formula-owned commit-identity boundary in flight as PR #706. Cross-links repointed
in daemon-git-remotes and daemon-git-next-steps; designs/README.md fully synced
(summary row, M3 row, graph, estimate, totals 145 -> 146). All 4 touched mermaid
fences parse (mermaid.parse via jsdom). Noted in the PR body: #691 and this PR
touch the same README/next-steps lines, so whichever lands second needs a small
re-weave, and #706 landing first needs a one-line Status flip in the record.
