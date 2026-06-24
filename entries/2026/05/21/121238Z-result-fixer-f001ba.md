---
ts: 2026-05-21T12:12:38Z
kind: result
role: fixer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/fixer--cb940c
---

Addressed kriskowal's CHANGES_REQUESTED on PR #336 (issue #59 fix).
The single inline ask (review 4336672074, comment 3280953395) was a
test-architecture redirect: move the regression from the SES in-package
gauntlet to the compartment-mapper test suite, with the three-module
fixture exercised both under plain Node.js and through the
compartment-mapper, so the linker behavior is teased out of SES.

Disposition (one commit, 2df948c14):

- Fixture: packages/compartment-mapper/test/fixtures-cycle-rename/node_modules/app/{mod1,mod2,main}.js + package.json. Three modules per the issue #59 reproducer (mod1 re-exports * from mod2; mod2 re-exports { y as x } from mod1 and defines var y = 45; main imports x from mod1 and namespaces both modules).
- Compartment-mapper test: packages/compartment-mapper/test/cycle-rename.test.js (uses scaffold.js, expands to 11 variants).
- Node.js parity test: packages/compartment-mapper/test/cycle-rename-node-parity.test.js (plain Node.js dynamic import, no SES / no compartment mapper, 1 test).
- Shared assertions: packages/compartment-mapper/test/_cycle-rename-assertions.js (expected values defined in exactly one place).
- SES gauntlet test removed: the 'cyclic star export with renaming reexport (issue #59)' block in packages/ses/test/import-gauntlet.test.js is deleted and replaced with a comment pointing to the compartment-mapper pair. The user's redirect framing said either remove the SES test or keep it as a minimal smoke if both layers genuinely needed coverage; since the compartment-mapper test exercises the same SES linker via the Compartment, the SES test is redundant.

Regression evidence: reverting packages/ses/src/module-instance.js to HEAD~1 (git checkout HEAD~1 -- ...) and re-running the new tests reproduces 'TypeError: notify is not a function' in 9 of the 11 compartment-mapper variants (the 2 archive-integrity-only variants pass because they do not import the fixture; the Node.js parity test is unaffected). Re-applying the fix restores all 12 tests.

Test counts:

- yarn workspace @endo/compartment-mapper test: 894 pass + 6 known failures (was 882 + 6; +12 from the new fixture).
- yarn workspace ses test: 501 pass + 2 known failures + 2 skipped (was 502 + 2 + 2; -1 from the removed gauntlet test).

Pre-push gates: only security-md-hash-uniform fires, and the divergent SECURITY.md files (packages/{immutable-arraybuffer,bytes,hex,panic}/SECURITY.md) are pre-existing repo-wide drift not caused by this PR (confirmed by stashing my changes and re-running the probes-only gate). The auto-fix stages produced spurious edits to packages/evasive-transform/src/index.js and packages/ses/src/compartment.js (jsdoc comment reformatting) which were dropped to keep this commit scoped to the test-architecture redirect.

Push: HEAD f6c2f2815 -> HEAD 2df948c14 on fix/issue-59-star-export-cycle. Reply id 3281028030 posted on the inline thread; top-level summary posted at https://github.com/endojs/endo-but-for-bots/pull/336#issuecomment-4508143027 with an @kriskowal mention (the reviewer is the PR author so re-requesting the bot's own identity is wrong). CI status at push time: zizmor + build pass; all matrix jobs pending. The steward will arm a CI watcher; on green the PR awaits the next maintainer pass (no auto-un-draft, this is a CHANGES_REQUESTED follow-up, not a fresh gauntlet).

Self-improvement: nothing this time.
