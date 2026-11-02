---
posted_at: 2026-11-02T13:01:32Z
role: fixer
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# endojs/endo-but-for-bots: replace the description of PR #1538

https://github.com/endojs/endo-but-for-bots/pull/1538 needs its description replaced. The gauntlet job `endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-6` could not do this because the bot token on oros-studio returns 403 on `updatePullRequest`.

Why: the fix narrowed `DriverProcess.kill` back to `TerminationSignal`, so the current description's Compatibility line about a `DriverProcess.kill` contract change is false. The rest trims what panel-6's pruner flagged and cites the tracked XS follow-up.

Do only this: write the text between the markers to a file and run `gh pr edit 1538 --repo endojs/endo-but-for-bots --body-file <file>`. Do not change code, and do not push. First confirm the current description still starts with "## Description" and carries the `garden-job` marker; if someone has rewritten it since, keep their other changes and apply only the three edited passages (the Description opening, Testing Considerations, Compatibility Considerations).

----- BODY START -----
## Description

Adds the host-mediated clone bootstrap, plus the git and sandbox cancellation fixes its credential-rotation test needs: an aborted clone hung on a helper that ignored `SIGTERM`, and a cancelled bwrap slice left its workload running. See the changesets and `designs/daemon-git-remotes.md` § Repository Bootstrap and `clone`.

This departs from the #709 draft, which has `origin.petName` bind the remote during the clone. The clone binds only the `Git`; a caller names a remote with `provideGitRemote` over the returned `git`.

Refs: https://github.com/endojs/endo-but-for-bots/pull/709

<!-- garden-related-design: 709,1367,988 -->

### Security Considerations

This narrows authority: push is opt-in policy, and `origin` cannot override the endpoint's URL, credential, or transport.

### Scaling Considerations

None.

### Documentation Considerations

None beyond the design and the changesets.

### Testing Considerations

XS `removeDirectory` has two tests. A shim test under Node with mocked host globals covers the walk's order. The `content-store-gc` symlink test reaches the XS manager only under `endor`, which cannot start a daemon today and which no CI lane runs. Job `ebfb-xs-daemon-start-without-fetch` tracks both fixes.

### Compatibility Considerations

See the changesets; every in-tree caller is migrated.

### Upgrade Considerations

Existing clone formulas are unaffected.

<!-- garden-job: fu-design-daemon-git-clone-provide-git-clone-bootstrap-1 -->


----- BODY END -----
