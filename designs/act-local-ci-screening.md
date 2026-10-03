# Local CI screening: audit workflow parity, do not put `act` on the push path

| Created | 2026-10-03 |
| Author  | designer   |
| Status  | Proposed   |

## Origin

The maintainer asked the garden to anticipate GitHub Actions failures locally,
limited to jobs that run on Linux. The research child measured the available
runtime, current workflows, and recent CI costs. Its evidence is recorded in
[`act-local-ci-screening-findings.md`](act-local-ci-screening-findings.md).

## Decision

Do **not** integrate `act` into `pre-push-gates.sh`, `local-verify.sh`, or a
host-side sysop operation now. Add a static workflow-parity audit to
`local-verify` instead. The audit compares the hand-maintained local verification
plan with the PR-gating Linux jobs in the actual workflow YAML. A mismatch is a
`local-verify` coverage-gap bug, not a reason to run a second best-effort test
suite.

This is a recommendation not to integrate `act` under the current constraints,
not a claim that local CI screening is unnecessary. The static audit supplies the
part `act` was meant to provide: detection of setup, environment, matrix,
working-directory, repository-root command, and job-inventory drift. The existing
[`local-verify`](../skills/local-verify/SKILL.md) harness remains the executor of
the real local checks. [`pre-push-gates`](../skills/pre-push-gates/SKILL.md)
continues to own mutating style checks and garden-specific probes.

## Feasibility finding

Container-mode `act` is infeasible in the gardener execution path as of
2026-10-03. The garden container has no Docker or Podman client, no daemon socket,
and no durable nested-container runtime. Mounting the host Docker socket would
give workflow code host-level control and conflicts with the container's security
boundary.

`act -P ubuntu-latest=-self-hosted` can run without Docker, but it is not a sound
parity gate:

- it executes workflow code with the gardener's PATH, wrappers, environment, and
  credentials; the garden `git` wrapper already caused a false failure in the
  minion.town test job;
- `act -n` still executes steps in self-hosted mode;
- every run copied roughly 1 GB of workspace data into an unpruned cache;
- `act` rejects endo-but-for-bots' `parallel:` steps and its `$/` reusable
  workflow paths, so it cannot parse the main workflow whose parity must be
  audited; and
- the one successful endo-but-for-bots selector run took 80 seconds, compared
  with a 0.3 minute CI median.

A future container-mode experiment would first need a separate, maintainer-owned
container-hardening change that adds and validates rootless Podman, plus roughly
0.6 GB per host for the medium runner image. That experiment is not part of this
design. Running project workflows directly on the host is not the fallback.

## Scope

The audit covers workflow jobs that can gate a pull request or ordinary branch
push and whose effective `runs-on` matrix contains `ubuntu-*`. It never rewrites
or emulates macOS or Windows jobs. Release, deployment, scheduled fuzz, Pages,
and repository-mutating maintenance workflows are inventory-only and cannot be
selected for local execution.

### `endojs/endo-but-for-bots`

The following Linux jobs are in the parity inventory. "Gap" means the audit must
record a `local-verify` coverage bug, even when the missing job is too expensive
or lacks a local prerequisite today.

| Workflow jobs | Initial disposition |
| --- | --- |
| `ci-changes / changes` | selector only; statically inventory its outputs and path rules |
| `ci / lint` | partial coverage; gap for `check-security-md.sh`, `build:types:check`, `lint:types`, and `test:types` |
| `ci / test` on Ubuntu, Node 22 and 24 | partial coverage; local `test` exists, but both matrix runtimes must be represented |
| `ci / cover`, `viable-release` | gap: `test:c8`, `smoketest:publish` |
| `ci / test-xs` | covered by the additive `test-xs` step, subject to matrix and environment signature comparison |
| `ci / build-xsnap`, `familiar-bundle`, `test-hermes`, `test-async-hooks`, `check-action-pins` | gap or partial gap |
| `ci / format-ironhorse`, `test-ironhorse` (debug and release), `test-ironhorse-oracle`, `test-ironhorse-calibration`, `test-thixotrope-ironhorse`, `compare-ironhorse-math`, `fuzz-ironhorse` | gap; artifact edges and matrix cells stay visible |
| `ci / test-ocapn-python`, `build-wasm` | gap |
| `browser-test / browser-tests`, `depcheck / build`, `ironhorse-sanitizers / oracle-sanitizers` | gap |
| `ci / sandbox-drivers`, `ocapn-guile-interop / test-ocapn-guile-interop` | gap with an unavailable-local-prerequisite diagnosis, not an exclusion |
| `zizmor / zizmor` | covered by `local-verify`'s native `zizmor` step; do not run its Docker-based action through `act` |

The macOS cells of `ci / test`, `test-ironhorse-macos`, and `familiar-release`
are explicitly skipped. Release, Pages deployment, scheduled full-test262 and
deep-fuzz jobs, action-pin updaters, and `copilot-setup-steps` are not pre-push
screen targets.

### `kriscendobot/minion.town`

| Workflow jobs | Initial disposition |
| --- | --- |
| `test / test` | partial coverage; gap for `claude-harness:check`, Endo daemon setup, and the dedicated integration-test invocations |
| `test / Claude harness` on amd64 and arm64 | gap; Docker buildx and privileged QEMU/binfmt are unavailable locally |
| `deploy / deploy` | excluded: production deployment with AWS OIDC, not a PR screen |

The audit must derive this inventory from the checked-out YAML. These tables are
the initial expected result, not a second source of truth.

## Design

### 1. A machine-readable parity ledger

Add one tracked ledger per supported repository under
`scripts/jobs/gardening/local-verify-parity/`. Each row identifies a workflow,
job, matrix cell or constraint, and stable step key. It records one disposition:

- `covered`: names the `local-verify` step and the locally selected command;
- `gap`: names the missing local surface and a follow-up basename, or the
  literal `to-be-filed` until one exists;
- `native`: names an intentionally equivalent local tool, such as the zizmor
  CLI in place of its Docker action; or
- `excluded`: allowed only for a non-Linux cell or a non-screen target, with a
  reason.

Linux PR-gating lint and test steps cannot be marked `excluded` merely because
they are slow or need an unavailable tool. They remain visible as coverage-gap
bugs until the local environment or check is supplied. The ledgers seed the
known gaps above rather than silently grandfathering them as covered.

### 2. Static extraction from the real YAML

Add `scripts/jobs/gardening/audit-local-verify-parity.sh [--strict]
[--base-ref <ref>] <worktree>`. It parses YAML without applying `act`'s GitHub
Actions schema, so valid YAML extensions such as `parallel:` and repository-local
`$/` paths remain inspectable.

For each workflow, the extractor records:

- event class and whether the job can gate a pull request or ordinary push;
- job name, `needs` edges, reusable-workflow target, and effective Linux matrix
  cells;
- `runs-on`, job and step `env`, `defaults.run.working-directory`, and container
  or service requirements;
- setup actions and their static inputs, including Node versions, checkout
  submodules, caches, and architecture setup; and
- every `run:` body in execution order, including commands nested under
  `parallel:`.

The extractor gives each item a normalized signature. Expressions that cannot
be resolved statically remain literal parts of that signature. It does not try
to predict GitHub expression values and does not execute action code.

The other side of the comparison comes from a new read-only
`local-verify.sh --plan` mode. It runs the same package-manager, runtime,
candidate, override, workspace, and additive-step discovery used by a real
verification, but prints the selected commands and environment prerequisites
without executing them. The audit must not maintain a second copy of candidate
selection logic.

### 3. Hot-path ratchet and full audit

`local-verify.sh` invokes the audit before executing checks.

- The default hot-path mode fails on an unknown Linux screen job, a changed or
  deleted ledger target, a newly changed CI signature whose local counterpart
  did not change, a ledger row claiming a local step that `--plan` did not
  select, or a new coverage gap introduced by the proposed diff.
- Existing `gap` rows are printed only by `--strict`; they do not make every
  unrelated push impossible. They remain bugs with named follow-ups, not
  waivers.
- `--strict` reports the complete inventory and exits nonzero while any `gap`
  row remains. It is the opt-in and periodic audit surface used when closing
  coverage gaps.

Success stays silent, matching `local-verify`. Failure output follows the same
content-addressed capture contract: one `STEP workflow-parity FAILED` line with
a git blob SHA and a one-line diagnosis. The raw inventory does not enter the
gardener's context unless a debugging agent requests it.

The initial implementation should close the cheap gaps in `ci / lint` and
minion.town's `claude-harness:check`. Larger suites remain named `gap` rows with
follow-ups to be filed. A gap discovered by the audit follows the existing
two-part disposition: green the current change, then close the automation gap.

### 4. No `act` execution hook

There is no `act` step in `pre-push-gates.sh`; that script stays fast and
mutating. There is no `act` mode in `local-verify.sh`; the harness continues to
run project commands directly under its controlled runtime. There is no
host-level or sysop execution path.

If a later hardening design proves rootless container execution and `act` gains
support for the repository's workflow syntax, `act` may become an optional
second implementation of the strict audit. It must consume the same ledger,
select only Linux cells, use an explicit bounded cache under `$GARDEN_STATE`,
run without gardener credentials or wrappers, and show a measured advantage
over direct local commands before entering the push path.

## Ownership map

| Boundary | Mechanism | Policy | Durable state | Lifecycle / commit authority | Value crossing |
| --- | --- | --- | --- | --- | --- |
| project workflow -> parity audit | YAML extraction and normalized signatures | the project workflow defines remote CI truth; the audit only classifies it | workflow YAML in the project commit | project commits change the workflow | workflow/job/matrix/step inventory |
| `local-verify --plan` -> parity audit | reuse of command discovery without execution | `local-verify` defines what the garden promises to run | candidate tables and parity ledgers on `main2` | garden commits change the local contract | selected local command plan |
| parity audit -> `local-verify` | silent pass or SHA-captured failure | `local-verify` decides whether a push may proceed | no run state; only unreferenced failure blobs | the caller retries after fixing or recording a gap | coverage verdict and diagnostics |

The project repository owns persistent workflow state. The garden owns the
tracked parity ledger and local candidate policy. No runtime component commits
state. Re-running from the same project and garden commits reproduces the audit;
the caller owns retry. The audit classifies **coverage**, while `local-verify`
classifies **local execution** as pass or fail. GitHub Actions alone classifies
the remote run. The inner/outer naming check is satisfied: no extractor or plan
value is named as a CI result, deployment, or commit outcome.

## Cost and benefit

For endo-but-for-bots, a full-change push currently represents about 208 Linux
runner-minutes and 82 macOS runner-minutes, with a 26 to 28 minute critical path.
Those standard-runner minutes are free because the repository is public. Local
screening can save queue and repair-loop time, but not a bill. Replaying the
whole Linux matrix on every push would spend substantial local CPU time while
duplicating checks `local-verify` already runs.

Minion.town uses about eight billed runner-minutes per PR push today, but its CI
is moving to a self-hosted runner. Its host-mode `act` test took 29 seconds warm
against a 2.3 minute CI median, but inherited a garden PATH divergence and did
not cover the Docker/QEMU jobs. The prospective billed-minute saving is small
and likely temporary.

The static audit adds only YAML and manifest parsing to each local verification.
It prevents the more valuable failure class: CI adds or changes a check while
the local table silently remains stale. Direct commands then run only once,
through `local-verify`, with its runtime selection, failure capture, and existing
debugging loop.

## Alternatives considered

- **Run self-hosted `act` before every push.** Rejected: it executes with
  gardener authority, leaks disk, produces environment-only failures, and cannot
  parse the primary endo-but-for-bots workflow.
- **Mount the host Docker socket.** Rejected: workflow code would gain control
  equivalent to the host daemon's authority.
- **Add rootless Podman to the image now.** Deferred to a separate hardening and
  benchmarking design. It does not repair `act`'s workflow-parser gaps and has no
  demonstrated cost advantage.
- **Use `act` only for `ci-changes`.** Rejected for the push path: the measured
  local run was slower than CI and copied a large workspace. The static audit can
  inspect the selector's paths and outputs without executing actions.
- **Keep comparing workflows by hand after a CI failure.** Rejected: that is the
  drift mechanism this design is intended to remove.

## Test plan

1. Fixture workflows cover `parallel:`, `$/` reusable workflows, multiline
   `run:` bodies, nested job and step environment, working directories, services,
   and mixed Ubuntu/macOS/Windows matrices.
2. Removing a local candidate, adding a Linux `run:` step, changing a setup-node
   matrix, or moving a command to a different working directory makes the audit
   fail with one SHA-captured report.
3. A macOS-only or Windows-only change remains inventoried but does not become a
   local execution target.
4. A ledger row that points to a skipped `local-verify --plan` step fails; a
   `native` zizmor mapping passes only when the planned CLI flags match the
   workflow inputs.
5. Snapshot fixtures from endo-but-for-bots and minion.town produce the inventory
   and initial gaps in this document without invoking `act`, Docker, or project
   scripts.
6. The existing `local-verify-test.sh` suite proves a clean parity audit remains
   silent and a parity failure preserves the harness's all-steps and blob-capture
   contracts.

## Open questions

None. Rootless Podman and any later container-mode `act` experiment require a
separate design and measured evidence; they are not decisions needed to build
this audit.
