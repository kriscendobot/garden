---
title: "garden/scripts/{dispatch-prepare,dispatch-teardown}.sh — implementation of cycle 297's named-prepare-and-teardown-pair-shape; `set -euo pipefail` named-strict-bash-discipline; stdout-as-named-return-value with stderr-for-errors; named-roll-back-on-failure; named-search-bare-clones-for-the-project-worktree; named-`rmdir || rm -rf` best-effort-cleanup-fallback"
section-slug: garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value
source-slug: garden--scripts-dispatch-prepare-and-teardown-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/dispatch-prepare.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/{dispatch-prepare.sh, dispatch-teardown.sh}
total-lines: 111 (65 + 46)
ingest-cycle: 298
ingest-date: 2026-06-11
lane: chat
scope: full
---

# `garden/scripts/{dispatch-prepare,dispatch-teardown}.sh` (pair ingest)

A 65+46=111-line pair of bash scripts implementing **the named-prepare-and-teardown-pair-shape** that cycle 297's WORKTREES.md described. Cycle 297 *names* the scripts in prose; cycle 298 *ingests their source*. **§three-cycles-with-garden-repo-source-ingest** (281 + 297 + 298). **§the-named-implementation-companion-to-the-design**: the design (WORKTREES.md) and the implementation (these scripts) IS named as a pair via cycle 297's reference + cycle 298's source.

## Key moves

- **§the-named-prepare-and-teardown-script-pair as implementation of cycle 297's named pattern** (first-explicit-observation): cycle 297's WORKTREES.md named the scripts; cycle 298 ingests their source. **§the-named-design-to-implementation-bridge across two cycles**: the design names the contract (prepare creates + teardown removes; teardown IS idempotent; subagent never creates or removes worktrees itself); the scripts realize the contract.

§the-named-symmetric-script-pair: 65 lines (prepare) + 46 lines (teardown). §the-named-line-count-asymmetry (prepare > teardown by ~40%): creation IS more involved than removal because (1) creation has named-roll-back-on-failure logic, (2) teardown can tolerate missing pieces.

- **§the-`set -euo pipefail`-named-strict-bash-discipline** (first-explicit-observation):

```bash
set -euo pipefail
```

**§three-named-bash-strict-mode-options**: `-e` (exit-on-error) + `-u` (error-on-undefined-var) + `-o pipefail` (propagate-pipe-failure). **§the-named-strict-mode-IS-the-named-defensive-bash-discipline**.

§the-named-strict-mode-on-line-23-of-prepare + line-13-of-teardown: the strictness IS declared early, before any command runs.

- **§the-`echo "$ROOT"` stdout-as-named-return-value** (first-explicit-observation):

```bash
echo "$ROOT"
```

(last line of dispatch-prepare.sh)

**§the-named-stdout-IS-the-named-return-value-channel**: the script communicates its "return value" (the dispatch root path) via stdout. Caller uses `DISPATCH_ROOT=$(scripts/dispatch-prepare.sh ...)` to capture.

§the-named-stderr-for-errors-stdout-for-the-return-value: §the-named-two-stream-discipline. Error messages use `>&2`; the single named-return-value uses stdout. **§the-named-Unix-stdio-three-stream-discipline** (stdin not used here; stdout for return value; stderr for errors).

- **§the-`exit 64`-for-usage-errors** (first-explicit-observation):

```bash
if [ "$#" -lt 2 ] || [ "$#" -eq 3 ]; then
  echo "usage: $0 <role> <purpose-slug> [<owner>/<repo> <branch>]" >&2
  exit 64
fi
```

**§the-named-sysexits.h-EX_USAGE-IS-64**: standard Unix convention for "command line usage error" (defined in `/usr/include/sysexits.h`). **§the-named-canonical-exit-code-discipline**.

§the-named-distinct-exit-codes-IS-the-named-shell-script-API: `exit 0` (success) + `exit 64` (usage) + `exit 1` (runtime error). Caller can distinguish based on exit code.

- **§the-`if [ "$#" -lt 2 ] || [ "$#" -eq 3 ]`-named-argument-count-validation** (first-explicit-observation): allows 2 args (role + purpose) OR 4 args (role + purpose + owner/repo + branch). **Disallows 0, 1, 3, or 5+**. **§the-named-allow-list-via-OR-of-explicit-counts** (vs the typical "at least N" check).

§the-named-non-contiguous-allow-list: `[2, 4]` IS allowed but `[3]` IS not. §the-named-non-monotonic-arg-count-validation.

- **§the-`openssl rand -hex 3`-for-6-hex-char-short-id** (first-explicit-observation): three random bytes → six hex chars (16,777,216 values). **§the-named-implementation-matches-cycle-297's-named-`<short-id>`-IS-6-hex-chars**: cycle 297's WORKTREES.md named the format; cycle 298 reveals the implementation IS `openssl rand -hex 3`.

§the-named-cryptographically-secure-random-via-openssl: `openssl rand` IS preferred over `$RANDOM` (which IS predictable) when uniqueness across concurrent dispatchers matters.

- **§the-`GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"`-named-canonical-script-location-discovery** (first-explicit-observation):

```bash
GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
```

**§the-named-script-knows-where-it-IS**: `$(dirname "$0")` → script's directory; `/..` → script's parent (the garden root); `cd && pwd` → canonical absolute path. **§the-named-relative-to-script-location-discovery**.

§the-named-absolute-path-via-`cd && pwd`: handles symlinks, `.`, `..` correctly via the shell's `cd` resolution.

§the-named-portability-discipline: the script works regardless of where the caller invokes it from (CWD doesn't matter).

- **§the-named-roll-back-on-failure** (first-explicit-observation):

```bash
if [ ! -d "$BARE" ]; then
  echo "dispatch-prepare: bare clone not found at $BARE" >&2
  echo "                  clone first via: git clone --bare https://github.com/${REPO}.git $BARE" >&2
  # roll back partial state
  git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/garden"  >/dev/null 2>&1 || true
  git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/journal" >/dev/null 2>&1 || true
  rmdir "$ROOT" 2>/dev/null || rm -rf "$ROOT"
  exit 1
fi
```

**§the-named-roll-back-IS-the-named-atomicity-discipline**: if the bare clone IS missing, the script removes the *already-added* garden + journal worktrees + the dispatch root directory. **§the-named-all-or-nothing-creation-semantics**.

§the-named-tolerated-failures-via-`|| true`: the rollback uses `|| true` so a failure to remove a worktree doesn't fail the script's *error* path. §the-named-belt-and-suspenders-cleanup.

§the-named-actionable-error-message: "clone first via: git clone --bare https://github.com/${REPO}.git $BARE" — the error message *names the fix*, not just the problem. §the-named-error-with-named-remediation.

- **§the-`rmdir ... || rm -rf` best-effort-cleanup-fallback** (first-explicit-observation):

```bash
rmdir "$ROOT" 2>/dev/null || rm -rf "$ROOT"
```

**§the-named-safe-removal-with-fallback**: try `rmdir` (which fails on non-empty directory) FIRST; if that fails, escalate to `rm -rf`. **§the-named-prefer-safe-then-fall-back-to-forceful**.

§the-named-reasoning: if `worktree remove` succeeded, the directory IS empty + `rmdir` works; if anything was left behind (partial cleanup), `rm -rf` sweeps it. The order ensures the script *prefers* the safe-non-destructive option.

§the-named-anti-rm-rf-default-discipline: `rm -rf` IS the *fallback*, not the primary. §the-named-defaults-favor-safety.

- **§the-named-search-bare-clones-for-the-project-worktree** (first-explicit-observation):

```bash
if [ -e "$ROOT/project" ]; then
  for bare in "$GARDEN_ROOT"/worktrees/*.git; do
    [ -d "$bare" ] || continue
    if git --git-dir="$bare" worktree list 2>/dev/null | grep -q -F "$ROOT/project"; then
      git --git-dir="$bare" worktree remove --force "$ROOT/project" >/dev/null 2>&1 || true
      break
    fi
  done
fi
```

**§the-named-iterate-bare-clones-and-grep-pattern**: teardown doesn't *know* which bare clone owns the project worktree. **§the-named-search-rather-than-store-the-bare-association**.

§the-named-design-tradeoff: storing the bare clone's path in a sidecar file would let teardown directly target it (no search). The chosen design IS *search-instead-of-store* — simpler state but O(N) search through bare clones. **§the-named-search-IS-the-named-no-sidecar-state**.

§the-named-`[ -d "$bare" ] || continue` skip-if-not-a-directory: protects against the glob `*.git` matching nothing (which would leave the literal `*.git` as the only iteration). **§the-named-defensive-glob-handling**.

§the-named-`grep -q -F`-quiet-fixed-string-match: `-q` silences output (we only care about the exit code); `-F` IS fixed-string (no regex parsing of the path).

§the-named-`break`-after-finding-the-right-bare: first match wins.

- **§the-named-shell-parameter-expansion-for-OWNER-and-NAME** (first-explicit-observation):

```bash
OWNER=${REPO%/*}
NAME_=${REPO#*/}
```

**§two-named-shell-parameter-expansions**: `${VAR%/*}` (strip suffix from the right) + `${VAR#*/}` (strip prefix from the left). The combination splits `owner/repo` at the first `/`.

§the-named-`NAME_`-with-trailing-underscore-to-avoid-clash-with-the-prior-`NAME`-variable: line 36 sets `NAME="${ROLE}--${PURPOSE}--..."`; line 51 needs a different name. **§the-named-underscore-suffix-for-name-disambiguation**.

§the-named-portable-no-`cut`-no-`awk`-via-shell-parameter-expansion: builtin shell expansion IS faster + no external command spawn.

- **§the-named-Layout-comment-at-the-top** (first-explicit-observation):

```bash
# Layout:
#   dispatches/<role>--<purpose>--<UTC-YYYYMMDD-HHMMSS>--<short-id>/
#     garden/    detached worktree of the garden's `main` branch
#     journal/   detached worktree of the garden's `journal` branch
#     project/   (only when a project repo is named) detached worktree of
#                worktrees/<owner>-<repo>.git at <branch>
```

**§the-named-Layout-comment-IS-the-named-self-documentation-of-the-directory-structure-created**. The reader doesn't need to read the code to know what gets created; the header comment names it. §the-named-comment-IS-the-named-spec-at-the-top.

§the-named-detached-HEAD-noted-at-the-top: "All three worktrees are checked out in detached-HEAD..."

- **§the-named-Idempotent-cleanup-discipline** (first-explicit-observation): the teardown script *explicitly names itself idempotent*:

```bash
# Removes garden/, journal/, and (if present) project/ worktrees and the
# dispatch root directory itself. Idempotent: missing pieces are tolerated.
```

**§the-named-idempotent-discipline IS named in the doc-comment + realized in the code**. Each removal IS conditional (`[ -e "$ROOT/garden" ] && ...`) and uses `|| true` to tolerate failures.

§the-named-idempotency-IS-the-named-precondition-for-retry-safety: a teardown that crashes partway IS safe to re-run.

- **§the-`[ ! -d "$ROOT" ]`-named-fast-path-for-already-gone** (first-explicit-observation):

```bash
if [ ! -d "$ROOT" ]; then
  echo "dispatch-teardown: $ROOT does not exist; nothing to do" >&2
  exit 0
fi
```

**§the-named-fast-path-exit-with-named-message**: if the dispatch root IS already gone, exit immediately with `exit 0` (success) + a stderr message. **§the-named-success-exit-with-explanation**.

§the-named-already-done-IS-not-an-error: a teardown that finds nothing to teardown succeeds. §the-named-idempotent-success-shape.

- **§the-named-rationale-comment-naming-the-anti-pattern** (first-explicit-observation):

```bash
# `git worktree remove` is preferred over `rm -rf` because git tracks
# each worktree in its admin tree; a bare rm would leak that entry and
# require a follow-up `git worktree prune`.
```

**§the-named-anti-pattern-rationale-in-the-comment**: the doc-comment names *what NOT to do* AND *why*. **§the-named-rationale-IS-the-named-future-reader's-warning**.

§the-named-`git worktree prune`-IS-named-as-the-recovery-from-the-anti-pattern: a future reader who skips the comment + does `rm -rf` IS told via the comment that the fix IS `git worktree prune`.

- **§the-`>/dev/null 2>&1` quiet-execution-discipline** (first-explicit-observation):

```bash
git -C "$GARDEN_ROOT" worktree add --detach "$ROOT/garden"  main    >/dev/null
git -C "$GARDEN_ROOT" worktree remove --force "$ROOT/garden"  >/dev/null 2>&1 || true
```

**§the-named-`>/dev/null` for-normal-output-suppression**. **§the-named-`>/dev/null 2>&1` for-both-stdout-and-stderr-suppression** (in error-tolerant paths where we don't want the failure message to surface).

§the-named-distinct-quiet-levels: normal command (`>/dev/null` only) vs error-tolerant command (`>/dev/null 2>&1 || true`). The error-tolerant form suppresses BOTH streams + suppresses the exit code via `|| true`.

- **§the-named-`-C "$GARDEN_ROOT"`-vs-`--git-dir="$BARE"` two-named-git-targeting-shapes** (first-explicit-observation):

```bash
git -C "$GARDEN_ROOT" worktree add --detach "$ROOT/garden" main
git --git-dir="$BARE" worktree add --detach "$ROOT/project" "$BRANCH"
```

**§two-named-git-targeting-mechanisms**: `-C <dir>` (change directory before running git) + `--git-dir=<dir>` (use this directory as the git admin tree). **§the-named-distinction**: garden + journal are *checked-out worktrees* (so `-C` works); the bare clone IS an *admin-only tree* with no working tree (so `--git-dir` IS the right mechanism).

§the-named-shape-determines-the-targeting-mechanism: working-tree → `-C`; bare → `--git-dir`.

- **§the-named-comment-explaining-the-design** (first-explicit-observation):

```bash
# Garden + journal worktrees both come from the garden repo's admin tree
# at $GARDEN_ROOT/.git. `git worktree add --detach <path> <ref>` puts the
# new worktree at the named ref in detached-HEAD state.
```

**§the-named-inline-comment-explains-the-implementation-decision**: rather than expecting the reader to know `worktree add --detach` semantics, the comment names them.

§the-named-comments-IS-the-named-pedagogy-discipline-in-scripts.

## §the-named-no-shellcheck-suppressions reaffirmed (first-explicit-observation in this script)

Neither script has any `# shellcheck disable=` comments. **§the-named-clean-shellcheck-script-discipline**: the scripts pass shellcheck without suppressions, naming the discipline by its *absence of opt-out markers*.

## §the-named-line-count-asymmetry-explained (first-explicit-observation)

Prepare IS 65 lines; teardown IS 46 lines. **§the-named-asymmetry-IS-the-named-rollback-overhead**: prepare has named-roll-back-on-failure code that teardown doesn't need (because teardown's "rollback" IS just exiting; nothing to undo).

§the-named-line-count-IS-NOT-the-substance (extends cycle 288's §the-line-count-IS-NOT-the-substance observation): here the line count *does* reflect substance — prepare has more responsibilities (rollback + bare-clone-check).

## Patterns from prior cycles, reaffirmed

- **§three-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md + 298 scripts/dispatch-{prepare,teardown}.sh).
- **§the-named-prepare-and-teardown-pair-shape** (cycle 297 design + cycle 298 implementation).
- **§the-named-design-to-implementation-bridge across two cycles** (sibling-pattern to cycles 280+282+284's three-cycles-closing-the-zip-cluster-source-loop).

## Borrowing tiers

- **Tier 1 (direct, exact-shape)**: §the-named-prepare-and-teardown-script-pair + §the-named-design-to-implementation-bridge + §the-named-symmetric-script-pair-with-asymmetric-line-counts + §the-`set -euo pipefail`-named-strict-bash-discipline + §three-named-bash-strict-mode-options + §the-named-strict-mode-IS-the-named-defensive-bash-discipline + §the-`echo "$ROOT"` stdout-as-named-return-value + §the-named-stderr-for-errors-stdout-for-the-return-value + §the-named-Unix-stdio-three-stream-discipline + §the-`exit 64`-for-usage-errors + §the-named-sysexits.h-EX_USAGE-IS-64 + §the-named-canonical-exit-code-discipline + §the-named-distinct-exit-codes-IS-the-named-shell-script-API + §the-`if [ "$#" -lt 2 ] || [ "$#" -eq 3 ]`-named-argument-count-validation + §the-named-allow-list-via-OR-of-explicit-counts + §the-named-non-contiguous-allow-list + §the-`openssl rand -hex 3`-for-6-hex-char-short-id + §the-named-implementation-matches-cycle-297's-named-`<short-id>`-IS-6-hex-chars + §the-named-cryptographically-secure-random-via-openssl + §the-`GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"`-named-canonical-script-location-discovery + §the-named-script-knows-where-it-IS + §the-named-absolute-path-via-`cd && pwd` + §the-named-portability-discipline + §the-named-roll-back-on-failure + §the-named-roll-back-IS-the-named-atomicity-discipline + §the-named-all-or-nothing-creation-semantics + §the-named-tolerated-failures-via-`|| true` + §the-named-actionable-error-message + §the-named-error-with-named-remediation + §the-`rmdir ... || rm -rf` best-effort-cleanup-fallback + §the-named-safe-removal-with-fallback + §the-named-prefer-safe-then-fall-back-to-forceful + §the-named-anti-rm-rf-default-discipline + §the-named-defaults-favor-safety + §the-named-search-bare-clones-for-the-project-worktree + §the-named-iterate-bare-clones-and-grep-pattern + §the-named-search-rather-than-store-the-bare-association + §the-named-search-IS-the-named-no-sidecar-state + §the-named-`[ -d "$bare" ] || continue` skip-if-not-a-directory + §the-named-defensive-glob-handling + §the-named-`grep -q -F`-quiet-fixed-string-match + §the-named-`break`-after-finding-the-right-bare + §two-named-shell-parameter-expansions (`${VAR%/*}` + `${VAR#*/}`) + §the-named-`NAME_`-with-trailing-underscore-to-avoid-clash + §the-named-underscore-suffix-for-name-disambiguation + §the-named-portable-no-`cut`-no-`awk`-via-shell-parameter-expansion + §the-named-Layout-comment-at-the-top + §the-named-comment-IS-the-named-spec-at-the-top + §the-named-detached-HEAD-noted-at-the-top + §the-named-Idempotent-cleanup-discipline + §the-named-idempotency-IS-the-named-precondition-for-retry-safety + §the-`[ ! -d "$ROOT" ]`-named-fast-path-for-already-gone + §the-named-fast-path-exit-with-named-message + §the-named-success-exit-with-explanation + §the-named-already-done-IS-not-an-error + §the-named-rationale-comment-naming-the-anti-pattern + §the-named-anti-pattern-rationale-in-the-comment + §the-named-`git worktree prune`-IS-named-as-the-recovery-from-the-anti-pattern + §the-`>/dev/null 2>&1` quiet-execution-discipline + §the-named-`>/dev/null` for-normal-output-suppression + §the-named-distinct-quiet-levels + §the-named-`-C "$GARDEN_ROOT"`-vs-`--git-dir="$BARE"` two-named-git-targeting-shapes + §the-named-distinction-shape-determines-the-targeting-mechanism + §the-named-inline-comment-explains-the-implementation-decision + §the-named-no-shellcheck-suppressions + §the-named-clean-shellcheck-script-discipline + §the-named-line-count-asymmetry-explained + §the-named-asymmetry-IS-the-named-rollback-overhead — all sixty-six first-explicit-observations.
- **Tier 2 (clear analogue, named-shape)**: §three-cycles-with-garden-repo-source-ingest (281 + 297 + 298) + §the-named-design-to-implementation-bridge across two cycles + §the-named-line-count-IS-NOT-the-substance reaffirmed and refined.
- **Tier 3 (multi-cycle pattern recognition)**: §the-garden-IS-named-as-its-own-named-source + §the-named-three-shapes-of-garden-self-documentation (proposed-design 281 + standing-reference 297 + implementation-source 298).

## Synthesis target

Slot machine library `@game/scripts/{tournament-prepare,tournament-teardown}.sh`: `set -euo pipefail` strict-mode; stdout-as-return-value with stderr-for-errors; `exit 64` for usage errors per sysexits.h; `openssl rand -hex 3` for 6-hex-char tournament-id; `$(cd "$(dirname "$0")/.." && pwd)` for canonical-script-location-discovery; named-roll-back-on-failure if the game-fork bare clone IS missing; actionable-error-message naming the fix ("clone first via:..."); `rmdir || rm -rf` best-effort-cleanup; named-search-bare-clones for the game-table worktree (search-rather-than-store); defensive-glob-handling via `[ -d "$bare" ] || continue`; shell-parameter-expansion (`${REPO%/*}` + `${REPO#*/}`) for owner-and-name-split; Layout-comment at the top; idempotent-cleanup discipline; fast-path-for-already-gone; rationale-comment naming the anti-pattern (`rm -rf` would leak git's worktree admin); `-C` vs `--git-dir` targeting based on whether the repo IS checked-out or bare.

## Single most structurally interesting move

**§the-named-search-bare-clones-for-the-project-worktree** combined with **§the-named-search-IS-the-named-no-sidecar-state** — teardown doesn't *know* which bare clone owns the project worktree. Rather than *store* that association in a sidecar file (which would require prepare to write a small JSON or text file and teardown to read it), the implementation **searches every bare clone in turn** by asking `git --git-dir="$bare" worktree list` and grepping for the dispatch's project path.

This IS the **named-state-vs-search tradeoff**: the simpler design (no sidecar state) at the cost of an O(N) search at teardown time, where N IS the number of bare clones (typically a handful). The named tradeoff IS *fewer files-to-keep-consistent* vs *more-work-at-teardown*.

The pattern generalizes: any cleanup that needs to know "which resource owns this child" can either store the association at creation time (and risk staleness) or search at cleanup time (and risk O(N) cost). The named choice IS context-dependent. **§the-named-state-vs-search-tradeoff** as a named design dimension.

§the-named-implementation-makes-the-tradeoff-explicit: the comment in teardown explicitly names "We don't store which bare; ask each bare clone in turn." The choice IS visible in the code AND in the prose; the reader IS told *what was chosen* + *why* + *what was avoided*.
