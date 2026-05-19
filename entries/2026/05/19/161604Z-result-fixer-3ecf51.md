---
ts: 2026-05-19T16:16:04Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

PR #75 (kriskowal-random-chacha12) round 3: addressed three kriskowal COMMENTED inline directives on `4d797a59d`.

**Commits** (applied directly on top of `origin/kriskowal-random-chacha12` at `365c26657`; no rebase needed, no conflicts):

- `a0d3ac8c2` `test(random): drop PR-citation tail from multiplier-test header (#75)` — stripped the "gibson042 r3245953732 and kriskowal r3263397803 on PR #75" sentence from the header block above the per-source multiplier tests. Recipe, bit-pattern reasoning, and brittleness-as-feature note retained. (Comment 3267597203 at `packages/random/test/random.test.js:64`.)
- `1f64e3be8` `refactor(random): back uint readers with a single shared ArrayBuffer (#75)` — replaced the five per-width `new Uint8Array(n)` allocations and four per-buffer `DataView` instances with one 8-byte `ArrayBuffer`, one shared `DataView`, and one zero-offset `Uint8Array` view per width. All views start at byte 0 so V8's element-kind specialization is unaffected (the prior comment's hazard was per-call `subarray`, not pre-allocated zero-offset views). Per-reader zero-out semantics unchanged. All 18 `packages/random/` tests pass on both `ses-ava` configs (`unsafe` and `endo`). (Comment 3267601608 at `packages/random/src/uint.js:38`.)
- `106c6ba8c` `bench(chacha12): drop ASCII section banners (#75)` — stripped all five `// ---` divider lines from `packages/chacha12/test/fill-random-bytes.bench.js`. The per-section heading comments already name each section's role; the banners were noise. Matches the disposition under PRs #109, #252, #288. (Comment 3267606213 at `packages/chacha12/test/fill-random-bytes.bench.js:192`.)

**Prettier**: `yarn lint:prettier --check` clean on the new tip (`106c6ba8c`).

**Lint**: `yarn lint` clean on `packages/random/` and `packages/chacha12/`.

**Push**: `106c6ba8c` pushed to `kriskowal-random-chacha12` (fast-forward from `365c26657`).

**Thread replies**: all three inline comment ids (3267597203, 3267601608, 3267606213) returned 404 on the `/replies` endpoint (REST index lag, same as round 2). Fell back to a single top-level summary mapping each id to its addressing SHA: `https://github.com/endojs/endo-but-for-bots/pull/75#issuecomment-4489742867`.

**Re-request**: `gh pr edit 75 --add-reviewer kriskowal` succeeded.

Self-improvement: nothing this time. The REST-index-lag fallback in `skills/pr-review-thread-replies/SKILL.md` § Pitfalls fit exactly; followed it as documented. The "consolidate into a single ArrayBuffer" directive needed care because the existing module-level comment had specifically argued against sharing a buffer; reading the comment closely showed the prior hazard was `subarray`-per-call and per-call view churn, not pre-allocated zero-offset views over a shared buffer, so the consolidation is safe and the comment was rewritten to reflect the new shape.
