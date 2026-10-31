# PR #1595 gauntlet fix round 2: report

I applied the panel's findings to endojs/endo-but-for-bots#1595, pushed them, and CI finished green on all 36 checks. `ci-wait-merge` exited with rc 0.

**Source of the findings.** No deterministic pre-pass block came with this job. I worked from the latest panel verdict, comment review 5724578015 headed "Must-fix before merge". It had six jurors: typist, packager, breaker, integrator, changeset-auditor and corner-prober.

**Commits pushed with `safe-push-pr-head.sh`**, moving the head from `47955499c` to `535394412`:

1. **`8c4e81966` fix(cli): bound git-remote inputs and stop vouching for preview credentials**
   - **Branch selectors for the `agent` profile:** `--branch` must stay under `refs/heads/`.
     - It rejects an empty value, a bare `*` or `refs/heads/*` (every branch), and `refs/tags/*`, `refs/remotes/*` and `refs/*`.
     - It rejects `..`, `//`, `@{`, `:`, a leading `+` or `/`, a trailing `/`, and whitespace.
     - A wildcard must be a single trailing `/*`, and duplicates are dropped.
     - These rules mirror the daemon's checks in exo-git.
   - **Endpoint URL:** it must be `https:`, and a URL with an embedded username or password is rejected.
   - **Remote name:** the Git remote name is now the last segment of the pet-name path, and it must be a single plain segment. This stops it reshaping the fetch refspec.
   - **`--yes` without `--url`:** this now fails with an error instead of waiting at a prompt.
   - **Approval preview:** a new `formatGitRemotePreview` builds it. Push targets use the daemon's own `ref:ref` derivation. The credential is shown as "unverified" instead of a made-up "available".
   - **Types:**
     - The profile and direction types are now the closed unions `'fetch-only' | 'agent'` and `'fetch' | 'push'`.
     - The capability parameters have named types (`ERef<…>`) instead of `object`.
     - The branches parameter is marked optional, and `collectOption` is typed.
   - **README:** the Git remotes section now sits above the in-flight placeholder, links `designs/daemon-git-remotes.md`, and documents the new limits.
   - **Tests:** about 10 new unit tests in `git-remote-command.test.js` cover the boundary cases above, the preview, empty directions, a credential that is revoked but available, and `--yes` without `--url`.
2. **`403f81b9e` fix(daemon):** formula inspection now defaults a missing `pushRefspecs` to `[]`. A new test covers a revoked remote with no credential and no `pushRefspecs`.
3. **`535394412` chore (changesets):**
   - Added `"@endo/cli": minor`. The package is private, but the changeset config versions private packages.
   - Raised `@endo/daemon` from patch to minor.
   - Split the notes per package, one sentence per line.

**Local checks:**
- The cli unit tests (19) and the daemon `formula-record` tests (13) pass.
- `yarn lint` for cli and daemon has 0 errors, prettier is clean, and the root `tsc` reports nothing in the touched files.
- I could not run the real-daemon integration test here: the daemon would not start in this sandbox. CI runs it, and it passed.

**CI:** `cover (22.x, ubuntu-latest)` failed once, on the `@endo/sandbox` test "bwrap timeout and repeated cancellation reap process groups". That is a known bwrap flake unrelated to this diff, and the previous head was fully green. I reran it with `gh run rerun --failed` and it passed.

**Not done (should-fix or comment-only):**
- The preview does not look up the credential's real health. It only labels the credential as unverified.
- There is no extra warning for a selector that names the default branch outright, such as `main`.
- `prompt` and `promptText` still hang silently if stdin hits EOF.
- The four feature commits (including the tsconfig build-fix commit) were not squashed or split by package.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (5132404 cached reads)
- Output: 25239 tokens
- Cost: $2.4473407999999996
- Wall-clock: 3205s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
