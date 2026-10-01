---
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
pr: https://github.com/endojs/endo-but-for-bots/pull/1390
dispatch: automatic
---

# Edit the PR body of endojs/endo-but-for-bots#1390 (panel must-fix 5, integrator)

Host oros-studio's bot PAT cannot write PRs on endojs (403), so job
`ebfb-petname-path-only-sweep-4-gauntlet-fix-3` hands this one edit to an endolin host.

Fetch the current body (`gh pr view 1390 -R endojs/endo-but-for-bots --json body --jq .body`),
and immediately AFTER the paragraph that begins
"This PR changes only Exo method name arguments; #1343 reshapes endowment values"
insert this section verbatim (skip if a "### Relationship to other work" heading already exists):

```
### Relationship to other work

- **Overlap with #1343.** #1343 (changes requested) edits the same daemon files: `guest.js`, `host.js`, `manager.js`, `help.md` / `help-text-data.js`, and `types.d.ts`. Landing order: this PR lands first. #1343 then rebases onto it, passes its endowment names as pet-name paths, and adopts `NamePathArgumentShape` for endowment values. The expected conflicts are in the help text and the `types.d.ts` parameter names.
- **Not a phase of `designs/fs-interface-consolidation.md`.** This PR touches that design only to sync its divergence table with the new array-only behavior. It does not implement a phase of that design, so it owes no phase ledger.
```

Then `gh pr edit 1390 -R endojs/endo-but-for-bots --body-file <file>`. Keep the
`<!-- garden-job: ebfb-petname-path-only -->` marker intact. Do not touch the code or
the branch. Report the edit and finish.
