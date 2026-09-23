---
ts: 2026-05-20T03:54:41Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/fixer--b2141e/project
---

Cleared the two `lint` warnings the post-rebase CI on PR #75
treated as errors.

**Findings (yarn lint output, file:line):**

- `packages/evasive-transform/src/index.js:25:1` —
  `jsdoc/check-alignment`: line 25 (continuation of the
  `onlyComments` `@property` description) lacks a leading `*`
  and the line 26 `@property` begins with a single `*` with
  no leading space, breaking block alignment with the
  surrounding ` * ...` lines.
- `packages/ses/src/compartment.js:340:3` —
  `jsdoc/require-param`: the function `Compartment(...args)`
  has two adjacent JSDoc blocks above it. The earlier block
  declares `@param ...args`; the later block declares only
  `@this {Compartment}`. The rule attaches only the
  immediately-preceding block to the function, so `args` reads
  as missing.

**Fix disposition:**

- `evasive-transform/src/index.js`: `yarn lint --fix` produced
  a clean, single-character realignment (added the missing
  leading ` ` before the `*` on line 26). Accepted as-is.
- `ses/src/compartment.js`: `yarn lint --fix` over-reached. It
  kept both JSDoc blocks separate and synthesized a second
  `@param {...any} args` in the `@this` block, widening the
  declared type from
  `...CompartmentOptionsArgs|LegacyCompartmentOptionsArgs` to
  `any`. Reverted the auto-fix and merged the two blocks by
  hand into one: kept the original typed `@param`, moved
  `@this {Compartment}` into the same block, dropped the
  redundant second block.

**Commit:** `82c16b62a` (`style: clear two jsdoc lint warnings
exposed in PR #75 CI`).

**Push:** `git push origin HEAD:kriskowal-random-chacha12`
succeeded (`e8fa0ec7a..82c16b62a`). The first push attempt
hit non-fast-forward because the remote had advanced (new
PR-#75 fix-up commits had landed after dispatch-prepare
captured the worktree); fetched, rebased my one commit onto
`origin/kriskowal-random-chacha12` (24 of my pre-existing
commits were skipped as previously-applied cherry-picks),
re-ran `yarn lint` to confirm both warnings still resolved
on the new base, then re-pushed.

**Pre-push gate** (`pre-push-gates.sh` from `project/`,
default mode): stages 1 (`yarn format`) and 2 (`yarn lint
--fix`) both passed clean after my edits. Stage 3 probes
reported four findings — `no-inline-import-jsdoc` on
`packages/evasive-transform/src/index.js:23,26` (pre-existing
inline `import('...').X` JSDoc; my fix only realigned the `*`
on line 26 and did not touch the `import()` body),
`security-md-hash-uniform` (whole-repo divergent SECURITY.md
hashes across `packages/{immutable-arraybuffer,bytes,chacha12,
hex,random,panic}`), `sentence-per-line-md` (multi-sentence
lines in `AGENTS.md`, `packages/chacha12-fast-check-test/
SECURITY.md`, `packages/chacha12/BENCH.md`, etc.), and
`test-package-no-main` (`packages/chacha12-fast-check-test/
package.json` exports). All four are pre-existing repo-wide
items on paths the dispatch did not touch and are explicitly
out of scope per the dispatch brief's "diff-only scoping"
note. Stage 4 (`yarn typecheck`) skipped (no script).

**External-repo etiquette:** no comments, reviews, reactjis,
or re-request-review actions taken; the dispatch did not stage
any of those authorizations and the fix is a deterministic
lint-clean shaped like a CI follow-up. The steward picks up
the surface from here.

Self-improvement: nothing this time. The two warnings were
narrowly diagnostic; the `yarn lint --fix` shape (auto-fix
first, inspect diff, accept-or-revert-and-redo) carried the
work without surfacing a gap. The `no-inline-import-jsdoc`
probe firing on a file whose changed lines do not include
the `import()` is the same diff-vs-paths false positive
already noted in `034105Z-result-fixer-bf52b3.md`; not new.
