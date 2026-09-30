---
handed-off: ebfb-petname-path-only-sweep
deliverable-complete: false
---
**Completion report: `ebfb-petname-path-only` (handed off; the work is not finished)**

I opened draft PR https://github.com/endojs/endo-but-for-bots/pull/1390. It has the core breaking change, but the full daemon test suite does not pass yet, and callers in other packages that pass pet names through string variables are not converted. The successor job `ebfb-petname-path-only-sweep` owns everything that is left.

The PR's head is `build/pet-name-path-only` and its base is pinned to `llm-8e53cc0`, taken from the `llm` tip `8e53cc0f89`. It is one commit, `e76909d36c` (120 files).

**What the PR changes:**
- **The rule:** daemon methods that accepted either a pet name or a pet-name path now accept only a path (an array of path components). This covers the host, guest, directory, mail, channel and inspector methods. `namePathFrom` / `petNamePathFrom` no longer turn `'x'` into `['x']`. A bare string gets this error: *"Invalid pet-name path "…": a string is not a pet-name path and is never split on a delimiter; try again with an array of path components, for example [...]"*.
- **The guard still lets a string through, on purpose.** I checked the error a strict array guard gives: `Must be a copyArray`. That doesn't tell an agent what to do instead. So the guard lets a string reach `namePathFrom`, which rejects it with the message above. A comment in the code explains this. A reviewer may prefer a strict guard.
- **Guards and types:** `NameOrPathShape` / `NamesOrPathsShape` are replaced by `NamePathArgumentShape` / `NamePathsArgumentShape`, including in the lal tools. The `NameOrPath` / `NamesOrPaths` types are removed, and parameters typed `string | string[]` are now `string[]`.
- **Internal callers:** these passed a single string and now pass an array: path-walking `lookup(petName)` calls in `directory.js` and `manager.js`, `listValues`, the planes lookup, the host's `makeUnconfinedFromTree` scratch name, and the inspector `lookup`.
- **CLI:** `cancel`, `request`, `form` and verbose `list` now split names into arrays, as the other commands already did.
- **Docs:** `help.md` explains the rule and uses array examples, and `help-text-data.js` is regenerated. The changeset marks `@endo/daemon` as a major version and records the motivation from kriskowal's review.
- **Codemod:** it rewrote string literals at pet-name argument positions into one-element arrays. That covered the daemon tests plus calls on agent-like receivers (`E(host|guest|agent|powers|…)`) in other packages.
- **Typecheck:** `tsc` on the daemon package is clean except two `@endo/agentry` call sites.
- **PR body:** follows the repo template and explains the motivation, what is still open, and how this relates to #1343. The body says it will rebase over #1343 if that lands first. It does not duplicate #1343's endowment change.

**Not finished (owned by `ebfb-petname-path-only-sweep`):**
- **Test status:** the last full daemon run used an earlier state of the code, and failures were still coming in:
  - `channel.test.js` UI-flow tests and the `code-mode-provisioning-*` tests (both caused by string arguments passed through variables);
  - `content-store-gc*` and `directory-read-only-view`;
  - `debugger-captp`, where the codemod wrongly wrapped a debugger's `evaluate(source)` argument. I reverted that but didn't rerun it.
  
  I haven't rerun anything since the later fixes, and no CI run has finished.
- **Callers outside the daemon** that use string variables are not converted: `setup*.js` scripts across packages, spaces-util `command-executor`, chat, lal, and agentry's `credential` manifest field.
- **Possible codemod false positives:** it matched on method names, so a few non-daemon receivers may have been wrapped needlessly. The successor should audit these.
- **Mount and `@endo/platform` fs surface:** I deliberately left it unchanged. It also accepts a string or an array, so the maintainer needs to decide whether the same rule applies there.

**Notes for anyone running these tests locally:**
- In this worktree the daemon tests can't start their unix socket because the path is too long; copy the worktree to a short path first.
- `better-sqlite3` in the worktree's package store was built for a different Node version. I rebuilt it with node-gyp in the project worktree's store.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-petname-path-only.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 246 tokens (15351579 cached reads)
- Output: 58912 tokens
- Cost: $5.647699799999997
- Wall-clock: 1638s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
