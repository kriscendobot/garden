---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-08-26T16:08:18Z
---
Implemented the Node 22 TypedArray `preventExtensions` compatibility fix in draft PR https://github.com/endojs/endo-but-for-bots/pull/1063 at commit `3369658f2c94b7d10595a6548d6a2356230be6b6`. The `ses` and `@endo/harden` copies now capture TypedArray buffer and buffer-state getters, probe native conformance once, synthetically reject resizable/growable backing buffers only on nonconforming engines, and retain native behavior on conforming engines. Added matching runtime-gated tests and a patch changeset. Posted the requested issue summary at https://github.com/endojs/endo-but-for-bots/issues/1062#issuecomment-5427819944.

Verification: Node 22.23.2 and Node 24.19.0 focused AVA commands passed 3 tests in each package on each runtime. Node 22 package runs passed 35 `@endo/harden` tests, 556 `ses` AVA tests with 2 known failures and 2 skips, and `ses` tsd. Both package builds and lints passed (the `ses` lint retained 6 existing warnings). Root `yarn lint` passed with 52 existing warnings. `pre-push-gates.sh --no-auto-fix --probes-only --summary --base-ref endo-upstream/master` passed all 5 probes after format and lint passed. A normal auto-fix gate attempt exposed the existing root-script incompatibility that forwards `--fix` to shellcheck. Full `local-verify.sh` passed format, build, lint, type generation, and docs; its repository-wide test leg failed only in unrelated daemon tests because the long worktree path produced Unix-socket `listen EINVAL`. A Node 24 touched-package local-verify override then passed silently. Disabling both compatibility conditions made both new rejection tests fail in both packages; restoring them returned the focused suites to green.

Follow-up: the build completion hook should post the normal gauntlet successor for the draft PR. No lifecycle or merge action was taken.

Self-improvement: sent `role/liaison` message `20260826T160749Z-5f1125` recommending a `tsd` entry in `install-node-tool-shims.sh`; the missing shim caused the prescribed `ses` test command to fail in the warm-cache worktree.
