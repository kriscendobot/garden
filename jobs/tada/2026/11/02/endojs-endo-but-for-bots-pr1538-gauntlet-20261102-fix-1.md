Fix round 1 for PR #1538 is pushed and CI is green: 35 checks, 0 failed, at head `a54166c7b6`. The panel's verdict listed only should-fix items under its must-fix heading, so I treated them as this round's required work, except the items declined below.

**Commits** (added on top of `1509ed043e`, no history rewrite)
- `6a504a4c3`: code and tests.
- `a54166c7b`: design doc and changesets.

**Code changes**
- **Failed cleanup (assessor 1):** `discardMountEntries` now forgets a staging record only if the removal succeeded, the entry was missing, or the identity no longer matches. If the holding directory might contain another holder's object, it loses its record so a later call can't delete that object. This now includes the case where the identity can't be read.
- **Stuck records (assessor 2):** another mount's record with no `stagingPath` is now logged and forgotten instead of being re-read forever.
- **Half-finished moves (assessor 3):** `renameNoReplace` now undoes its copy if it can't finish, unless another writer has replaced the target.
- **XS refusal (engine-realist 1, coverage-auditor 3, decomplector 2):** a new `FilePowers.supportsRenameNoReplace()` makes `makeMountStagingEntry` refuse on XS before any staging or cloning happens.
- **New tests:**
  - retry after a failed stale-staging removal
  - forgetting the foreign record
  - `renameNoReplace` rollback
  - XS reporting the capability as false (under Node-shimmed globals)

**Docs and changesets**
- **Design:** it now states the threat model, why records persist, and that XS is out of scope. The weaker identity without a birth time is documented in the code comments and the design.
- **Pruner:** cuts applied, except that one XS comment was replaced with the limitation rather than deleted.
- **Daemon changeset:** now `minor` and trimmed. This reverses the previous round's `major`, because the one-object form never shipped in a release.
- **Sandbox changeset:** the SIGTERM note is reworded as plain behavior.

**PR title, body and comment:** this host gets a 403 on PR writes, so I relayed them through job `endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-1-pr-body`, pinned to endolin. All three have landed, and the full disposition of findings is in that comment.

**Declined or deferred**
- **History cleanup (integrator 1):** autosquash and regrouping are not done because this stage only adds commits. The 5 `fixup!` commits still need a retcon before merge.
- **Splitting the PR (integrator 2):** the git and sandbox fixes stay in this PR, and the title now names them.
- **XS-native tests (engine-realist 2, coverage-auditor 1, 2):** not added, because `xst` lacks the host filesystem globals and no CI job runs the daemon suite under `endor`. The PR body names the remaining risk.
- **Floot changeset (releaser 3):** not added, because the package is private and its prompt only follows the new call. `@endo/daemon` is also private but does carry changesets, so a maintainer may want one here too.

**Decision for the maintainer:** the decomplector questioned the size of the staging mechanism (about 1,000 lines). The design now justifies it, but whether to narrow the contract and drop it is still the maintainer's call.

**Local verification (Node 22)**
- **Tests:** `rename-no-replace`, `mount-platform-fs-conformance` and `git-remote` all pass except `GitRemote push round-trips…`. That test hits its 2s timeout on this host, also fails on the unmodified previous head, and passes in CI.
- **Static checks:** `tsc` for `packages/daemon` is clean, and eslint (errors only) and prettier are clean on the touched files.
- **Pre-push gates:** the probes pass, but the full gate run hit my timeout, so CI covered the rest.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-20261102-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (3559238 cached reads)
- Output: 42470 tokens
- Cost: $2.7352876000000013
- Wall-clock: 5907s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
