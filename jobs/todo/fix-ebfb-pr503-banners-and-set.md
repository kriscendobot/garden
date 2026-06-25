# fix endojs/endo-but-for-bots PR #503 — banners (generally) + `set` perf

Map: **fix** → dispatch the fixer to address a maintainer CHANGES_REQUESTED review.

Repo: endojs/endo-but-for-bots
PR: #503 `feat/passable-byte-arrays` (DRAFT, CHANGES_REQUESTED)
Reviewed head SHA: `daaf8ffe1a5d20b5951b87d9bc5184b69126b60f`
Review: https://github.com/endojs/endo-but-for-bots/pull/503#pullrequestreview-4573212313

Standing authorization: endo-but-for-bots carries the standing comment
authorization (see `journal/projects/endo-but-for-bots/README.md`). Push to the
PR branch under the bot identity (no identity switch, bot-fork PR). Reply on
each inline thread and post the required top-level summary comment per
`skills/pr-completion-summary-comment/SKILL.md` and `roles/COMMON.md` §
Standing communication norm.

## Two inline comments to address

**1. Banners (apply generally).** `packages/bytes/test/main.test.js:265` (and
:254): the maintainer's house-style rule forbids banner horizontal rules in
comments ("inevitably inconsistent with a human maintainer in the loop"). This
is now encoded in the garden as `skills/no-comment-banners/SKILL.md` and gated
by the widened `no-ascii-banners` probe (landed on main2 2026-06-25). Apply it
**generally across this PR**: remove every banner horizontal-rule comment (a
comment line whose body is four or more repeated `-=*~_` characters and nothing
else: `// ----`, ` * ----`, `/* ---- */`) in the PR's changed files. When a
banner bracketed a section title, keep the title as a plain comment and delete
the rules. The ~40 occurrences at the reviewed SHA span:
  - packages/bytes/test/main.test.js (lines 254, 265)
  - packages/immutable-arraybuffer/src/lib.js (512, 514, 781, 783, 814, 816, 888, 890)
  - packages/immutable-arraybuffer/test/lib-typedarray.test.js
  - packages/immutable-arraybuffer/test/shim-typedarray-per-flavor.test.js
  - packages/immutable-arraybuffer/test/shim-typedarray.test.js
  - packages/pass-style/test/byteArray.test.js
Re-scan with `grep -rnE '^[[:space:]]*(//|#|\*)[[:space:]]*[-=*~_]{4,}[[:space:]]*$'`
plus the `/* ---- */` form, because line numbers will shift as you delete.

**2. `set` perf.** `packages/bytes/src/to-genuine.js:58`: "Use `set` to defer
the loop to higher performance native memcopy." This refines the `at`-based
element loop the prior round (`apply-503-feedback`, same SHA) deliberately
added. NOTE THE TENSION: that prior round found empirically that
`result.set(emulatedWrapper)` silently reads zeros, because the emulated frozen
`Uint8Array` wrapper has no integer-indexed own properties. So:
  - Reconcile the maintainer's directive against that finding **empirically in
    the actual code with the package test suite**, do not guess.
  - At minimum, the genuine fast path should defer to native `set` for the
    memcopy. Determine whether the maintainer intends a genuine view to be
    constructed over the immutable buffer's bytes (so `set` can do the native
    copy) for the emulated path too.
  - If `set` genuinely cannot serve the emulated-wrapper source, keep a correct
    fallback and **reply on the thread explaining why**, citing the prior
    empirical finding, so the maintainer can redirect. Correctness (the
    `@endo/bytes` ponyfills must behave identically on emulated wrappers, pinned
    by the tests) outranks the perf optimization.

## Definition of done
  - All banner-rule comments removed across the PR's changed files; tests still
    pass; the widened `no-ascii-banners` gate would now pass.
  - The `set` perf comment addressed (applied, or reasoned-and-replied if it
    breaks the emulated-path contract).
  - Package suites + `eslint` + `tsc` green locally; changeset current.
  - Inline reply on each of the two threads naming the addressing SHA; one
    top-level summary comment (head SHA, what changed mapped to each comment,
    what was declined and why, verification status).
  - Re-request review from `kriskowal` once CI is green.

Context: the garden-meta half of review 4573212313 ("reinforce the garden to
anticipate this feedback at generation and review") is already done on main2
(commit `bbed94e2`): new `skills/no-comment-banners/SKILL.md`, widened
`no-ascii-banners` probe, archivist + pedant review backstops, builder mention.
This job is the remaining "apply the feedback generally" half on the PR itself.
