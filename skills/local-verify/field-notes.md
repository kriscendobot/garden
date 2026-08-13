# local-verify — notes from the field

Reference companion to [SKILL.md](SKILL.md). The dated log of environment
divergences and coverage gaps `local-verify` has closed, each with its tell and
its fix. Append here; terse and dated. A claiming agent consults this on demand —
especially when a local-pass/CI-fail (or local-fail/CI-pass) discrepancy looks
like one of these recurring classes.

- _2026-06-25_: initial build (job `build-local-prepr-verification`). Wired as the
  default `GARDEN_EVAL` in `garden-pr.sh`, replacing the `true` no-op placeholder.
  Reuses `capture_blob` from `common.sh` (the audit-self-healing-wrappers
  primitive). Hashes only on failure (success needs no blob), a deliberate read
  of the "hash then discard on success" contract that avoids creating GC'able
  loose objects on the common path.
- _2026-07-16_: added the `codegen` step + codegen-then-clean gate (job
  `improve-local-verify-regen-clean-gate`). Generators now run as part of the
  gate; a worktree left dirty by a regen fails loud with a SHA-captured
  `git diff --stat`. Hardens against endojs/endo-but-for-bots#714, where a rebase
  staled `packages/agentry/src/execute/{git,fs}-types.js` and silently red-lit all
  CI test jobs after approval until the regen was committed.
- _2026-07-20_: reframed from optimization to **invariant** (job
  `encode-ci-parity-policy`) per the maintainer's standing policy: any lint/test
  CI failure is a defect in our automation, not merely a PR fix. Added the
  [Parity is the contract](SKILL.md#parity-is-the-contract) section: the local set must
  cover every check CI runs, and a local-pass/CI-fail discrepancy is a coverage
  gap or an environment divergence to close (two-part fix: green + close the gap).
  Cross-linked from `roles/COMMON.md` § Reporting and
  [ci-failure-classification-loop](../ci-failure-classification-loop/SKILL.md).
- _2026-07-28_: closed an environment divergence found while shepherding
  endojs/endo-but-for-bots#865. The container mounts `/tmp` **noexec**, and yarn 4
  materializes every package-bin call as a temporary exec shim under `$TMPDIR`, so
  any step dispatching through a bin died locally with `permission denied: <bin>`
  (observed as `ses-ava` for the `test` step and `tsc` for `lint:types`) while the
  same script was green on CI. The affected checks therefore could not run locally
  at all. `local-verify.sh` now exports an exec-capable `TMPDIR` via the new
  `exec_tmpdir` helper in `scripts/jobs/common.sh` (probe `$TMPDIR`, fall back to
  `$GARDEN_SCRATCH/tmpexec`), generalizing the defense
  `scripts/jobs/ensure-project-worktree.sh` already applied to the dep install.
  The tell is a "failure" whose message is `permission denied` rather than an
  assertion: that is the environment, not the change.
- _2026-07-28_: closed a coverage gap found in the same shepherd run. On
  endojs/endo-but-for-bots the `codegen` step matched `build:types` at the repo
  root, which is `tsc --build tsconfig.composite.json` — a **compile**, not a
  generator. The real generator is `build:types:gen`
  (`node scripts/generate-composite-tsconfigs.mjs`), so nothing regenerated the
  composite tsconfigs and the dirty gate had nothing to catch. Adding a workspace
  dependency (`@endo/harden` to `packages/agent-tools`) staled
  `packages/agent-tools/tsconfig.composite.json`, the local gate stayed silent,
  and CI's separate `yarn build:types:check` step turned `lint` red. Fix:
  `build:types:gen` now outranks `build:types` in the codegen candidates. General
  lesson for the table: a codegen candidate must **mutate**; a check-or-compile
  script in that slot makes the codegen-then-clean gate vacuous.
- _2026-07-28_: closed an environment divergence in the **opposite** direction —
  local-fail, CI-pass (job `fu-build-exo-google-sheets-facets-1`). The container
  bind-mounts the host user's home, so the maintainer's
  `~/.config/git/config` was in effect for every `git` a verification step
  spawned, while a CI runner has no user configuration at all. Its
  `rerere.enabled=true` made `@endo/agentry`'s conflict-rebase eval fixture
  auto-resolve the conflict it exists to provoke (`Staged 'app.txt' using
  previous resolution`), so a test asserting the conflict stops the rebase failed
  here and passed on CI. `local-verify.sh` now calls the new
  `hermetic_gitconfig` helper (`scripts/jobs/common.sh`), which points
  `GIT_CONFIG_GLOBAL`/`GIT_CONFIG_SYSTEM` at `/dev/null` so every step sees only
  repository-local configuration — checked in, hence identical on CI.
  `GARDEN_INHERIT_GITCONFIG=1` opts back out while debugging. The class is wider
  than rerere: `diff.algorithm`, `diff.renames`, `merge.conflictStyle`,
  `rebase.autostash`, `core.autocrlf`, and `url.<base>.insteadOf` all change git's
  semantics from a config file CI never reads. The tell is a failure that
  reproduces for the fleet but never for CI, on a project whose tests shell git.
  The project-side half is endojs/endo-but-for-bots#883, which pins rerere off in
  the fixture's own repository-local config; the two defenses are independently
  sufficient, and the fixture's is the one that also protects a human's checkout.

- _2026-07-28_: **`build` now precedes `lint`** (job
  `endojs-endo-but-for-bots-form-data-advisory`), closing a second
  environment-divergence class of the same shape as the gitconfig one above.
  Linting an unbuilt tree made eslint's TypeScript project service report whole
  directories under `packages/familiar` and `packages/lal` as
  `Parsing error: <file> was not found by the project service` — hard errors, so
  the step failed, while the identical content was green on CI (whose lint job
  builds first). Re-running `yarn lint:eslint` after the build step on the same
  worktree reported zero errors, which is what identified the ordering rather
  than the branch as the cause. The tell is a lint failure naming files the diff
  does not touch.

  Sibling gap found in the same run and NOT yet closed: eight `@endo/cli` demo
  tests fail locally at `endo start` with
  `ENOENT ... <worktree>/.tmp/endo-cli-test-XXXXXX/runtime/endo.sock`. The socket
  path is 134 bytes against the 108-byte `sun_path` limit, because a per-job
  project worktree path (`$GARDEN_SCRATCH/project-wt-<job-base>-<hash8>`) is
  already ~90 bytes before the test appends its own suffix. That workflow's own
  `Move working directory` step relocates its checkout under `$RUNNER_TEMP` for
  exactly this reason. Any project whose tests bind a unix socket under the
  worktree is exposed; the fix is a shorter per-job checkout path (or a short
  socket dir), and it belongs in `scripts/jobs/ensure-project-worktree.sh` rather
  than here, since changing that naming has to stay stable across a requeue.

- _2026-07-28_: closed an environment divergence that made the gate **unrunnable
  on a warm-cache worktree** (job `local-verify-parity-endo-but-for-bots-warm-cache`).
  `scripts/jobs/ensure-project-worktree.sh` populates a fresh per-job worktree by
  hardlinking cached `node_modules` trees in and skipping the install. But a
  package manager keeps its *"is this project installed?"* state **outside**
  `node_modules` — yarn 4 writes `.yarn/install-state.gz` at the project root —
  and that file is gitignored, so `git worktree add` never carries it and the
  cache never copied it. Yarn therefore refused every `yarn run <script>` in the
  populated tree with `Usage Error: The project in .../package.json doesn't seem
  to have been installed`, and `local-verify.sh` reported **all six steps
  FAILED** with that one message. Fix: a cache HIT now finishes by running the
  package manager's own install (`dep_reconcile_cmd`) to reconcile its state
  against the trees just linked in. It does not defeat the cache — what the cache
  spares is the **native build**, and a reconcile against a populated store
  performs none: measured on `endojs/endo-but-for-bots`, ~5s reconcile against a
  ~5s cold install on an already-warm yarn store, with `better-sqlite3`'s
  prebuilt `.node` keeping its cached inode and mtime. Both numbers now appear in
  the `WARM-CACHE hit:` log line, so a reconcile that ever grew into a real
  rebuild would be visible rather than inferred. `npm ci` is substituted for
  `npm install` on this path only, because `npm ci` deletes `node_modules` first
  and would throw away the hardlinked trees. The tell is the pitfall: six
  identical one-line tails, all a package-runner *usage* error.

- _2026-07-28_: a second divergence reported alongside it — `@endo/agentry`'s
  `eval > conflict-rebase > outcome assertion fails when conflicted worktree is
  left mid-rebase` failing locally while green on CI — turned out **not to be
  new**. It is exactly the `rerere.enabled=true` divergence the gitconfig note
  above already closed: the fixture provisions its repository by resolving the
  conflict once, so an inherited rerere auto-stages `app.txt` on the test's own
  rebase, leaving `M  app.txt` where the test asserts `UU app.txt`, and the test
  rethrows. It reappeared because the **deployed** root checkout was behind
  `main2` and its `local-verify.sh` predated `hermetic_gitconfig` (also predating
  build-before-lint and the workspace-test aggregation). Verified directly on a
  fresh worktree: the test **passes** under `GIT_CONFIG_GLOBAL=/dev/null
  GIT_CONFIG_SYSTEM=/dev/null` and **fails** without them, printing
  `Staged 'app.txt' using previous resolution` — the same signature. Nothing to
  fix in the harness; the follow-up is a deliberate deploy
  ([context/operations/deploy.md](../../context/operations/deploy.md)).
  Generalized as the "confirm you are running the harness you think you are"
  pitfall. Note the project-side pin from
  `endojs/endo-but-for-bots#883` (`rerere.enabled=false` in the fixture's own
  repository-local config) is still not on `llm`, so the harness-side defense is
  currently the only one in force.

- _2026-07-29_: closed the remaining two halves of the warm-cache divergence
  above (job `fix-warm-cache-yarn-install-state`), which was posted before the
  link-state reconcile landed and outlived it by three requeues. The root cause
  was already fixed, so what was left was **the regression** and **the
  diagnosis**.
  * *Regression.* `scripts/jobs/test/local-verify-test.sh` now drives the real
    `ensure-project-worktree.sh` through a cold build and then a warm cache HIT
    (throwaway fork + bare clone + a stubbed package manager that reproduces
    yarn 4's defining behavior: refuse every `run` without link state) and
    asserts the gate **exercises its steps** in the HIT worktree — silent, exit
    0. The negative control re-creates the pre-fix shape exactly, with
    `GARDEN_SKIP_DEP_RECONCILE=1`. Before this, the reconcile was covered only
    from the provisioner's side (`project-worktree-isolation-test.sh` asserts
    the link state gets written); nothing asserted the *gate* was runnable,
    which is the property that actually failed.
  * *Diagnosis.* `local-verify.sh` now distinguishes **"the runner is broken"**
    from **"the check failed"** (§ Output): two or more failing steps that ran
    **different** commands yet produced **byte-identical** output get one
    trailing `ENVIRONMENT FAULT` line naming the shared blob and exonerating the
    change, plus a cause hint for the recognizable signatures (not-installed,
    `permission denied`, missing runner). Identical output is the crisp signal
    here because the failure capture already content-addresses each step's
    output, so "the same failure six times" is an exact blob-SHA match rather
    than a fuzzy text comparison. The discriminator that keeps it honest is
    *different commands*: `codegen` and `docs` both match `build:types` on a
    project without a dedicated generator, and that one script failing twice is
    an honest failure reported twice, not an environment fault. Verdict and exit
    code are unchanged — only the diagnosis is. The general lesson for the
    table: when a gate captures failures by content address, cross-step output
    identity is free evidence about whether the gate ran at all, and a gate that
    can tell it never ran should say so rather than emit N failures it knows are
    one.
- _2026-07-29_: closed the environment divergence the Parity section already
  warned about, found while working the review on
  <https://github.com/endojs/endo-but-for-bots/pull/671>. The `yarn`/`ava`/
  `eslint` PATH shims this skill prescribes were **hand-written by whichever job
  first needed one**, each `exec node <that job's worktree>/node_modules/...`.
  A per-job worktree is torn down when its job ends, so on this host all four
  shims (`eslint`, `prettier`, `tsc`, `ava`) pointed into a
  `project-wt-...-pr761-shepherd-...` deleted days earlier. Every lint, type, and
  test step dispatching through them was broken host-wide. The second failure
  mode is the dangerous one and is silent: while the pinned worktree still
  exists, the shim **lints a peer's checkout**, so a green result says nothing
  about the code about to be pushed, which is precisely the local-pass/CI-fail
  discrepancy this skill exists to prevent. Fix:
  `scripts/jobs/gardening/install-node-tool-shims.sh` generates shims that name
  no tree at all, walking up from `$PWD` at invocation time to the nearest
  enclosing `node_modules` holding the tool. That resolution is correct for every
  worktree concurrently and needs no reinstall between jobs. Each tool carries
  every entrypoint spelling we have seen (`ava/entrypoints/cli.mjs` and
  `cli.js`), so a tool upgrade moving its entrypoint does not silently re-break
  the shim. General lesson for the table: a shim that hard-codes an absolute path
  into ephemeral per-job state is not a parity fix, it is a deferred parity bug,
  and its quiet failure mode is worse than its loud one.
