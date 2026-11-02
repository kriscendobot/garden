---
gate: orchestrated
orchestrated_by: daemon-git-clone-bootstrap-design-split
handler-timeout: 3600
split-indivisible-reason: 'one atomic PR-body edit on endojs/endo-but-for-bots#709 that only an endolin host can perform; the design commit is already pushed'
split-lineage-root: daemon-git-clone-bootstrap-design
split-lineage-parent: daemon-git-clone-bootstrap-design-split
split-lineage-depth: 1
split-lineage-max-depth: 1
priority: normal
posted_by: producer
posted_at: 2026-11-02T11:46:08Z
---

---
role: designer
arc: minion-town-git-remote
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Finish `daemon-git-clone-bootstrap-design`: publish the refreshed PR description on draft design PR https://github.com/endojs/endo-but-for-bots/pull/709. The bot PAT on oros-studio gets a 403 on `updatePullRequest`, so this job is pinned to endolin.

The design work is done and pushed. Head `d8f2555574bb2c91bedee95d3355e945eb3fc372` on `design/daemon-git-clone` reconciles `designs/daemon-git-clone.md` with the contract in draft PR 1538. Do not redo or rewrite the design, and do not open a second PR for this file.

Steps:

1. Confirm that #709 is open and draft, and that its head still contains `d8f255557`. If the head moved, read the new commits and adjust the description only where they make it false.
2. Write the text between the BEGIN and END lines below to a file, and run `gh pr edit 709 -R endojs/endo-but-for-bots --body-file <file>`. Keep both `garden-job` markers.
3. Read the body back and confirm it starts with those markers and contains `## Open questions for the maintainer`.

Completion report rules:

- Cite `endojs/endo-but-for-bots#709` as the first PR in the report, so the completion machinery stages its design panel at the new head. The last panel reviewed the older head `5724cc6e23`.
- Refer to the implementation PR by bare number only, and only after #709.
- Do not un-draft #709, and do not post a gauntlet by hand.
- Do not name a new implementation job in `## Follow-ups`. PR 1538 is that implementation, and a second one would compete with it.

Tell the maintainer in the report that the open questions on #709 await their ruling. The first asks whether the document should land or the PR should close in favor of `designs/daemon-git-remotes.md`.

----- BEGIN PR BODY -----
<!-- garden-job: design-daemon-git-clone-provide-git-clone-bootstrap -->
<!-- garden-job: daemon-git-clone-bootstrap-design -->

## Summary

Adds **`designs/daemon-git-clone.md`** (Proposed), which specifies `provideGitClone` repository bootstrap and the commit-author/identity boundary as a capability shape. It builds on `daemon-git-remotes` § Repository Bootstrap and `clone`.

The latest commit (2026-11-02) reconciles the draft with the contract in draft #1538, at head `f00001ed01`, which builds this design and departed from it during review.

## What the design specifies

- **Record:** the shipped seam (#538: `gitClone`, `makeGitRemoteEndpoint`, `makeGitCloner`, `EndoHost.provideGitClone`) and the shipped formula-owned `identity` option (#706).
- **Revision:**
  - the signature `provideGitClone(destMount, petName, options)`, with the `Git`'s name stored last;
  - an `origin` policy record that **defaults to fetch-only**. The clone never names the remote, so a caller binds a name with `provideGitRemote` over the returned `git`;
  - an **exclusive destination**: a non-empty mount is refused, the clone goes straight into the mount, and a failure removes every entry under the mount root so that the call can be retried;
  - the **commit-identity boundary as a capability shape**: the `Git` is the pen. Identity is construction-time formula data, separate from the credential, never used to decide whether an action is allowed, and changed only by minting a new `Git`.
- **Ownership map**, phased build (draft #1538), and test plan.

## Open questions for the maintainer

1. Should this document land as the contract, or should this PR close in favor of `daemon-git-remotes` § Repository Bootstrap and `clone`? #1538 writes the same contract there, and `daemon-git-next-steps` says a standalone clone design is not a prerequisite.
2. Should the exclusive destination stand? The liaison proxy ruled for it tentatively on #1538.
3. Should the daemon reclaim a mount left partial by a restart during a clone? Today a retry into that mount is refused.
4. Should verifiable attribution become a sealed commit-signing capability?
5. Should the clone accept a `depth` / `singleBranch` bound?

## Scope notes

- The mount stays an input (Design Decision 2), so the call returns `{ git, remote }` and not `EndoMount` + `Git`. The second request's wording came from a sentence in `daemon-git-remotes`, which this PR corrects.
- That second request, `daemon-git-clone-bootstrap-design`, cites a `daemon-git-next-steps` § Open Work section. That section does not exist on `llm`, so this update extends the existing draft rather than opening a second PR for the same file.

## Cross-links

- `daemon-git-remotes`: § Repository Bootstrap flow 2, the landed note, and the resolved spike bullet. These overlap #1538's edit to the same section, so whichever lands second resolves the conflict.
- `daemon-git-next-steps`: landed-substrate bullet, the #709 sequencing bullet, and the dependencies row.
- `designs/README.md`: summary-table row, inventory row, dependency-graph node and edges, and the totals note.

The mermaid fence parses (parse-only check).

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END PR BODY -----
