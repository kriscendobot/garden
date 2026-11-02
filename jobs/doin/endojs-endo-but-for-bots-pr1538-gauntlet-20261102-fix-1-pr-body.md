---
posted_at: 2026-11-02T02:08:05Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
requires: host=endolin-garden-ece02cb4
role: gardener
tier: minion
dispatch: automatic

# Relay PR title, body and fix summary to endojs/endo-but-for-bots PR 1538

Host oros-studio cannot write PRs on endojs (403 on updatePullRequest and addComment), so gauntlet fix round 1 relays these writes here. Do only this, then complete:

1. Confirm https://github.com/endojs/endo-but-for-bots/pull/1538 is open and its head contains `a54166c7b6a0c7b6695f2978b8ab209bbb6719aa`.
2. Set the title with `gh pr edit` to the text in the TITLE block, and the body with `--body-file` to the BODY block (without the marker lines).
3. Post the COMMENT block as a PR comment with `gh pr comment --body-file`.

Do not push code or run the panel.

----- TITLE -----
feat(daemon): provideGitClone(destMount, petName, { origin }) with discard on failure; fix git and bwrap cancellation
----- END TITLE -----

----- BODY -----
## Description

`EndoHost.provideGitClone` becomes `(destMount, petName, { endpoint, identity, origin })` and returns `{ git, remote }`, implementing the host-mediated clone bootstrap from the `daemon-git-remotes` design. Both pet names are stored only after the composition succeeds, and the `origin` remote defaults to fetch-only. Floot's bootstrap uses the new call shape.

The clone is built in daemon-private staging beside the destination mount and published without replacing concurrent entries; `designs/daemon-git-remotes.md` § Repository Bootstrap and `clone` gives the contract and why simpler shapes do not hold it.

The credential-rotation test exposed two cancellation liveness bugs, fixed here too: native Git operations now run in a process group and escalate to `SIGKILL`, and bwrap terminal kills also kill the sandbox init that bwrap reports on `--info-fd`, with a bounded wait so a missing report never blocks the kill.

Refs: https://github.com/endojs/endo-but-for-bots/pull/709

<!-- garden-related-design: 709,1367,988 -->

### Security Considerations

This narrows authority: push is opt-in policy, and `origin` cannot override the endpoint's URL, credential, or transport. Clone cleanup removes only entries whose recorded identity (device, inode, and birth time) still matches, so a concurrent mount holder's content is kept.

### Scaling Considerations

None.

### Documentation Considerations

The design's landed contract and the three changesets describe the change.

### Testing Considerations

Daemon tests cover cloning, policy guards, retry after failure, stale, pending, truncated, and swapped staging records, concurrent replacement of entries and pet names, and no-replace publication. Git and sandbox tests cover process-group reaping on timeout, overflow, and credential rotation, and bwrap kills past a missing, oversized, or implausible `--info-fd` report. The XS file-power test runs under Node with shimmed host globals, because `test:xs` runs under `xst`, which lacks the `hostStat` and `hostRemove` globals that only the Rust `endor` host provides, and no CI job runs the daemon suite under `endor`. The residual risk is that `removeDirectory`, which XS mount removal also uses, is tested for its walk but never run against the real `hostRemove`; by inspection, `host_remove` in `rust/endo/xsnap/src/powers/fs.rs` reads `symlink_metadata` and unlinks a symbolic link. Cloning is refused on XS before anything is cloned.

### Compatibility Considerations

`provideGitClone` changes shape, but the old form never shipped in a release, so the `@endo/daemon` changeset is a minor note. Every in-tree caller is migrated. Alternate `FilePowers` implementations must add the new members the changeset names.

### Upgrade Considerations

Existing clone formulas are unaffected.

<!-- garden-job: fu-design-daemon-git-clone-provide-git-clone-bootstrap-1 -->
----- END BODY -----

----- COMMENT -----
**Gauntlet fix round 1 (2026-11-02 panel)** · head `a54166c7b6` · next: panel round 2 after CI

Commits: `6a504a4c3` (code and tests), `a54166c7b` (design and changesets).

**Addressed**

- **Record forgotten after a failed removal** (assessor 1): `discardMountEntries` now forgets a staging record only when the removal succeeded, the entry was missing, or the identity no longer matches. The holding directory follows the same rule. It loses its record only when it may hold another holder's object, because a kept record would let a later call remove that object. This now includes the case where the held entry's identity cannot be read. A new test locks a stale staging tree, sees the clone fail with the record kept, unlocks it, and sees the retry remove both.
- **Record that matched no branch** (assessor 2): another mount's record with no `stagingPath` is logged and forgotten, with a test.
- **Half-finished move** (assessor 3): `renameNoReplace` takes the target's identity inside the guarded path and removes the target if the source cannot be unlinked, unless another writer has replaced it. A new test covers a file and a symbolic link.
- **Clone fails only after cloning on XS** (engine-realist 1, coverage-auditor 3, decomplector 2): new `FilePowers.supportsRenameNoReplace()`. `makeMountStagingEntry` refuses first when it is false, before any staging or clone, and the design names XS as out of scope. The shim test asserts that XS reports false. There is no test of the refusal through a real XS manager, for the reason given under Declined.
- **Birth-time identity** (engine-realist 3): documented, not refused. The Node `statEntryIdentity` comment and the design name the case with no birth time. The XS `entryIdentity` comment says it is weaker and that nothing depends on the difference, because staging is refused there.
- **Threat model** (decomplector 1): the design now says why a concurrent holder is inside the contract, names the one decision that requires the mechanism, and says why records persist. The mechanism stays. If the maintainer prefers to narrow the contract and drop it, that is a design call to make on this PR.
- **Padding** (pruner 1 to 6): cuts applied as named. For pruner 6, the XS comment was replaced with the limitation above rather than deleted.
- **Changesets** (releaser 1, 2, 4): the daemon changeset is now `minor`. This reverses the previous round's decision: the one-object form is on the base branch, but no release has it (it is absent from `packages/daemon/CHANGELOG.md`, no release tag contains it, and its other mention is a pending changeset). The changeset is two bullets, and the sandbox SIGTERM note is a plain statement of behavior.
- **PR title and body** (integrator 2): the title names the cancellation fixes, and the `Refs:` line moved below the description.

**Declined or deferred**

- **Autosquash and regrouping** (integrator 1): not done here, because this stage only adds follow-up commits. The 5 `fixup!` commits and the fix-on-fix history still need a retcon before merge.
- **Splitting the git and sandbox fixes into their own PRs** (integrator 2): kept together, since the clone's credential-rotation test exposed them. The title now says so.
- **XS-native tests** (engine-realist 2, coverage-auditor 1, 2): not added, for the reason now in the PR body. `xst` lacks the host filesystem globals and no CI job runs the daemon suite under `endor`. The residual risk is named there. The existing test title already says it is shim-only.
- **`@endo/floot` changeset** (releaser 3): `@endo/floot` is `"private": true`, and its prompt only tracks the new call shape. This follows the previous round's call; note that `@endo/daemon` is also private and does carry changesets, so a maintainer may prefer one here too.
- **Folding the staging powers into one** (decomplector, comment-only), and the other comment-only items: left as is.

**Verification (local, Node 22):** `rename-no-replace`, `mount-platform-fs-conformance` and `git-remote`: all pass except `GitRemote push round-trips to an independent fetcher over file://`, which hits its 2-second `t.timeout` on this host and fails the same way on the previous head `1509ed043e`. `tsc` for `packages/daemon` reports no errors, and eslint (errors only) and prettier are clean on the touched files. The pre-push probes pass; the full gate run was cut off by a timeout here, so CI is the check for the rest. CI status is on the PR checks.
----- END COMMENT -----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-02T02:20:28Z
