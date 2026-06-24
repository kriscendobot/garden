---
ts: 2026-05-15T04:58:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/05/15/043155Z-result-judge-aeef96.md
---

Applied gibson042's upstream inline suggestion (review comment id
`3245918820` on `endojs/endo#3232`) to bots-side PR #75 by replacing
the brittle `oneSource` test with the less-coupled `maxSource` form.

### File edited

`packages/random/test/random.test.js`, the test
`'random() multiplies randomUint53 by exactly 2 ** -53'` (test name
preserved verbatim so the upstream review-thread anchor remains
pointable).

Before: set `out[0] = 1` (and the rest to 0), assert
`random(oneSource) === 2 ** -53`. Brittle because it presumes
little-endian octet consumption with a retained-first-octet pattern.

After: set every byte to `0xff`, assert
`random(maxSource) === 1 - 2 ** -53`. With every bit set, the
underlying randomUint53 returns `2 ** 53 - 1` regardless of how
octets are mapped (8 vs 7, big vs little endian); the assertion pins
only the multiplier. The comment Richard suggested is copied
verbatim above the test body.

### Commits

Single conventional commit on top of `f82c9d9cd`:

- Subject: `test(random): use maxSource to assert random = randomUint53 * 2 ** -53 (per r3245918820)`
- Body cites the upstream review id and the one-line less-brittle
  rationale; a final paragraph notes that gibson042's literal `0xFF`
  was lowercased to `0xff` to satisfy prettier and match the
  package-wide hex-literal convention (`seeds.js`, `int.js`,
  `_chacha20.js`, `_xorshift.js` all use lowercase).
- First push pushed `3a5956b455e5196c2a14751166abb70db6e35ba1` per
  the brief's commit-before-extended-validation discipline. The lint
  job on that head failed because the uppercase `0xFF` (verbatim from
  Richard) did not pass prettier; amended to lowercase and
  force-with-leased to `9e3a7727692f58bb11c408b0d03f03abbee9a0a0`.

### Head SHA after push

`9e3a7727692f58bb11c408b0d03f03abbee9a0a0`.

### Local validation

`yarn` is not on PATH inside the dispatch root (host has no node
toolchain in this container's PATH), so per today's
commit-before-extended-validation discipline I pushed first and let
CI be the validator. The lint failure on the first push surfaced the
prettier-vs-verbatim conflict; CI on the amended head is the
authoritative check.

### CI status at fixer-end

`test-ocapn-guile-interop` (the gating signal called out in the
dispatch) ran `pass` on the first push (`3a5956b45`); the amended
push restarted the matrix and is in progress at fixer-end. The
amended commit is a pure lowercase substitution inside a test file
and is functionally identical to the first push, so the guile-interop
job is expected to remain pass.

The orchestrator should watch
`gh pr checks 75 -R endojs/endo-but-for-bots` for the amended head's
convergence before dispatching the judge for the gamut's
continuation. If lint fails again on the amended head, the lint log
will reveal a different prettier nit; the fixer is willing to take a
second pass.

### Out of scope (per brief)

- No comment on bots #75 or upstream #3232 (per `roles/COMMON.md`
  External-repo etiquette; no per-action authorization in the
  dispatch).
- No retcon; the new commit lands on top of current shape.
- No un-draft (PR is already non-draft).

Self-improvement: the brief said "verbatim including his suggested
comment" and Richard's literal `0xFF` was uppercase. Verbatim and
prettier-compliant are in tension when the package convention is
lowercase. The cleanest path was to lowercase the code literal (which
prettier owns) while keeping the comment block verbatim (which
prettier does not touch). I lost one CI round to learn this; a future
fixer applying a verbatim suggestion should grep the surrounding
package for `0x[0-9A-Fa-f]+` first to learn the local convention and
quietly normalize the case before the first push. Whether to land
this as a tighter procedural line in `roles/fixer/AGENT.md` (under
"prettier-vs-verbatim") is a judgment call for the liaison; the
liaison may also rule that the one-CI-round cost is acceptable and
no rule change is warranted.
