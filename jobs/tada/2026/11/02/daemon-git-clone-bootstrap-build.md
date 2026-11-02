I didn't build anything or open a PR, because this job would duplicate draft #1538. That PR already implements `provideGitClone`, so a second one would compete with it. I changed no code and didn't touch #1538, and I only read its code and test titles; I didn't run the tests.

**Why the job is stale:** the foreman posted it with three claims that don't hold.
- **"Landed" design:** `designs/daemon-git-clone.md` isn't on `llm`; it exists only in draft #709, which is still open.
- **Design PR:** the job base it names, `fu-design-daemon-git-clone-provide-git-clone-bootstrap-1`, is the marker on #1538, which is the build PR rather than a design PR.
- **Roadmap position:** `designs/daemon-git-next-steps.md` on `llm` has no § Open Work section and no "third item". It says a standalone clone design isn't a prerequisite. The earlier `daemon-git-next-steps-first-item-build` job was also a no-op, so no "already-built first item" exists either.

**How #1538 compares with what this job asks for:**

| Item | State |
|---|---|
| `provideGitClone(destMount, petName, options)` with `origin` policy, fetch-only by default | In #1538 |
| Endpoint policy and sealed credential | In #1538, with a test that a credential rotation aborts the clone; the seam landed in #538 |
| Clearing the mount on failure, with retry | In #1538, with tests including failure after `formulateGit` and cloned symlinks |
| Migrating callers (floot, daemon tests) | In #1538 |
| Commit identity boundary | Landed in #706; #1538 keeps the `identity` option and covers the clone path |
| Mount creation | Deliberately left out: #709 Design Decision 2 makes the mount an input |

- **Design tests:** #1538 has a test for each of the five #709 calls for, with one adapted (see below).
- **State of #1538:** it's a draft at head `f00001ed01` and GitHub reports it mergeable. CI shows 17 passing, 18 skipped and no failures. Its gauntlet is in progress, and `endojs-endo-but-for-bots-pr1538-gauntlet-20261102-panel-6` is waiting in `todo/`.
- **Known departure from #709:** #1538 rejects `origin.petName`, and callers name a remote with `provideGitRemote` instead. The restart test was adapted to match, and the PR body records the change.

**Follow-ups:**
1. **Sibling design job:** `daemon-git-clone-bootstrap-design` is still unclaimed in `todo/` and would redo #709. I recommend withdrawing it; I left it alone because it's outside this job.
2. **Draft #709:** the maintainer needs to decide whether to reconcile it with #1538 or close it. It still specifies `origin.petName`, and #1538 already records the design in `designs/daemon-git-remotes.md`.
3. **Foreman:** it's minting jobs from a roadmap section that isn't on `llm`, so it should check `llm` and search PRs by design slug before posting.

I cite PRs as bare numbers here so the completion machinery doesn't treat #1538 as this job's deliverable and stage a second gauntlet.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/daemon-git-clone-bootstrap-build.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (498549 cached reads)
- Output: 9699 tokens
- Cost: $0.9533538
- Wall-clock: 442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
