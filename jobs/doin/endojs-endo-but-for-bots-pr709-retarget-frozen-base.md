---
role: gardener
tier: mentor
dispatch: automatic
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
---
Relay for design job `design-daemon-git-clone-provide-git-clone-bootstrap`. The kriscendobot PAT on oros-studio-garden-ce242c49 gets 403 on `updatePullRequest` for endojs, so run this on endolin.

Task, for https://github.com/endojs/endo-but-for-bots/pull/709 (draft design PR, head `design/daemon-git-clone` at `fa01c112f2c55301820ddfabdcd8dd203a7cafdd`, already pushed):

1. Guard: confirm `gh pr view 709 -R endojs/endo-but-for-bots --json headRefOid` is `fa01c112f2c55301820ddfabdcd8dd203a7cafdd` (or a descendant of it). If it is not, stop and report.
2. Confirm the frozen base `llm-54d3d2a` exists on endojs/endo-but-for-bots (`git ls-remote` gives `54d3d2a682e7b17fc06beadc52370d3e41283280`). It has already been pushed. Do not create or move it.
3. Write the BODY below (between the markers, exclusive) to a temp file. Then run:
   `gh pr edit 709 -R endojs/endo-but-for-bots --base llm-54d3d2a --title "design(daemon): daemon-git-clone bootstrap and commit-identity capability shape" --body-file <file>`
4. Verify with `gh pr view 709 --json baseRefName,isDraft,body,files` that the base is `llm-54d3d2a`, the PR is still a draft, the body contains `<!-- garden-job: design-daemon-git-clone-provide-git-clone-bootstrap -->`, and the files are exactly `designs/README.md`, `designs/daemon-git-clone.md`, `designs/daemon-git-next-steps.md` and `designs/daemon-git-remotes.md`.
5. Leave the PR in draft. Do not push, review, or hand-post a gauntlet.

----- BODY -----
<!-- garden-job: design-daemon-git-clone-provide-git-clone-bootstrap -->

## Summary

Adds **`designs/daemon-git-clone.md`** (Proposed), the bootstrap design that `daemon-git-remotes` § Repository Bootstrap and `clone` and `daemon-git-next-steps` § Reconciliation deltas deferred to. It specifies `provideGitClone(...)` repository bootstrap and the commit-author/identity boundary as a capability shape.

This replaces the 2026-07-12 retrospective draft on this branch (prior head `5724cc6e23`). That draft was written before #706 merged and was against floating `llm`. This version is rebased onto the frozen `llm-54d3d2a`, and it addresses the 2026-07-17 design-panel findings on that head.

## What the design specifies

- **Record:** the shipped seam (#538: `gitClone`, `makeGitRemoteEndpoint`, `makeGitCloner`, `EndoHost.provideGitClone`) and the shipped formula-owned `identity` option (#706).
- **Revision**, closing the gaps the panel and the first in-tree caller (`packages/floot/src/system-prompt.js`, which clones, discards the result, and re-derives `Git` + `origin`) expose:
  - signature `provideGitClone(destMount, petName, options)`, the same `(subject, petName, options)` order as the other `provide*` methods, with names bound only after the whole composition succeeds;
  - an `origin` record that takes `provideGitRemote`'s policy fields and **defaults to fetch-only**, so the host opts into the Agent MVP Profile instead of getting the hardcoded fetch+push over `refs/heads/*`;
  - **discard owned by the host method**: on failure the destination is emptied, and unnamed formulas are left to formula GC, so the caller can retry into the same mount;
  - the **commit-identity boundary as a capability shape**: the `Git` is the pen. Identity is construction-time formula data that only the `Git` holder can use. It is separate from the credential, never used to decide whether an action is allowed, and changed only by minting a new `Git`. Rejected alternatives: `setIdentity()`, credential-derived identity, and a separate `GitIdentity` capability.
- **Ownership map**, phased build (one builder job), test plan (including the untested credential-rotation abort the skeptic flagged).
- **Open questions:** a sealed commit-signing capability for verifiable attribution; a `depth` / `singleBranch` bound on the clone.

## Cross-links

- `daemon-git-remotes`: § Repository Bootstrap landed note and the resolved spike bullet now point here.
- `daemon-git-next-steps`: landed-substrate bullet, the #709 sequencing bullet (resolved), dependencies row.
- `designs/README.md`: summary-table row, inventory row, dependency-graph node + edges, totals note.

Mermaid fences parse (parse-only check). The cliché and orthography greps are clean.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-23T20:25:07Z
