#!/bin/bash
# local-verify.sh — the deterministic, no-LLM pre-PR verification harness.
#
# Runs the project's real verification steps, IN ORDER, before a change is
# pushed for a pull request:
#
#   format -> build -> lint -> package-uniformity -> codegen -> test -> test-xs -> docgen
#
# then a codegen-then-clean gate: if any step (a generator, typically) left the
# worktree dirty, a checked-in generated artifact was stale — fail loud.
#
# so the work is offloaded from the CI server: a change that passes here is far
# more likely to be green on the first CI push, which shortens (or eliminates)
# the shepherd loop and spends fewer tokens on remote test discovery.
#
# Design contract (see skills/local-verify/SKILL.md and the gardening state
# machine, designs/gardening-state-machine.md):
#
#   * NO LLM. Pure shell plus the project's own commands. It is the gardening
#     state machine's "evaluation gate (always)" body, wired as GARDEN_EVAL in
#     garden-pr.sh.
#
#   * SILENT ON SUCCESS. A run where every discovered step passes prints
#     NOTHING and exits 0, to protect the supervising agent's context window.
#
#   * GIT-CONTENT-STORE FAILURE CAPTURE. A failing step's combined stdout+stderr
#     is hashed into the project worktree's object store via `git hash-object -w`
#     (the capture_blob helper from common.sh). Only the resulting blob SHA (plus
#     a one-line tail and the exact inspect command) reaches stdout — never the
#     raw output. A debugging agent then reads ONLY the slices it needs:
#         git -C <worktree> cat-file -p <sha> | grep/sed/tail
#     so a large test log never floods the agent's context.
#
#   * DETERMINISTIC & RE-RUNNABLE. Identical inputs hash to identical SHAs, so a
#     recurring failure is recognizable by its content address.
#
#   * EVALUATION-GATE DISCIPLINE. It errs toward running the project's FULL
#     suite: false positives (a wasted check) are fine, false negatives (a
#     regression that slips to CI) are not. Steps are not sense-gated.
#
#   * "THE RUNNER IS BROKEN" IS NOT "THE CHECK FAILED". When two or more steps
#     that ran DIFFERENT commands fail with byte-IDENTICAL output (the same
#     capture blob), none of them actually ran a check — the package runner or
#     the environment refused them all. That is an environment fault, and it is
#     reported as ONE such line rather than left to look like N independent
#     verification failures. See § Environment fault vs check failure below.
#
# Usage: local-verify.sh [<worktree>]
#   <worktree> defaults to the current directory (the gardening project/ tree).
#
# Per-step command discovery (each step, in order, first match wins):
#   1. An explicit override env var LOCAL_VERIFY_<STEP> (uppercased step name):
#        - set to a command string  -> run that command in the worktree
#        - set to "-"                -> skip this step
#   2. A package.json "scripts" entry matching the step's candidate names
#      (run as `<yarn> run <script>`).
#   3. Otherwise the step is skipped (recorded, silent).
#
# `test:xs` is an additional suite, not an alternative spelling of `test`. When
# present, the harness initializes the project's direct submodules (matching a
# CI checkout with `submodules: true`) and runs under the Moddable release pinned
# by CI, provisioned into an isolated tool cache. An unrelated host `xst` is
# never selected from PATH.
#
# `package-uniformity` is another additive check CI runs in its lint job OUTSIDE
# `yarn lint` (the "Check package uniformity" step, `yarn test:package-uniformity
# && node scripts/check-package-uniformity.mjs`). Because the actual repo scan is
# a repo-root command that no package.json script wraps, discovery for this step
# reconstructs CI's compound command from the parts present (§ discover_package_
# uniformity below), so the check runs locally WITHOUT being duplicated into the
# project's `yarn lint`. Grounding: endojs/endo-but-for-bots#1015, where a tracked
# `src/types.d.ts` was rejected by `node scripts/check-package-uniformity.mjs`
# while the generic root-`lint` gate stayed silent.
#
# A project with no package.json and no overrides verifies nothing and exits 0;
# wire the real commands per project via package.json scripts or the overrides.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Reuse the shared failure-capture helper (capture_blob) and log() from the job
# board common library. Sourcing it does no network I/O; it only defines helpers
# and pins the fleet gh identity onto PATH.
# shellcheck source=/dev/null
. "$HERE/../common.sh"

wt="${1:-$PWD}"
wt="$(cd "$wt" 2>/dev/null && pwd)" || { echo "local-verify: no such worktree: ${1:-$PWD}" >&2; exit 2; }
pkg="$wt/package.json"

# Parity guard: the container mounts /tmp noexec, and yarn 4 materializes every
# package-bin call as a temporary exec shim under $TMPDIR, so a step that
# dispatches through a bin (ses-ava, tsc, ...) dies with "permission denied"
# locally while passing on CI. Point TMPDIR at an exec-capable directory so the
# local step actually runs the check rather than reporting an environment
# failure. See skills/local-verify § Parity is the contract.
TMPDIR="$(exec_tmpdir)"
export TMPDIR

# Parity guard: the container bind-mounts the host user's home, so the
# maintainer's ~/.config/git/config is in effect for every git a verification
# step spawns, while a CI runner has none. A semantics-changing setting there
# (rerere.enabled, diff.algorithm, merge.conflictStyle, core.autocrlf, ...) then
# makes a step behave differently here than on CI in either direction. Run every
# step against repository-local git configuration only, so the gate's silence
# means what it claims. See common.sh's hermetic_gitconfig and
# skills/local-verify § Parity is the contract.
hermetic_gitconfig

# ── Node runtime parity ──────────────────────────────────────────────────────
# A project pins the Node version CI runs (`.node-version` / `.nvmrc`). GitHub's
# actions/setup-node resolves that file — including the `lts/*` alias — and runs
# every check under it. A host whose `node` is a DIFFERENT major then verifies
# under the wrong runtime: type-aware lint (`@endo/restrict-comparison-operands`,
# `import/order`), module-resolution edge cases, and syntax support all move
# between majors, so this gate can go green while the pinned-major CI goes red.
# That is the environment-divergence class § Parity is the contract requires
# closing, not a check failure — so the gate ADOPTS a matching runtime when it
# can find one, else REFUSES to run rather than emit a misleading green.
# Grounding: endojs/endo-but-for-bots#1048 (host on Node 22, `.node-version=lts/*`
# → Node 24 CI, `yarn lint:eslint` green locally / red on CI).
#
# Escape hatches: GARDEN_SKIP_NODE_PARITY=1 bypasses the guard (an explicit,
# auditable choice); GARDEN_NODE=<dir|binary> points at a matching runtime;
# GARDEN_REQUIRED_NODE_MAJOR overrides the resolved requirement (or "-" clears it).
if [ "${GARDEN_SKIP_NODE_PARITY:-}" != 1 ]; then
  req_major="$(required_node_major "$wt")"
  if [ -n "$req_major" ]; then
    spec_line="$(node_version_spec "$wt")"
    raw_spec="${spec_line%%$'\t'*}"; src_file="${spec_line#*$'\t'}"
    if [ -n "${GARDEN_REQUIRED_NODE_MAJOR:-}" ]; then
      raw_spec="$GARDEN_REQUIRED_NODE_MAJOR"; src_file="GARDEN_REQUIRED_NODE_MAJOR"
    fi
    act_major="$(active_node_major)"
    if [ "$act_major" != "$req_major" ]; then
      swap_bin="$(find_node_bin_for_major "$req_major")"
      if [ -n "$swap_bin" ]; then
        PATH="$swap_bin:$PATH"; export PATH        # adopt the matching runtime
        act_major="$(active_node_major)"
      fi
    fi
    if [ "$act_major" != "$req_major" ]; then
      printf 'NODE RUNTIME PARITY: project pins Node %s (%s = %s) but the active node is %s — refusing to verify under a mismatched runtime, because a green here would NOT imply a green on Node %s CI. Install Node %s (nvm/fnm/n), point GARDEN_NODE at a matching runtime, or set GARDEN_SKIP_NODE_PARITY=1 to bypass deliberately.\n' \
        "$req_major" "${src_file:-.node-version}" "${raw_spec:-?}" "${act_major:-none}" "$req_major" "$req_major"
      exit 3
    fi
  fi
fi

# The package runner: plain `yarn` is often absent in a fresh worktree, so fall
# back to `npx corepack yarn` (see skills/pre-pr-checklist § Pitfalls). Override
# with GARDEN_YARN for tests or a project that uses a different runner.
if [ -n "${GARDEN_YARN:-}" ]; then
  YARN="$GARDEN_YARN"
elif command -v yarn >/dev/null 2>&1; then
  YARN="yarn"
else
  YARN="npx corepack yarn"
fi

# Steps in execution order, and the package.json script names each maps to. The
# first candidate that exists wins. Check-only variants come first so the harness
# verifies rather than mutates where a project offers the choice.
#
# BUILD RUNS BEFORE LINT, matching how CI orders them (install -> build -> lint).
# A typed linter resolves each file through the TypeScript project service, and
# on an unbuilt tree that service does not yet know about files a build step
# brings into a project, so eslint reports them as
# `Parsing error: <file> was not found by the project service` — hard errors that
# fail the step for an ordering reason rather than a real one. Linting first
# therefore produced a local-FAIL/CI-pass discrepancy on
# endojs/endo-but-for-bots (whole directories under packages/familiar and
# packages/lal), which is the environment-divergence class § Parity is the
# contract requires closing rather than working around. Re-running the same lint
# after the build reports zero errors. Ordering costs nothing here: the harness
# runs every step regardless (it does not stop at the first failure), so this
# only changes whether the lint result is trustworthy.
STEPS="format build lint package-uniformity codegen test test-xs docs"
candidates() {
  case "$1" in
    format)  echo "format:check check:format format-check format" ;;
    lint)    echo "lint:check lint eslint" ;;
    build)   echo "build compile build:js" ;;
    # codegen runs the project's generators so a staled checked-in artifact is
    # regenerated in-tree, then caught by the codegen-then-clean gate below —
    # rather than left to an agent's memory and discovered on CI. Unlike the
    # other steps this one wants the MUTATING variant, since the dirty gate is
    # the detector: `build:types:gen` (the generator) must therefore outrank
    # `build:types` (a tsc compile that regenerates nothing).
    codegen) echo "gen:code-mode-types codegen gen generate build:types:gen build:types" ;;
    test)    echo "test test:unit" ;;
    # CI-only suites are additive: a workspace with both `test` and `test:xs`
    # must run both. Keeping this as its own step prevents first-match discovery
    # from treating the XS suite as an alternative to the primary test.
    test-xs) echo "test:xs" ;;
    docs)    echo "docs build:types generate-docs" ;;
    *)       echo "" ;;
  esac
}

has_script_in() {  # has_script_in <package.json> <name>
  local package_json="$1" name="$2"
  [ -f "$package_json" ] || return 1
  if command -v jq >/dev/null 2>&1; then
    jq -e --arg s "$name" '(.scripts // {}) | has($s)' "$package_json" >/dev/null 2>&1
  else
    # jq-less fallback: match a "<name>": key. Coarser but never silently empty.
    grep -qE "\"$name\"[[:space:]]*:" "$package_json"
  fi
}

override_name() {  # override_name <step>
  printf 'LOCAL_VERIFY_%s\n' "$(printf '%s' "$1" | tr '[:lower:]-' '[:upper:]_')"
}

discover_in() {  # discover_in <package.json> <step> — print command, or nothing
  local package_json="$1" step="$2" override name
  override="$(override_name "$step")"
  if [ -n "${!override+x}" ]; then        # override is SET (even if empty)
    case "${!override}" in
      -|"") return 0 ;;                    # explicit skip
      *)    printf '%s\n' "${!override}" ; return 0 ;;
    esac
  fi
  for name in $(candidates "$step"); do
    if has_script_in "$package_json" "$name"; then printf '%s run %s\n' "$YARN" "$name"; return 0; fi
  done
  return 0                                 # no command — skip
}

# Discovery for the additive `package-uniformity` step. CI runs, in its lint job
# and OUTSIDE `yarn lint`, a compound "Check package uniformity" command:
#   yarn test:package-uniformity && node scripts/check-package-uniformity.mjs
# The self-test half is a package.json script (it exercises the checker's helpers
# against fixtures); the enforcement half is a repo-root command that scans the
# actual tree and that NO package.json script wraps. First-match script discovery
# therefore cannot reach it, and folding the scan into `yarn lint` would duplicate
# it in CI's existing lint leg — so this composer reconstructs CI's command from
# whichever parts are present:
#   1. Override LOCAL_VERIFY_PACKAGE_UNIFORMITY wins verbatim (or "-"/"" skips).
#   2. A project that wraps the whole check in ONE package.json script (the ideal
#      durable form — specialization belongs in the project's scripts) is used
#      as-is. Extend PU_WRAP_SCRIPTS for a project's chosen name.
#   3. Otherwise: the self-test script (PU_SELFTEST_SCRIPTS) AND every present
#      repo-root checker (PU_CHECKERS, each run as `node <path>`), joined with
#      `&&` so — like CI — both must pass. A project with none of these skips the
#      step silently, so the step is inert everywhere it does not apply.
PU_WRAP_SCRIPTS="lint:package-uniformity check:package-uniformity package-uniformity lint:packages"
PU_SELFTEST_SCRIPTS="test:package-uniformity"
PU_CHECKERS="scripts/check-package-uniformity.mjs"
discover_package_uniformity() {  # print the compound command, or nothing (skip)
  local override name parts=() joined i f
  override="$(override_name package-uniformity)"
  if [ -n "${!override+x}" ]; then        # override is SET (even if empty)
    case "${!override}" in
      -|"") return 0 ;;                    # explicit skip
      *)    printf '%s\n' "${!override}" ; return 0 ;;
    esac
  fi
  for name in $PU_WRAP_SCRIPTS; do
    if has_script_in "$pkg" "$name"; then printf '%s run %s\n' "$YARN" "$name"; return 0; fi
  done
  for name in $PU_SELFTEST_SCRIPTS; do
    if has_script_in "$pkg" "$name"; then parts+=("$YARN run $name"); break; fi
  done
  for f in $PU_CHECKERS; do
    [ -f "$wt/$f" ] && parts+=("node $f")
  done
  [ "${#parts[@]}" -gt 0 ] || return 0     # nothing to run — skip, silent
  joined="${parts[0]}"
  for ((i = 1; i < ${#parts[@]}; i++)); do joined="$joined && ${parts[$i]}"; done
  printf '%s\n' "$joined"
}

discover() {
  case "$1" in
    package-uniformity) discover_package_uniformity ;;
    *)                  discover_in "$pkg" "$1" ;;
  esac
}

# Resolve the Moddable release used by CI. A repository-local pin wins; the
# workflow fallback covers projects such as endo, whose test-xs job declares
# `env: MODDABLE_VERSION: 5.0.0`. Multiple workflow values are ambiguous and
# fail loud instead of choosing whichever grep happened to encounter first.
moddable_version_spec() {  # print "<release><TAB><source>", or nothing
  local workflow values count
  if [ -n "${GARDEN_MODDABLE_VERSION:-}" ]; then
    printf '%s\t%s\n' "$GARDEN_MODDABLE_VERSION" GARDEN_MODDABLE_VERSION
    return 0
  fi
  if [ -s "$wt/.moddable-version" ]; then
    values="$(sed -e 's/[[:space:]]*#.*//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' \
      "$wt/.moddable-version" | grep -v '^$' | sort -u)"
    count="$(printf '%s\n' "$values" | grep -c .)"
    [ "$count" -eq 1 ] || return 1
    printf '%s\t%s\n' "$values" .moddable-version
    return 0
  fi
  values=""
  for workflow in "$wt"/.github/workflows/*.yml "$wt"/.github/workflows/*.yaml; do
    [ -f "$workflow" ] || continue
    values="$values
$(awk '
  /^[[:space:]]*MODDABLE_VERSION:[[:space:]]*/ {
    sub(/^[[:space:]]*MODDABLE_VERSION:[[:space:]]*/, "")
    sub(/[[:space:]]*#.*/, "")
    gsub(/^[[:space:]"\047]+|[[:space:]"\047]+$/, "")
    if (length) print
  }
' "$workflow")"
  done
  values="$(printf '%s\n' "$values" | grep -v '^$' | sort -u)"
  [ -n "$values" ] || return 1
  count="$(printf '%s\n' "$values" | grep -c .)"
  [ "$count" -eq 1 ] || return 1
  printf '%s\t%s\n' "$values" .github/workflows
}

prepare_xst_runtime() {  # print the bin directory holding CI's pinned xst
  local spec release source provisioner bin_dir
  if ! spec="$(moddable_version_spec)"; then
    printf 'XS RUNTIME PARITY: test:xs is present but no unique Moddable release pin was found. Set .moddable-version, CI env MODDABLE_VERSION, or GARDEN_MODDABLE_VERSION; refusing to use an unpinned host xst.\n' >&2
    return 1
  fi
  release="${spec%%$'\t'*}"; source="${spec#*$'\t'}"
  case "$release" in
    *[!A-Za-z0-9._+-]*|'')
      printf 'XS RUNTIME PARITY: invalid Moddable release %s from %s.\n' "$release" "$source" >&2
      return 1 ;;
  esac
  provisioner="${GARDEN_XST_PROVISIONER:-$HERE/../provision-moddable-xst.sh}"
  if ! bin_dir="$("$provisioner" "$release")"; then
    printf 'XS RUNTIME PARITY: could not provision Moddable %s from %s; refusing to fall back to the host xst.\n' \
      "$release" "$source" >&2
    return 1
  fi
  [ -x "$bin_dir/xst" ] || {
    printf 'XS RUNTIME PARITY: provisioner returned %s, which has no executable xst.\n' "$bin_dir" >&2
    return 1
  }
  printf '%s\n' "$bin_dir"
}

prepare_xs_environment() {  # print the bin directory after CI checkout parity
  # A package's test:xs command may build an engine or oracle from a gitlink.
  # actions/checkout with `submodules: true` initializes every direct submodule
  # before the suite; an isolated project worktree does not. Reproduce that
  # prerequisite generically instead of teaching this harness a project path
  # such as c/moddable. Git's ordinary progress goes to the step capture so a
  # successful first checkout remains silent at the harness surface.
  if [ -f "$wt/.gitmodules" ]; then
    if ! git -C "$wt" submodule update --init --depth 1 >&2; then
      printf 'XS WORKTREE PARITY: could not initialize the direct submodules required by the test:xs checkout.\n' >&2
      return 1
    fi
  fi
  prepare_xst_runtime
}

failures=0

# Per-failure ledger backing the environment-fault check below: for every failed
# step, the command it ran and the SHA its captured output hashed to. Identical
# output from DIFFERENT commands is the signature of a broken runner.
fail_steps=()
fail_cmds=()
fail_shas=()

run_step() {  # run_step <step> — run it; silent on pass; SHA-capture on fail
  local step="$1" cmd out sha lines tail xst_bin="" prep_rc=0
  cmd="$(discover "$step")"
  [ -n "$cmd" ] || return 0               # nothing discovered — skipped, silent

  out="$(mktemp "${TMPDIR:-/tmp}/local-verify-$step.XXXXXX")"
  if [ "$step" = test-xs ]; then
    xst_bin="$(prepare_xs_environment 2>"$out")"
    prep_rc=$?
  else
    prep_rc=0
  fi
  if [ "$prep_rc" -eq 0 ] && ( cd "$wt" && PATH="${xst_bin:+$xst_bin:}$PATH" bash -c "$cmd" ) >>"$out" 2>&1; then
    rm -f "$out"                          # success: silent; blob not needed
    return 0
  fi

  # Failure: hash the combined output into the worktree's object store and
  # surface only the SHA + a one-line tail + the inspect command.
  sha="$(capture_blob "$out" "$wt" 2>/dev/null)" || sha="(capture failed)"
  lines="$(wc -l <"$out" | tr -d ' ')"
  tail="$(grep -v '^[[:space:]]*$' "$out" | tail -n 1)"
  printf 'STEP %s FAILED: output blob %s (%s lines) inspect: git -C %s cat-file -p %s\n' \
    "$step" "$sha" "$lines" "$wt" "$sha"
  [ -n "$tail" ] && printf '  %s\n' "$tail"
  rm -f "$out"
  fail_steps+=("$step"); fail_cmds+=("$cmd"); fail_shas+=("$sha")
  failures=$((failures + 1))
  return 1
}

run_workspace_tests() {  # run_workspace_tests <test-step>
  # A root `test` script often uses `workspaces foreach`, whose fail-fast
  # behavior hides later red packages. List the workspaces and invoke each
  # package's own test script instead, accumulating their output into the usual
  # one-blob failure report.
  local step="$1" listing location workspace_pkg cmd out sha lines tail failed=0 found=0 i
  local override xst_bin=""
  local locations=() commands=()
  # An explicit command is defined to run in the project worktree, not once in
  # every package. Preserve that override contract.
  override="$(override_name "$step")"
  [ -n "${!override+x}" ] && return 2
  listing="$(cd "$wt" && $YARN workspaces list --json 2>/dev/null)" || return 2
  [ -n "$listing" ] || return 2

  while IFS= read -r location; do
    [ -n "$location" ] || continue
    [ "$location" = . ] && continue       # root test is commonly fail-fast aggregation
    workspace_pkg="$wt/$location/package.json"
    cmd="$(discover_in "$workspace_pkg" "$step")"
    [ -n "$cmd" ] || continue
    found=1
    locations+=("$location"); commands+=("$cmd")
  done < <(
    if command -v jq >/dev/null 2>&1; then
      printf '%s\n' "$listing" | jq -r '.location // empty'
    else
      printf '%s\n' "$listing" | node -e '
        let input = "";
        process.stdin.on("data", chunk => { input += chunk; });
        process.stdin.on("end", () => input.split(/\n/).filter(Boolean).forEach(line => {
          const workspace = JSON.parse(line);
          if (workspace.location) console.log(workspace.location);
        }));
      '
    fi
  )

  # A non-workspace project, or a runner that cannot list workspaces, retains
  # the ordinary root-package test behavior.
  if [ "$found" -eq 0 ]; then
    return 2
  fi

  out="$(mktemp "${TMPDIR:-/tmp}/local-verify-$step.XXXXXX")"
  if [ "$step" = test-xs ]; then
    if ! xst_bin="$(prepare_xs_environment 2>>"$out")"; then
      failed=1
    fi
  fi
  if [ "$failed" -eq 0 ]; then
    for i in "${!locations[@]}"; do
      location="${locations[$i]}"; cmd="${commands[$i]}"
      if ! { printf '[workspace %s]\n' "$location"; \
        ( cd "$wt/$location" && PATH="${xst_bin:+$xst_bin:}$PATH" bash -c "$cmd" ); \
      } >>"$out" 2>&1; then
        failed=1
      fi
    done
  fi
  if [ "$failed" -eq 0 ]; then
    rm -f "$out"
    return 0
  fi

  sha="$(capture_blob "$out" "$wt" 2>/dev/null)" || sha="(capture failed)"
  lines="$(wc -l <"$out" | tr -d ' ')"
  tail="$(grep -v '^[[:space:]]*$' "$out" | tail -n 1)"
  printf 'STEP %s FAILED: output blob %s (%s lines) inspect: git -C %s cat-file -p %s\n' \
    "$step" "$sha" "$lines" "$wt" "$sha"
  [ -n "$tail" ] && printf '  %s\n' "$tail"
  rm -f "$out"
  fail_steps+=("$step"); fail_cmds+=("<workspace $step>"); fail_shas+=("$sha")
  failures=$((failures + 1))
  return 1
}

for step in $STEPS; do
  if [ "$step" = test ] || [ "$step" = test-xs ]; then
    run_workspace_tests "$step"
    test_rc=$?
    # 2 means this is not a discoverable Yarn workspace tree; use the ordinary
    # root script in that case. A real workspace test failure (1) is already
    # captured and must not re-run the fail-fast root aggregator.
    if [ "$test_rc" -eq 2 ]; then
      run_step "$step" || true
    fi
  else
    run_step "$step" || true                 # run all steps; aggregate failures
  fi
done

# ── Environment fault vs check failure ──────────────────────────────────────
# N steps failing is normally N verification results. But when several steps that
# ran DIFFERENT commands all fail with byte-IDENTICAL output — the same capture
# blob — not one of them reached a check: something upstream of every command
# refused it. That is ONE environment fault, and reporting it as N failed
# verification steps sends the supervising agent hunting a defect in the change
# that is not there.
#
# The observed case is the warm-cache worktree (job
# `local-verify-parity-endo-but-for-bots-warm-cache`): a per-job checkout whose
# node_modules were hardlinked in from the cache had no package-manager link
# state, so yarn 4 refused every `yarn run <script>` with one usage error and all
# six steps "FAILED" with the same three-line blob. The cause is fixed in
# scripts/jobs/ensure-project-worktree.sh (§ Link-state reconcile), but the class
# is wider than that one bug — a missing runner, a noexec $TMPDIR, an
# unauthenticated registry, a corepack that cannot fetch — so the gate names the
# shape rather than any single instance.
#
# DISTINCT commands is the discriminator that keeps this from false-positiving.
# Two steps can legitimately resolve to the SAME script (`codegen` and `docs`
# both match `build:types` on a project without a dedicated generator), and that
# one script failing twice is one honest failure reported twice, not an
# environment fault. Identical output from different commands has no such benign
# reading.
report_environment_fault() {
  local n="${#fail_shas[@]}" uniq_shas uniq_cmds sha hint
  [ "$n" -ge 2 ] || return 0
  uniq_shas="$(printf '%s\n' "${fail_shas[@]}" | sort -u | wc -l | tr -d ' ')"
  uniq_cmds="$(printf '%s\n' "${fail_cmds[@]}" | sort -u | wc -l | tr -d ' ')"
  [ "$uniq_shas" = 1 ] && [ "$uniq_cmds" -ge 2 ] || return 0
  sha="${fail_shas[0]}"

  # Name the likeliest cause when the shared output carries a recognizable
  # runner-level signature. These are hints on top of the generic finding, never
  # the trigger for it: an unrecognized environment fault is still reported.
  # Read only the head of the shared blob: a runner-level refusal announces
  # itself immediately, and this must not pull a large log into memory.
  hint=""
  case "$(git -C "$wt" cat-file -p "$sha" 2>/dev/null | head -c 8192)" in
    *"doesn't seem to have been installed"*|*"has not been installed"*)
      hint="the package manager reports the project as NOT INSTALLED — this worktree has node_modules but no package-manager link state. A warm-cache checkout must run the link-state reconcile (scripts/jobs/ensure-project-worktree.sh § Link-state reconcile); re-run the install in the worktree to recover." ;;
    *"ermission denied"*)
      hint="a command was refused execution — the noexec \$TMPDIR divergence (skills/local-verify § Parity is the contract) or a lost +x bit, not a failing check." ;;
    *"command not found"*|*"No such file or directory"*)
      hint="the package runner itself is missing from PATH; set GARDEN_YARN or install the runner." ;;
  esac

  printf 'ENVIRONMENT FAULT: %s failing steps (%s) ran %s DIFFERENT commands yet produced IDENTICAL output (blob %s) — the runner or the environment is broken, NOT the change. inspect: git -C %s cat-file -p %s\n' \
    "$n" "${fail_steps[*]}" "$uniq_cmds" "$sha" "$wt" "$sha"
  [ -n "$hint" ] && printf '  %s\n' "$hint"
  return 0
}
report_environment_fault

# Codegen-then-clean gate: once every step has run (the codegen generators
# above especially), a worktree that became dirty means a checked-in generated
# artifact was STALE — a generator just regenerated it in-tree. Fail loud with a
# `git diff --stat` (plus the porcelain status, so a new untracked artifact is
# visible too), SHA-captured via capture_blob like any other failure so the raw
# diff never floods the supervising agent's context. This directly hardens
# against endojs/endo-but-for-bots#714: a rebase staled
# packages/agentry/src/execute/{git,fs}-types.js (regenerated by
# `yarn workspace @endo/agentry gen:code-mode-types`), silently red-lighting
# every CI test job after approval until the regen was committed.
dirty="$(git -C "$wt" status --porcelain 2>/dev/null)"
if [ -n "$dirty" ]; then
  out="$(mktemp "${TMPDIR:-/tmp}/local-verify-codegen-dirty.XXXXXX")"
  {
    printf '# git status --porcelain\n%s\n\n# git diff --stat\n' "$dirty"
    git -C "$wt" diff --stat
  } >"$out" 2>&1
  sha="$(capture_blob "$out" "$wt" 2>/dev/null)" || sha="(capture failed)"
  lines="$(wc -l <"$out" | tr -d ' ')"
  printf 'STEP codegen left tree dirty: generated artifacts are stale — commit the regen (diff --stat blob %s, %s lines) inspect: git -C %s cat-file -p %s\n' \
    "$sha" "$lines" "$wt" "$sha"
  rm -f "$out"
  failures=$((failures + 1))
fi

# Exit non-zero if any step failed, so the caller (the eval gate) can fail loud
# and hand the emitted SHAs to a debugging agent. Quiet and zero on full pass.
[ "$failures" -eq 0 ]
