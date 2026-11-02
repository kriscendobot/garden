---
posted_at: 2026-11-02T07:36:01Z
role: gardener
requires: host=endolin-garden-ece02cb4
tier: mentor
dispatch: automatic
fallback-tier: minion
---

# endojs/endo-but-for-bots #1538: replace the PR body

The bot PAT on oros-studio cannot update PRs on endojs (403), so this runs on endolin. Replace the body of https://github.com/endojs/endo-but-for-bots/pull/1538 with the text between the BODY markers, verbatim, using `gh pr edit 1538 -R endojs/endo-but-for-bots --body-file <file>`. Change nothing else. Run `gh pr view 1538 -R endojs/endo-but-for-bots --json body` and confirm the new body includes `This departs from the #709 draft` and still ends with the `garden-job` marker.

----- BODY -----
## Description

Changes `@endo/daemon`, `@endo/git`, `@endo/sandbox`, and `@endo/floot`.

- `@endo/daemon`: the host-mediated clone bootstrap; see `.changeset/daemon-git-clone-bootstrap.md` and `designs/daemon-git-remotes.md` § Repository Bootstrap and `clone`.
- `@endo/git`: remote operation termination; see `.changeset/git-sigkill-escalation.md`.
- `@endo/sandbox`: bwrap cancellation; see `.changeset/sandbox-bwrap-cancel-starting.md`.
- `@endo/floot`: the system prompt uses the new call shape.

The git and sandbox fixes ride with the clone because its credential-rotation test cannot settle without them: an aborted clone hung on a helper that ignored `SIGTERM`, and a cancelled bwrap slice left its workload running.

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

XS `removeDirectory` has two tests. A shim test under Node with mocked host globals covers the walk's order, and a `content-store-gc` test covers symlink handling on whichever manager the daemon runs.

The second test does not reach the XS manager today. `yarn test:rust` cannot start any daemon, because the XS manager throws `HTTP content plane requires fetch` at startup (since #792), and no CI job runs the daemon suite under `endor`. With that registration skipped locally, the test passes on `endor` against the real `hostRemove`, and fails against the base branch's `removeDirectory`, which deletes the symlink target's file. Fixing the startup and adding the CI lane are follow-up work.

### Compatibility Considerations

See the changesets; every in-tree caller is migrated. `@endo/sandbox` is private at 0.0.1, so `minor` covers its `DriverProcess.kill` contract change.

### Upgrade Considerations

Existing clone formulas are unaffected.

<!-- garden-job: fu-design-daemon-git-clone-provide-git-clone-bootstrap-1 -->
----- END BODY -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T08:43:10Z
