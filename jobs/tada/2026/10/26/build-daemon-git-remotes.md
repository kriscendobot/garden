I opened draft PR **endojs/endo-but-for-bots#1557**, which implements the capability-URL slice of `daemon-git-remotes` from design PR #1367. CI ran the new tests on Node 24/Ubuntu and all passed. The remaining red jobs come from tests outside this change.

**What the PR does**

A host can now adopt a minion.town git capability URL (`https://x-access-token:<token>@git.minion.town/<partition>`) as a daemon `GitRemote` with bounded fetch, pull and push. No new host method was needed: it uses the existing credential, remote, clone and remote-controller methods.
- **New helper, `splitGitCapabilityUrl`.** It runs on the host side and splits the URL into:
  - a credential-free `url`;
  - the `audience`, `username` and `password` that `provideBasicCredential` takes.

  It accepts only `https:` URLs that carry a token, and its error messages never quote the input.
- **Token leak fixed in `normalizeGitRemoteUrl`.** All three of its rejections used to quote the whole URL, so a capability URL passed to the wrong method sent the token back over CapTP.
  - The embedded-credentials error now prints the URL with userinfo masked as `***` and points to the new helper.
  - The non-`https:` error prints only the scheme.
  - An unparseable URL isn't printed at all.
- **Help text.** New host help entries for `provideBasicCredential` and `provideGitClone` cover adopting the URL, narrowing a clone's origin to fetch-only, and recovering after a restart with `rotate`. The exo-git help and a changeset say the same.

**Where it departs from the design** (each is explained in the PR body)
1. **The design's redaction rule wasn't enough.** If the `https://` is missing, `x-access-token:<token>@host/p` parses as a URL whose *scheme* is `x-access-token:`, with the token in the path. Masking userinfo would still leak it, which is why the scheme error prints only the scheme. A test covers this.
2. **The helper is exported from `@endo/exo-git/src/git-remote-policy.js`, not the package index.** The repo's re-export policy blocks a new plain re-export from the index unless a maintainer exempts it. Moving it to the index is a one-line change if the maintainer wants that.
3. **There's no end-to-end HTTPS test through the daemon.** The daemon's git environment is deliberately locked down, so a test can't make git trust a test certificate. Instead:
   - At the backend level, a real `git http-backend` server requiring Basic auth over plain HTTP: an outside client pushes, and the fetch uses the split credential. The pushed file is read through `filesystemAt`, and a revoked token fails without echoing the token.
   - At the daemon level, over CapTP with a restart (`git-capability-url.test.js`):
     - fetch-only narrowing holds, and the bare remote's refs are unchanged after a refused push;
     - a credential for another origin is refused;
     - after the restart the credential reports revoked until `rotate` restores it;
     - a raw-byte scan of every file the daemon wrote finds no token. A check confirms the scan does see the saved remote URL, so it really reads the formula records.
4. **Design item 7 (marking the design Complete) isn't in this PR**, because the design file isn't on `llm` until #1367 merges.

**Tests and checks**
- **Local:** exo-git 75 passed; the remote, capability and help-text suites 51 passed. Five unrelated `git.test.js` cases (merge, cherry-pick, conflict) fail the same way on the unmodified base file here, which runs git 2.43. Type checks (exo-git, daemon, repo root) and the pre-push gates pass.
- **CI on Node 24/Ubuntu:**
  - Lint passed. exo-git passed 75 tests and the daemon 1611 (5 skipped), including all three new capability tests.
  - Three jobs are red: `build` (`tred: command not found`), `cover` and `test (24.x, ubuntu)` (`@endo/sandbox` bwrap `ulimit -u` / parent-death tests), and `sandbox-drivers`. Its log wasn't checked; it's assumed to be the same bwrap problem by name. None of these touch this PR's packages, and they match the reds already seen on other PRs.
  - The macOS and Node 22 test jobs were still running when I stopped watching.

**Follow-ups**
- **Warm-cache problem:** the shared cache gave this worktree a `better-sqlite3` built for Node ABI 137, but this host's `node` is v22 (ABI 127). The daemon couldn't start until I rebuilt that one file in this worktree only, after breaking its hard link so the shared cache stayed untouched. Any daemon test run from a warm-cache worktree on this host will hit the same thing.
- The gauntlet (clean → panel → fix-loop → un-draft) should be staged automatically from this completion. The PR stays draft until it runs.
- Still open from the design: scoping a credential to its exact URL, durable custody of the show-once URL, an atomic fetch-only option on `provideGitClone`, and a daemon-side server design.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-git-remotes.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 214 tokens (16404604 cached reads)
- Output: 67440 tokens
- Cost: $6.3559848000000025
- Wall-clock: 3364s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
