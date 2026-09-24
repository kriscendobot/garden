**Completion report: `improve-gh-wrapper-suppress-credential-daemon`**

The fix is pushed to `main2` as `23dcd50219f`. From now on, no fleet `gh` call can consult or start a git credential helper from ambient git config.

**What changed**
- **`scripts/jobs/bin/gh`:** before any call to the real `gh`, the wrapper now:
  - adds `credential.helper=` (empty) through `GIT_CONFIG_COUNT`/`GIT_CONFIG_KEY_n`/`GIT_CONFIG_VALUE_n`. This is the environment form of `git -c credential.helper=`, and it is added after any entries the caller already set rather than replacing them.
  - sets `GIT_TERMINAL_PROMPT=0`, so a git with no helper fails instead of waiting for a username.
  - It covers every path, including the token lookup, the `pr create` marker path and the comment-footer path. `GARDEN_GH_KEEP_CREDENTIAL_HELPER=1` turns it off.
- **I did not use the job's suggested `GIT_CONFIG_GLOBAL=/dev/null` / `GIT_CONFIG_NOSYSTEM=1`.** That would also throw away the user identity, `url.*.insteadOf`, `safe.directory` and other global settings that `gh pr checkout` and `gh repo clone` depend on. Clearing only the helper setting gets the same result without those losses.
- **Checked by hand before the change:**
  - The empty setting also removes helpers scoped to a URL (`credential.<url>.helper`).
  - gh's own git calls still work. They pass `-c credential.helper= -c credential.<host>.helper=!gh auth git-credential`, and git applies that after the environment settings.
- **New test `scripts/jobs/test/gh-wrapper-credential-helper-test.sh`** (5/5 pass, no network). It checks that:
  - the test helpers really do run without the wrapper;
  - both the plain and the URL-scoped helpers are blocked under the wrapper;
  - gh's own `-c` helper still runs;
  - settings the caller put in `GIT_CONFIG_*` are kept (the new entry goes in slot 1 and the count becomes 2);
  - the opt-out works.
- The existing wrapper tests still pass: fail-closed 49/0, pr-numeric-scope-guard 29/0, comment-provenance 61/0. shellcheck reports no warnings.

**Follow-ups and caveats**
- **Root cause not confirmed.** This host (garden2) is a follower. Its CI watcher is skipped by the leader check, and its journal has no "left-over process" line. It also has no global or system `credential.helper`, so I couldn't confirm that the 23:33:11 leftovers were credential-cache daemons. If they were ordinary `git` children of `gh` (for example from looking up the repo), this change won't stop them, and the watcher's cleanup on exit would need to reap the whole cgroup instead. Watch the leader's `garden-ci-watcher@` logs for "Found left-over process" after this deploys.
- The fix only reaches `gh` calls that go through the wrapper. A plain `git` call in fleet scripts still reads the ambient helper settings.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-gh-wrapper-suppress-credential-daemon.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (610330 cached reads)
- Output: 10133 tokens
- Cost: $0.788334
- Wall-clock: 101s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
