I applied the round-2 must-fix items to endojs/endo-but-for-bots#764 and pushed them as follow-up commits. CI is green on all 15 checks at head `8db80529dee`. My summary comment on the PR was not posted: this host's bot token gets a 403 when writing to endojs PRs.

**Commits added to the PR branch `mirror/endo-2780-cache-globals`:**
- **`f00e5080a`** fixes the review findings:
  - **Captured `Map` and `Set`:** `import-hook.js` now holds its own copies of `Map` and `Set` alongside `URL`, so both hook makers ignore any later replacement of those globals. Five reviewers flagged this (assessor, breaker, spec-keeper, integrator and purist).
  - **Dropped the `Function` capture:** `node-powers.js` now uses a local no-op for its read lock instead of keeping the original `Function` constructor (locksmith).
  - **Windows-safe tests:** the tests work out expected file paths with `node:url`, so they also pass on Windows (transplanter).
  - **Public imports:** the tests import `node-modules.js`, `node-powers.js` and `import-parsers.js` through the package's public entry points (integrator).
  - **New test:** it builds both hook makers while `Map` and `Set` are replaced. It passes with the fix and fails against the previous head.
  - **Smaller items:** I removed the redundant test comment (pruner) and put the changeset's description on one line listing the captured globals (changeset-auditor).
- **`ddf4dfff9`** dropped the unrelated CI comment change, as packager and integrator asked. That turned CI red: the zizmor workflow audit fails on the base branch's `# v3` comment at `ci.yml:279`.
- **`8db80529d`** puts that one-line comment change back so the audit passes. It has to stay until the base branch carries the same fix.

**Declined, for the maintainer to judge:**
- **Raising the changeset to `major`:** migrator called this a must-fix, but I kept `patch`. Capturing the globals at load time is a hardening fix, and the releaser reviewer also judged `patch` right.
- **Squashing the two `fixup!` commits:** the job asked for follow-up commits, not a history rewrite. They can be autosquashed at merge.
- **Adding a fast-check property test:** it would add a new devDependency, and the item was summary-fix level.
- **Extra fallback-`URL` tests for the sync read and write paths (corner-prober):** I did not add them.
- **Coverage report:** the coverage reviewer couldn't verify coverage of the new lines because no coverage report exists. I didn't generate one.

Package lint passes, with one warning that was already there. The new test file's 6 tests pass. The panel-3 re-review is still to run; the gauntlet driver posts it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr764-gauntlet-20261007-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1634240 cached reads)
- Output: 11983 tokens
- Cost: $1.10986
- Wall-clock: 1123s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
