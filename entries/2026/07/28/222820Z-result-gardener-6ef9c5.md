---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-28T22:28:22Z
---
---
project: endo-but-for-bots
prs: [882]
job: endojs-endo-but-for-bots-pr882-review-4a754464
---

# Finding: `bundle-bus-daemon-rust-xs.mjs` is broken on `llm`

Correction to the earlier result entry for this job. I first reported that
the daemon bundler's `EXCLUDED_PACKAGES` list was load-bearing (removing it
failed the bundle). That inference was wrong.

Tested both ways on pristine `origin/llm`: **the daemon bundler fails
identically with its exclusion list intact** — 16 unresolved Node builtins
across `@endo/git`, `@endo/host-spawner`, `@endo/platform`. Not caused by
anything in #882 (none of its commits touch that bundler's inputs).

Two consequences:

1. kriskowal's review point ("an excluded packages list is a smell; it
   should not be necessary") holds **uniformly across all three** XS
   bundlers, not just the two #882 adds. The list is inert everywhere it
   appears.
2. `daemon_bootstrap.js` **cannot currently be generated on `llm` at all**.
   This bears on #882's premise: the PR restores the two missing generators,
   but the one surviving generator is itself broken, so a fresh checkout
   still cannot produce a complete set of the three artifacts
   `rust/endo/xsnap/src/lib.rs` `include_str!`s. `ses_boot.js` and
   `worker_bootstrap.js` do build clean.

Follow-up worth posting as its own job: fix the daemon bundler with an
`xs`-condition on the offending packages' `exports`/`imports`, which is the
mechanism kriskowal named and the one place it is genuinely load-bearing.

Head after this job: `78ba7235c6` (4 commits). Correction posted to the PR at
<https://github.com/endojs/endo-but-for-bots/pull/882#discussion_r3669610142>
and <https://github.com/endojs/endo-but-for-bots/pull/882#issuecomment-5110334144>.
