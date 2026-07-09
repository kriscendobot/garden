---
gate: go-ahead
priority: normal
role: fixer
posted_by: gardener
posted_at: 2026-07-09T18:42:14Z
---

fixer job (endojs/endo-but-for-bots), GATED — do NOT run until the XS sqlite
bindings land. This is the "rebase trigger" kriskowal asked for in the PR #124
review (comment https://github.com/endojs/endo-but-for-bots/pull/124#discussion_r3548850250:
"move this PR to draft and add a trigger to rebase the PR when the necessary
sqlite bindings land"). PR #124 (head `slot-machine`, base `endor`) was moved to
draft and paused per the review body ("This work should be paused until the
underlying XS sqlite bindings are ready").

When promoted (maintainer/liaison promotes once the bindings are ready): rebase
`slot-machine` onto current `endor`, then apply the deferred PR #124 review code
fixes as one-concern-per-commit follow-ups (skills/review-feedback-followup-commits):

- .github/workflows/rust-endor.yml — rename the workflow file AND its inner job
  to simply `rust` (comment r3548775263); make the `on:` triggers match the other
  test workflows: all pull_request + push to the master branch (comment
  r3548779800); drive the three XS bundle builders (currently three `node
  scripts/bundle-*.mjs` steps) from a single `yarn`/`node --run` command backed by
  a package.json script, ideally with the build scripts implemented in JavaScript
  (comment r3548795579).
- packages/base64/src/decode.js line ~107 — restore type specificity: the cast
  was regressed to `/** @type {any} */`; restore the specific
  `/** @type {typeof Uint8Array.fromBase64} */` cast (comment r3548828631).
- packages/base64/src/encode.js line ~89 — restore specificity: the
  `nativeToBase64` type and the apply cast were reduced to `any`. A cast through
  `unknown` is fine but the type must be specific (comment r3548830908).
- packages/daemon/scripts/bundle-bus-worker-xs-ses-boot.mjs line ~34 (and the
  sibling bundle scripts) — prefer `new URL` path math over importing node
  `path`, per the Endo convention (comment r3548837460; see the standing
  garden-style job garden-style-url-not-path).
- packages/daemon/scripts/bundle-bus-worker-xs.mjs line ~57 — investigate WHY the
  `EXCLUDED_PACKAGES` filter is necessary: the bundler should GC unreferenced
  deps and only entrain the loaded module graph. Determine whether a static
  import in the daemon barrel entrains these Node-only/libp2p packages; then
  either document the reason in the comment or drop the filter if the bundler
  already collects them (comment r3548845562).
- designs/daemon-endor-pet-store-sqlite.md — replace hard-to-type code points
  (e.g. `→` arrows) per comment r3548802060 (see garden-style job
  garden-style-typist-codepoints).

Then reply on each thread citing the fix SHA and post a top-level summary
(skills/pr-review-thread-replies, pr-completion-summary-comment). Un-draft when
green.
