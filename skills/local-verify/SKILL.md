---
created: 2026-06-25
updated: 2026-09-01
author: gardener
---

# Skill: local-verify

The deterministic, no-LLM pre-PR verification harness. A builder, fixer, or the
gardening state machine runs it in the project worktree right before pushing a
change for a pull request. It runs the project's real verification steps, in
order, so the work is **offloaded from the CI server**.

Running it is an **invariant, not an optimization**. The maintainer's standing
policy (@kriskowal, 2026-07-20): treat any lint or test failure in CI as a
failure of our automation to *anticipate* it. Every lint and test CI runs must
be run locally before pushing; a red CI check is a defect in our tooling to
close, not merely a PR to fix; and a local-pass/CI-fail discrepancy is itself an
environment-parity defect (see [Parity is the contract](#parity-is-the-contract)
below). This skill is where the fleet meets that bar (`roles/COMMON.md`
§ Reporting).

The executable is `scripts/jobs/gardening/local-verify.sh`; this skill is the
contract it implements. It is the default body of the gardening state machine's
"evaluation gate (always)" (`scripts/jobs/gardening/garden-pr.sh`, wired as
`GARDEN_EVAL`); see [gardening-state-machine](../../designs/gardening-state-machine.md).

## Why it exists

CI is the slow, expensive place to discover a format nit, a lint error, a type
break, or a failing test: each such discovery costs a round trip and a shepherd
loop that pulls the failure log into an agent's context. Running the same steps
locally first, deterministically and silently, moves that discovery off the CI
server and out of the agent's context — the shepherd's job shrinks to confirming
CI, not discovering failures. The speed (a shorter or empty shepherd loop, fewer
tokens on remote test discovery) is a consequence of the invariant, not its
purpose.

## Parity is the contract

The local set **must cover every lint and test CI runs**: enumerate against the
project's actual CI config (its workflow YAML, its `package.json` scripts), not
guesswork. Parity, not a representative sample, is the contract: the whole point
is that a silent local gate implies a green CI push.

So a change that passes locally and then **fails CI is a defect**, one of two
kinds, and both must be closed (never worked around with a one-off green push):

1. **A coverage gap**: `local-verify` omitted a check CI runs. Fix: add the
   missing check (extend the candidate table in [The steps](#the-steps-in-order),
   or wire the project's `package.json` script / a `LOCAL_VERIFY_<STEP>` override)
   so the step runs locally next time.
2. **An environment divergence**: the same check ran in both places but behaved
   differently (a tool absent locally, a version skew, a PATH the sandbox blocks).
   Fix: restore parity. Example: running `endojs/endo-but-for-bots` package tests
   locally needs `yarn`/`ava`/`eslint` PATH shims because the sandbox blocks
   `node_modules/.bin` exec; without them the test step silently skips locally and
   only CI runs it. The parity fix is to provide the shims with
   `scripts/jobs/gardening/install-node-tool-shims.sh`, not to accept the skip.
   Install them with that script rather than by hand: a hand-written shim naming
   one job's worktree dies (or, worse, silently lints a peer's checkout) as soon
   as that worktree is torn down. See [field-notes.md](field-notes.md), the
   2026-07-29 tool-shim entry.

Divergence in the **other** direction — local-fail, CI-pass — is the same defect
and gets the same treatment. A gate that red-lights work CI would have accepted
sends an agent chasing a phantom, and, worse, teaches the fleet that a red gate
is negotiable. The container's inherited **host git configuration** is the
standing source of these (it bind-mounts the maintainer's home, while a CI runner
has no user configuration at all), which is why the harness blanks it; see
[field-notes.md](field-notes.md), the 2026-07-28 rerere entry.

The fix is therefore always **two-part**: (i) green the PR, and (ii) close the
gap (add the missing check or restore the environment parity) so the same class
of local-pass/CI-fail cannot recur. Part (ii) is the defect fix the maintainer's
policy demands; part (i) alone leaves the automation blind to the same failure
next time. The
[ci-failure-classification-loop](../ci-failure-classification-loop/SKILL.md) is
where that second part is enforced during a live CI drive: whenever a red CI check
was one this gate should have caught, the loop emits the parity follow-up, not
just the green.

### Runtime parity (the Node version)

The sharpest environment divergence is the **runtime itself**. A project pins the
Node version its CI runs (`.node-version`, `.nvmrc`); GitHub's `actions/setup-node`
resolves that file — including the nvm-style `lts/*` alias — and runs every check
under the resolved major. A host whose `node` is a **different major** verifies
under the wrong runtime, and type-aware lint (`@endo/restrict-comparison-operands`,
`import/order`), module-resolution edge cases, and syntax support all move between
majors — so the gate can go **green here while the pinned-major CI goes red**.
This is exactly the class 2 divergence above, and it silently defeats the whole
contract: a green that does not imply a green on CI.

So the harness runs a **Node runtime-parity guard** before any step
(`scripts/jobs/gardening/local-verify.sh`, backed by `required_node_major` /
`active_node_major` / `find_node_bin_for_major` in `scripts/jobs/common.sh`):

1. Resolve the pinned major from `.node-version` (then `.nvmrc`). Explicit
   versions (`24`, `v24.18.0`, `24.x`) map directly; `lts/*`, `lts/-N`, and
   `lts/<codename>` resolve from a small static table plus a documented
   "current newest LTS" constant (`GARDEN_NODE_LTS_LATEST`, default `24`) — **no
   network**, so the gate stays deterministic and fails safe offline. Bump the
   constant when a new even major enters LTS (see
   [node-lts-window-watch](../node-lts-window-watch/SKILL.md)).
2. If the active `node` already matches, proceed silently.
3. Else look for a matching runtime under the common version-manager roots (nvm,
   fnm, n, volta) or an explicit `GARDEN_NODE`; if found, **adopt** it by
   prepending its `bin` to `PATH` for the run.
4. Else **refuse to run**, emitting a single `NODE RUNTIME PARITY:` line naming
   the pinned major, its source, and the active major, and exit non-zero (3).
   Failing loud is the point: a silent green under the wrong Node is the defect.

Escape hatches (all auditable): `GARDEN_SKIP_NODE_PARITY=1` bypasses the guard;
`GARDEN_NODE=<dir|binary>` points at a matching runtime; `GARDEN_REQUIRED_NODE_MAJOR`
overrides the resolved requirement (`-`/`none` clears it). Grounding:
endojs/endo-but-for-bots#1048 — a host on Node 22.23.2 reported `yarn lint:eslint`
green while the `.node-version=lts/*` -> Node 24.18.0 CI leg failed type-aware lint.

## The steps (in order)

`format -> build -> lint -> package-uniformity -> codegen -> test -> test-xs ->
docgen`, then a **codegen-then-clean gate**.

Run in that order against the project worktree. The harness errs toward running
the project's **full** suite: false positives (a wasted check) are fine, false
negatives (a regression that slips to CI) are not. Steps are not sense-gated,
matching the gardening state machine's "evaluation gate (always)" discipline.

**`build` precedes `lint` on purpose**, matching how a CI workflow orders them
(install, then build, then lint). A typed linter resolves each file through the
TypeScript project service, and on an unbuilt tree that service does not yet
know about files a build brings into a project, so eslint reports
`Parsing error: <file> was not found by the project service`: a hard error that
fails the step for an ordering reason rather than a real one. The order costs
nothing, because the harness runs every step regardless of earlier failures; it
only decides whether the lint result is trustworthy.

The `codegen` step runs the project's generators (candidates
`gen:code-mode-types`, `codegen`, `gen`, `generate`, `build:types:gen`,
`build:types`) so the generation happens as part of the gate rather than being
left to an agent's memory. This is the one step that deliberately wants the
**mutating** variant rather than the check variant, because the dirty gate below
is the detector: a candidate that only compiles or verifies (`build:types`, a
`tsc --build`) regenerates nothing and lets a staled artifact through, so a real
generator (`build:types:gen`) outranks it. Immediately after every step, the **codegen-then-clean gate** checks
`git status --porcelain`: if the worktree became dirty, a checked-in generated
artifact was **stale** (a generator just regenerated it), and the gate fails with
`STEP codegen left tree dirty: generated artifacts are stale — commit the regen`
plus a SHA-captured `git diff --stat`. This hardens against the recurring
endo-but-for-bots failure where a rebase staled
`packages/agentry/src/execute/{git,fs}-types.js` and silently red-lit all CI test
jobs after approval (endojs/endo-but-for-bots#714). It is generic: any project
with a mutating generator benefits.

The `test-xs` step is additive: it runs `test:xs` after the ordinary workspace
tests instead of treating it as an alternative spelling of `test`. This closes
the coverage gap exposed by endojs/endo-but-for-bots#1077, where CI's `test-xs`
job caught hardened262 baseline drift that the primary workspace tests do not
exercise.

The `package-uniformity` step is likewise additive: it covers the check CI runs
in its lint job **outside** `yarn lint` — the "Check package uniformity" step,
`yarn test:package-uniformity && node scripts/check-package-uniformity.mjs`. That
command has two halves: the `test:package-uniformity` script exercises the
checker's helpers against fixtures, while the enforcement half — `node
scripts/check-package-uniformity.mjs` — scans the actual tree and is a repo-root
command that **no package.json script wraps**. First-match script discovery
therefore cannot reach the scan, and folding it into `yarn lint` would *duplicate*
it in CI's existing lint leg. So this step has its own discovery that
reconstructs CI's compound command from the parts present (see
[Inputs](#inputs)): an override wins; else a single project-declared wrap script
(`lint:package-uniformity`, `check:package-uniformity`, `package-uniformity`,
`lint:packages`) is used verbatim — the preferred durable form, since
specialization belongs in the project's scripts; else the self-test script and
every present repo-root checker (`scripts/check-package-uniformity.mjs`) are
joined with `&&` so, like CI, both must pass. A project with none of these skips
the step silently, so it is inert everywhere it does not apply. This closes the
gap exposed by endojs/endo-but-for-bots#1015, where a tracked `src/types.d.ts`
was rejected by `node scripts/check-package-uniformity.mjs` while the generic
root-`lint` gate stayed silent — a coverage gap of exactly the class
[Parity is the contract](#parity-is-the-contract) requires closing.

### XS runtime parity (the Moddable release)

A discovered `test:xs` suite runs only with the Moddable release the project
pins. Before provisioning the runtime, the harness runs `git submodule update
--init --depth 1` when the project has `.gitmodules`. This mirrors a CI checkout
with `submodules: true` and covers packages whose XS matrix builds an engine or
oracle from a gitlink. It initializes direct submodules generically rather than
naming a project-specific path. Initialization output is part of the step's
discarded success capture or SHA-captured failure, so the harness remains silent
when it succeeds.

The harness resolves the Moddable pin from `GARDEN_MODDABLE_VERSION`, then
`.moddable-version`, then a unique `MODDABLE_VERSION` value in
`.github/workflows/*.yml` / `*.yaml`. It asks
`scripts/jobs/provision-moddable-xst.sh` for that exact release and prepends only
the returned directory to `PATH` for the XS suite. It deliberately never uses a
bare host `xst`: endo CI pins Moddable 5.0.0 (XS 15.5.1), while a garden host had
XS 17.9.1 on PATH and produced a false hardened262 baseline change locally.

The provisioner first honors the explicit `GARDEN_XST=<dir|binary>` override,
then checks the image cache at `/opt/moddable/<release>/bin/xst`, then the
per-host cache under `$GARDEN_STATE/tool-cache/moddable`. A cache miss downloads
the release's Linux x64 binary atomically under a lock. The image bakes the
current endo pin through the same provisioner; the writable cache handles a new
project pin without requiring an image rebuild. Unsupported platforms, an
ambiguous/missing pin, or a provisioning failure all fail as `STEP test-xs
FAILED`, with the diagnosis SHA-captured like any other check. None fall back to
the host binary.

The garden image also supplies the current stable Rust toolchain through rustup.
This matches GitHub's Ubuntu runner prerequisite for XS suites that launch Cargo
to build another engine. `RUSTUP_HOME` is image-owned and writable by the garden
user; Cargo's registry and build cache remain under the bind-mounted home.

## When to use

- **Before any push to a PR branch** (initial create or follow-up): run it; if it
  exits non-zero, fix the failing step and re-run until it is silent; then push.
- **As the gardening state machine's eval gate**: it is the default `GARDEN_EVAL`,
  so a supervised `garden-pr.sh` run already invokes it. A project that needs a
  different runner overrides `GARDEN_EVAL` with a command taking the worktree as
  its single argument.

It is **not** an orchestrator concern. The liaison and the panel do not run it;
their work is at the journal and review surfaces, not the project working tree.

## Inputs

`local-verify.sh [<worktree>]`

- `<worktree>`: the project tree to verify; defaults to the current directory
  (the gardening `project/` tree).

Per-step command discovery (each step, in order, first match wins):

1. An explicit override env var `LOCAL_VERIFY_<STEP>` (uppercased step name, with
   `-` mapped to `_`: `LOCAL_VERIFY_FORMAT`, `LOCAL_VERIFY_LINT`,
   `LOCAL_VERIFY_BUILD`, `LOCAL_VERIFY_PACKAGE_UNIFORMITY`,
   `LOCAL_VERIFY_CODEGEN`, `LOCAL_VERIFY_TEST`, `LOCAL_VERIFY_TEST_XS`,
   `LOCAL_VERIFY_DOCS`):
   - set to a command string: run that command in the worktree;
   - set to `-` (or empty): skip the step.
2. A `package.json` `scripts` entry matching the step's candidate names, run as
   `<yarn> run <script>`. Candidates (check-variant first so the harness verifies
   rather than mutates where a project offers the choice):

   | Step    | package.json script candidates                 |
   | ------- | ---------------------------------------------- |
   | format  | `format:check`, `check:format`, `format-check`, `format` |
   | lint    | `lint:check`, `lint`, `eslint`                  |
   | build   | `build`, `compile`, `build:js`                  |
   | codegen | `gen:code-mode-types`, `codegen`, `gen`, `generate`, `build:types:gen`, `build:types` |
   | test    | `test`, `test:unit`                            |
   | test-xs | `test:xs`                                     |
   | docs    | `docs`, `build:types`, `generate-docs`         |

3. Otherwise the step is skipped (recorded, silent).

The `package-uniformity` step is the exception to the single-script model above,
because CI's uniformity check runs a repo-root command no package.json script
wraps. After honoring an `LOCAL_VERIFY_PACKAGE_UNIFORMITY` override, its
discovery composes a command from the parts present, in this precedence:

- a **single wrap script** if the project declares one — candidates
  `lint:package-uniformity`, `check:package-uniformity`, `package-uniformity`,
  `lint:packages` — used verbatim (the preferred durable form);
- otherwise the **self-test script** (`test:package-uniformity`) **and** every
  present **repo-root checker** (`scripts/check-package-uniformity.mjs`, run as
  `node <path>`), joined with `&&` so both must pass, mirroring CI's
  `yarn test:package-uniformity && node scripts/check-package-uniformity.mjs`.

With none present the step is skipped silently. Extend `PU_WRAP_SCRIPTS` /
`PU_SELFTEST_SCRIPTS` / `PU_CHECKERS` in `local-verify.sh` to teach it another
project's uniformity check.

For a Yarn workspace tree, the `test` and `test-xs` steps deliberately do not
delegate to root aggregators. They list every workspace and run each workspace's
matching primary (`test` / `test:unit`) and additive XS (`test:xs`) scripts
directly. This prevents a fail-fast `workspaces foreach` root script from hiding
failures in later packages. Each suite accumulates workspace output into its own
SHA-captured failure report, and every workspace in that suite runs even after
an earlier one fails. A project that is not a discoverable Yarn workspace tree
retains the ordinary root-script behavior.

Runtime-parity knobs (see [Runtime parity](#runtime-parity-the-node-version)):
`GARDEN_SKIP_NODE_PARITY=1` bypasses the Node guard; `GARDEN_NODE=<dir|binary>`
names a matching runtime to adopt; `GARDEN_REQUIRED_NODE_MAJOR` overrides the
resolved requirement (`-`/`none` clears it); `GARDEN_NODE_LTS_LATEST` sets the
major `lts/*` resolves to (default `24`).

XS-parity knobs (see [XS runtime parity](#xs-runtime-parity-the-moddable-release)):
`GARDEN_MODDABLE_VERSION` overrides pin discovery; `GARDEN_XST=<dir|binary>`
supplies an explicit xst; `GARDEN_XST_SYSTEM_ROOT` and
`GARDEN_XST_CACHE_ROOT` override the provisioner's lookup/cache roots;
`GARDEN_MODDABLE_RELEASE_BASE_URL` selects a release mirror; and
`GARDEN_XST_PROVISIONER` replaces the provisioner command for a controlled test
or deployment.

The package runner defaults to `yarn` when present, else `npx corepack yarn`
(plain `yarn` is often absent in a fresh worktree; see
[pre-pr-checklist](../pre-pr-checklist/SKILL.md) § Pitfalls). Override with
`GARDEN_YARN`. A project with no `package.json` and no overrides verifies nothing
and exits 0; wire the real commands per project via package.json scripts or the
overrides. The candidate lists are deliberately small and extensible: add a
project's script name to the table rather than hardcoding one project's commands.

Discovering the real commands per project draws on `package.json` scripts, the
repo's CI workflow, and the [pre-pr-checklist](../pre-pr-checklist/SKILL.md) /
[pre-push-gates](../pre-push-gates/SKILL.md) skills.

## State

The harness keeps no project state. The XS provisioner may populate a
release-keyed host tool cache, atomically and under a lock; subsequent runs reuse
the exact release binary. Each invocation otherwise reads the worktree, runs
each discovered step, and exits. Re-running is idempotent and deterministic:
identical inputs hash to identical SHAs, so a recurring failure is recognizable
by its content address. The harness does **not** commit, push, or mutate tracked files
(beyond whatever a project's own `format`/`build` script does when no check
variant exists). It writes only unreferenced git blobs into the worktree's object
store for failure captures, which `git gc` collects.

## Procedure (what the harness does)

For each step, in order:

1. Discover the command (overrides, then `package.json`, then skip).
2. Run it in the worktree, capturing **combined stdout+stderr** to a temp file.
3. **On success: emit nothing** and discard the temp file. The blob is not even
   hashed (nobody needs it); the step silently passed.
4. **On failure**: hash the captured output into the worktree's object store via
   `git hash-object -w` (the `capture_blob` helper from `scripts/jobs/common.sh`)
   and emit **only**:

   ```
   STEP <name> FAILED: output blob <sha> (<n> lines) inspect: git -C <wt> cat-file -p <sha>
     <last non-empty line of the captured output>
   ```

   The raw output never reaches stdout. The harness runs **all** steps (it does
   not stop at the first failure) so the final report enumerates every failing
   step, then exits non-zero.

For the `test` step in a Yarn workspace tree, discovery and execution happen for
each workspace independently. A failed package does not stop the loop; the
captured test blob includes the package-labelled output for every failed
workspace.

Once every step has run, the **environment-fault check** runs: when two or more
failing steps that dispatched **different** commands produced **byte-identical**
output — the same capture blob — none of them reached a check, so the harness
reports one `ENVIRONMENT FAULT` line instead of leaving N independent-looking
verification failures. Distinct commands is the discriminator: two steps can
legitimately resolve to the *same* script (`codegen` and `docs` both match
`build:types` on a project with no dedicated generator), and that script failing
twice is one honest failure reported twice. Where the shared output carries a
recognizable runner-level signature (a not-installed usage error, `permission
denied`, a missing runner) the line names the likely cause; an unrecognized
environment fault is still reported, generically. The run still exits non-zero —
this changes the diagnosis, never the verdict.

After that, the **codegen-then-clean gate** runs once: if
`git status --porcelain` reports the worktree dirty, a generator regenerated a
stale checked-in artifact. The gate emits `STEP codegen left tree dirty:
generated artifacts are stale — commit the regen` with a SHA-captured
`git diff --stat` (plus the porcelain status, so a new untracked artifact is
visible too) via the same `capture_blob` path — the raw diff never reaches
stdout — and counts as a failure, so the run exits non-zero.

## Output

- Exit 0, no output: every discovered step passed (or was skipped). The caller
  proceeds to push with confidence.
- Exit non-zero: one block per failing step (step name + blob SHA + one-line
  tail + inspect command). The caller hands the SHAs to a debugging agent.
- Exit non-zero with a trailing `ENVIRONMENT FAULT:` line: the per-step blocks
  above it are **not** N verification results. Several steps that ran different
  commands failed with one identical output, so the runner or the environment
  refused them all and no check ran. Fix the environment and re-run for a real
  verdict; do not start debugging the change.

The exit code is the harness's sole machine-readable signal; the per-failure
blocks are the human/agent-readable surface.

## The debugging-agent contract (selective inspection)

The token-efficiency core: a debugging agent handed a failure block reads **only
the slices it needs** from the content-addressed blob (`git cat-file -p <sha> |
grep`/`sed`/`tail`), never the whole log — so the full failure enters context one
narrowed slice at a time. The inspection recipes, the relationship to
`GARDEN_TRACE` and [prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md),
and the cross-host `anchor_blob` note are in
[debugging-contract.md](debugging-contract.md).

## How it plugs into the shepherd/builder flow

- The gardening state machine (`garden-pr.sh`) runs it as the eval gate before
  the CI push. A failing gate fails loud with the emitted SHAs; the supervising
  gardener runs the **capture -> hash -> debugging-agent -> fix -> re-verify loop**
  locally until the gate is silent, then pushes. CI then sees a pre-vetted change.
- The shepherd's role shrinks accordingly: it confirms CI converged rather than
  discovering failures CI surfaces. A change that cleared the local gate is the
  short (or empty) shepherd loop the harness is built to produce.

## Composition with other skills

- [pre-push-gates](../pre-push-gates/SKILL.md): the deterministic *style/probe*
  gate (Prettier/eslint auto-fix, garden-specific probes, typecheck). It runs
  auto-fixers and re-stages; `local-verify` runs the project's *verification*
  suite read-only and captures failures by SHA. They are complementary: the
  push path runs the style gate (mutating auto-fixes) and then `local-verify`
  (read-only full suite) before pushing.
- [pre-pr-checklist](../pre-pr-checklist/SKILL.md): the broader human-facing
  review-yourself list; `local-verify` is the deterministic full-suite subset
  that runs without an LLM.
- [prompt-on-failure-capture](../prompt-on-failure-capture/SKILL.md): the
  capture-by-SHA escalation primitive `local-verify` reuses for its failure path.

## Tests

`scripts/jobs/test/local-verify-test.sh` exercises the contract against throwaway
git repos with a stubbed runner (`GARDEN_YARN`): the silent-pass / SHA-only-failure
surface, `cat-file` recovery of the captured output, check-variant discovery,
override skip/replace, no-`package.json` exit 0, SHA determinism, the
codegen-then-clean gate (fires on a staled artifact, silent when up to date), and
two failing workspaces both appearing in the captured test blob without the
fail-fast root aggregator. The XS-parity group proves that `test` and `test:xs`
both run for every workspace, that a CI-pinned xst overrides a deliberately
mismatched host xst while success remains silent, and that a missing pin fails
loud without executing XS. Two later groups cover the environment-fault class: unit
cases prove identical output from **different** commands is reported as one
`ENVIRONMENT FAULT` (cause named, per-step blocks retained) while distinct output —
and one script matched by two steps — is not flagged; an end-to-end case drives the
real `ensure-project-worktree.sh` through a cold build then a warm cache HIT
(stubbed yarn-4 runner that refuses `run` without link state) and asserts the gate
runs silently in the HIT worktree, with a `GARDEN_SKIP_DEP_RECONCILE=1` negative
control that must diagnose an environment fault. A final group covers the Node
runtime-parity guard, driven relative to the host's actual node major so it holds
on any runner: a mismatched pin fails loud (`NODE RUNTIME PARITY`, non-zero) with
the steps proven **not** to run; a matching pin passes; `GARDEN_SKIP_NODE_PARITY`,
`GARDEN_REQUIRED_NODE_MAJOR`, `GARDEN_NODE_LTS_LATEST`, `.nvmrc` fallback, and the
adopt-a-discovered-runtime path (a fake nvm node on an exec-capable base) are each
asserted. The XS fixture begins with a real direct git submodule uninitialized,
requires its pinned source marker from every `test:xs` command, and proves the
harness initializes it while retaining silent success. A package-uniformity
group proves the additive check reconstructs CI's
compound command from the parts present — the self-test script then the repo-root
scan, in CI's order — that a tracked-file rejection by the repo scan (which no
package.json script wraps) fails the step with both halves' output in the blob,
that a single wrap script subsumes the parts without a duplicate self-test/scan,
that `LOCAL_VERIFY_PACKAGE_UNIFORMITY=-` skips it, and that it is inert on a
project with no uniformity check. `bash -n` and `shellcheck` clean.

## Pitfalls

The recurring gotchas — a mutating `format` tripping the dirty gate, per-project
specialization belonging in the project's scripts, never inlining a failure log
into a prompt, reading N identical tails as one environment fault, and confirming
the deployed harness is not lagging `main2` — are catalogued in
[pitfalls.md](pitfalls.md).

## Notes from the field

The dated log of every environment divergence and coverage gap this harness has
closed — the `TMPDIR` noexec / bin-shim fault, the `hermetic_gitconfig` fix, the
build-before-lint reorder, the warm-cache install-state reconcile, the
`ENVIRONMENT FAULT` diagnosis, the tree-independent tool shims, and more, each
with its tell and its fix — lives in [field-notes.md](field-notes.md). Append new
entries there.
