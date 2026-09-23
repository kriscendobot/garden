---
job: ddf639
posted_by_role: liaison
posted_by_host: endolinbot
posted_at: 2026-06-23T00:30:57Z
verb: gardener
project: null
target:
  repo: null
  pr: null
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - gardener
refs: []
preconditions: []
---

The maintainer asked the liaison to install xst locally so we can validate xst against the version pinned in c/moddable, and added the standing directive: "Do this in general if xst is not found." This means the install procedure should be encoded once and any role that needs xst can run it.

What landed in this session:
  * c/moddable submodule initialized at pinned commit 5516726818906190d3a042d8be90219ce9d51b45 (Moddable v8.0.1).
  * Built `xst` release variant from `$MODDABLE/xs/makefiles/lin/xst.mk` via `make GOAL=release`. Release binary lands in `$MODDABLE/build/bin/lin/release/xst`.
  * Installed to `~/bin/xst` (already on PATH). XS 17.9.1, slot 32 bytes, ID 4 bytes. Smoke test passes.
  * Worktree where the build artefacts and submodule live: /home/kris/worktrees/endojs-endo-but-for-bots/watch-endo-but-for-bots--monitor--20260512-233307

Gardener task: author `skills/xst-install/SKILL.md` that any role can invoke when `command -v xst` returns absent. The skill should:
  1. Locate the c/moddable submodule (`git submodule status c/moddable` from a worktree of endo-but-for-bots, then `git submodule update --init --recursive c/moddable` if not checked out).
  2. Build the release variant (`cd $MODDABLE/xs/makefiles/lin && MODDABLE=<abs> make -f xst.mk GOAL=release`).
  3. Install to a PATH location (default `~/bin/xst`, matching the host's existing convention).
  4. Verify with `xst -v` and a `print("hello")` smoke test.
  5. Note pin discipline: rebuild whenever c/moddable submodule pointer advances. Do not auto-update the submodule; that is a maintainer decision (the pin is a deliberate version stamp).
  6. Note that this is debug-vs-release-aware: debug is ASan-instrumented and much slower; for benchmarks the release variant is required.
  7. Cross-reference `packages/benchmark/install-engines.sh` (esvu-based `~/.esvu/bin/xs` install path used in CI) and note that the locally-built xst belongs at `~/bin/xst` for interactive validation, with the esvu path remaining the CI/benchmark surface unless the project moves to pinned local builds.

Other roles likely to benefit: builder (when a PR touches xst-validated paths), shepherd (when CI surfaces xst-skip warnings), researcher (when surveying engine-version coverage). Inline the skill reference in those role files as a "when you need xst" pointer; do not preload.
