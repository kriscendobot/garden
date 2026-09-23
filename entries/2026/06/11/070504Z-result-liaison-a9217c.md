---
ts: 2026-06-11T07:05:04Z
kind: result
role: liaison
dispatch: a9217c
host: endolin
model: opus-4-7-1m
---

# librarian cycle 298 — chat-lane — `garden/scripts/{dispatch-prepare,dispatch-teardown}.sh` (pair)

Cycle 298 (chat-lane after cycle 297 designs-lane WORKTREES.md). One source pair ingested: `garden/scripts/{dispatch-prepare,dispatch-teardown}.sh` (111 lines: 65 prepare + 46 teardown). **The third garden source ingested** — completes the design-to-implementation-bridge with cycle 297. Cycle 297 names the named-prepare-and-teardown-pair-shape; cycle 298 ingests the implementation.

## Library state

- 810 sections (up from 809 at cycle 297).
- 348 source documents (up from 347).
- §one-hundred-and-thirty-first consecutive designs-chat alternation cycles 166-250 + 252-298 (251 was out-of-band).
- **§three-cycles-with-garden-repo-source-ingest** (281 designs/driver.md + 297 WORKTREES.md + 298 scripts pair).
- **§the-named-three-shapes-of-garden-self-documentation** (proposed-design + standing-reference + implementation-source).

## Files written

- `library/sections/garden--scripts-dispatch-prepare-and-teardown-pair--implementation-of-cycle-297-named-prepare-and-teardown-pair-shape-and-set-euo-pipefail-discipline-and-stdout-as-return-value.md` (new section file; 111-line pair in full scope).
- `library/sources/garden--scripts-dispatch-prepare-and-teardown-pair.md` (new source page).
- `library/sections/README.md` (Total bumped 809 → 810; sources 347 → 348; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 66 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-297` → `pending-cycle-298`).

## First-explicit-observations (sixty-six)

Major: §the-named-prepare-and-teardown-script-pair-as-implementation-of-cycle-297's-named-pattern + §the-named-design-to-implementation-bridge across two cycles + §the-`set -euo pipefail`-named-strict-bash-discipline + §the-`echo "$ROOT"` stdout-as-named-return-value + §the-named-Unix-stdio-three-stream-discipline + §the-`exit 64`-for-usage-errors (named-sysexits.h-EX_USAGE) + §the-named-argument-count-validation (allow [2, 4]; disallow [0, 1, 3]) + §the-`openssl rand -hex 3`-for-6-hex-char-short-id (implementation matches cycle 297) + §the-named-canonical-script-location-discovery + §the-named-roll-back-on-failure + §the-named-actionable-error-message + §the-`rmdir ... || rm -rf` best-effort-cleanup-fallback + §the-named-search-bare-clones-for-the-project-worktree (§the-named-search-IS-the-named-no-sidecar-state; §the-named-state-vs-search-tradeoff) + §the-named-defensive-glob-handling + §two-named-shell-parameter-expansions + §the-named-Layout-comment-at-the-top + §the-named-Idempotent-cleanup-discipline + §the-named-fast-path-for-already-gone + §the-named-rationale-comment-naming-the-anti-pattern + §the-`>/dev/null 2>&1` quiet-execution-discipline + §the-named-`-C` vs `--git-dir` two-named-git-targeting-shapes + §the-named-no-shellcheck-suppressions.

## Multi-cycle pattern recognition

- **§three-cycles-with-garden-repo-source-ingest** — 281 (designs/driver.md, proposed-design) + 297 (WORKTREES.md, standing-reference) + 298 (scripts pair, implementation-source).
- **§the-named-three-shapes-of-garden-self-documentation** — proposed-design + standing-reference + implementation-source.
- **§the-named-design-to-implementation-bridge across two cycles** — cycle 297 names the contract; cycle 298 ingests the implementation.

## Synthesis target

Slot machine library `@game/scripts/{tournament-prepare,tournament-teardown}.sh`: `set -euo pipefail` + stdout-as-return-value + `exit 64` per sysexits.h + `openssl rand -hex 3` tournament-id + canonical-script-location-discovery + named-roll-back-on-failure + actionable-error-message + `rmdir || rm -rf` best-effort-cleanup + named-search-bare-clones (search-rather-than-store) + defensive-glob-handling + shell-parameter-expansion for owner/name split + Layout-comment at the top + idempotent-cleanup + fast-path-for-already-gone + rationale-comment naming the anti-pattern + `-C` vs `--git-dir` targeting.

## Single most structurally interesting move

**§the-named-search-bare-clones-for-the-project-worktree** combined with **§the-named-search-IS-the-named-no-sidecar-state** — teardown doesn't *know* which bare clone owns the project worktree. Rather than *store* that association in a sidecar file (which would require prepare to write a small JSON or text file and teardown to read it), the implementation **searches every bare clone in turn** by asking `git --git-dir="$bare" worktree list` and grepping for the dispatch's project path.

This IS the **named-state-vs-search tradeoff**: the simpler design (no sidecar state) at the cost of an O(N) search at teardown time. The pattern generalizes: any cleanup that needs to know "which resource owns this child" can either store the association at creation time (and risk staleness) or search at cleanup time (and risk O(N) cost). The named choice IS context-dependent. **§the-named-state-vs-search-tradeoff** as a named design dimension.

§the-named-implementation-makes-the-tradeoff-explicit: the comment in teardown explicitly names "We don't store which bare; ask each bare clone in turn." The choice IS visible in the code AND in the prose; the reader IS told *what was chosen* + *why* + *what was avoided*.

## Next cycle

Cycle 299 — designs-lane next.
