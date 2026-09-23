---
title: "garden/scripts/{dispatch-prepare,dispatch-teardown}.sh — implementation of cycle 297's named-prepare-and-teardown-pair-shape"
source-slug: garden--scripts-dispatch-prepare-and-teardown-pair
url: https://github.com/kriskowal/garden/blob/main/scripts/dispatch-prepare.sh
authors: [Endo project (collective; the garden's named-role-as-author convention)]
repo: kriskowal/garden
path: scripts/{dispatch-prepare.sh, dispatch-teardown.sh}
total-lines: 111 (65 + 46)
ingest-cycle: 298
ingest-date: 2026-06-11
lane: chat
---

# `garden/scripts/{dispatch-prepare,dispatch-teardown}.sh`

A 65+46=111-line bash script pair implementing cycle 297's named-prepare-and-teardown-pair-shape. Cycle 297's WORKTREES.md names the contract; cycle 298 ingests the source. **§three-cycles-with-garden-repo-source-ingest** (281 + 297 + 298).

## Key moves

- **§the-named-prepare-and-teardown-script-pair as implementation of cycle 297's named pattern** — the-named-design-to-implementation-bridge across two cycles.
- **§the-named-symmetric-script-pair-with-asymmetric-line-counts** — prepare 65 lines + teardown 46 lines; the-named-asymmetry-IS-the-named-rollback-overhead.
- **§the-`set -euo pipefail`-named-strict-bash-discipline** — three-named-bash-strict-mode-options.
- **§the-`echo "$ROOT"` stdout-as-named-return-value** — the-named-stdout-IS-the-named-return-value-channel; the-named-Unix-stdio-three-stream-discipline (stdout for return + stderr for errors).
- **§the-`exit 64`-for-usage-errors** — the-named-sysexits.h-EX_USAGE-IS-64; the-named-canonical-exit-code-discipline.
- **§the-`if [ "$#" -lt 2 ] || [ "$#" -eq 3 ]`-named-argument-count-validation** — the-named-allow-list-via-OR-of-explicit-counts (allow [2, 4]; disallow [0, 1, 3]).
- **§the-`openssl rand -hex 3`-for-6-hex-char-short-id** — implementation-matches-cycle-297's-named-`<short-id>`-IS-6-hex-chars; the-named-cryptographically-secure-random-via-openssl.
- **§the-`GARDEN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"`-named-canonical-script-location-discovery** — the-named-script-knows-where-it-IS; the-named-portability-discipline.
- **§the-named-roll-back-on-failure** — if the bare clone IS missing, prepare removes the already-added worktrees; the-named-all-or-nothing-creation-semantics.
- **§the-named-actionable-error-message** — names the fix ("clone first via: git clone --bare https://github.com/${REPO}.git $BARE"); the-named-error-with-named-remediation.
- **§the-`rmdir ... || rm -rf` best-effort-cleanup-fallback** — the-named-prefer-safe-then-fall-back-to-forceful; the-named-anti-rm-rf-default-discipline.
- **§the-named-search-bare-clones-for-the-project-worktree** — the-named-iterate-bare-clones-and-grep-pattern; the-named-search-rather-than-store-the-bare-association; §the-named-state-vs-search-tradeoff.
- **§the-named-defensive-glob-handling** — `[ -d "$bare" ] || continue`; protects against `*.git` matching nothing.
- **§two-named-shell-parameter-expansions** — `${REPO%/*}` (strip suffix from right) + `${REPO#*/}` (strip prefix from left); the-named-portable-no-`cut`-no-`awk`-via-shell-parameter-expansion.
- **§the-named-`NAME_`-with-trailing-underscore-to-avoid-clash** — disambiguates from the prior `NAME` variable.
- **§the-named-Layout-comment-at-the-top** — the-named-self-documentation-of-the-directory-structure-created; the-named-detached-HEAD-noted-at-the-top.
- **§the-named-Idempotent-cleanup-discipline** — named explicitly in the doc-comment AND realized in the code; the-named-idempotency-IS-the-named-precondition-for-retry-safety.
- **§the-`[ ! -d "$ROOT" ]`-named-fast-path-for-already-gone** — exit 0 (success) + stderr message; the-named-already-done-IS-not-an-error.
- **§the-named-rationale-comment-naming-the-anti-pattern** — `# git worktree remove is preferred over rm -rf because git tracks each worktree in its admin tree; a bare rm would leak that entry and require a follow-up git worktree prune`.
- **§the-`>/dev/null 2>&1` quiet-execution-discipline** — the-named-distinct-quiet-levels (normal `>/dev/null` vs error-tolerant `>/dev/null 2>&1 || true`).
- **§the-named-`-C "$GARDEN_ROOT"`-vs-`--git-dir="$BARE"` two-named-git-targeting-shapes** — `-C` for working-tree + `--git-dir` for bare; the-named-shape-determines-the-targeting-mechanism.
- **§the-named-no-shellcheck-suppressions** — the-named-clean-shellcheck-script-discipline.

## Section files

- [§implementation-of-cycle-297-named-prepare-and-teardown-pair-shape + §set-euo-pipefail-discipline + §stdout-as-return-value + 60 more first-explicit-observations](../sections/garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value.md) — full 111-line pair in scope.

## Ingest scope

Cycle 298 (chat-lane after cycle 297 designs-lane WORKTREES.md). Full 111-line pair (65 prepare + 46 teardown) in scope. **First-explicit-observations (sixty-six)** at full scope, completing the design-to-implementation bridge with cycle 297.
