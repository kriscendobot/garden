---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-07-10T18:13:15Z
---
---
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/288
---

Ran the gauntlet on endojs/endo-but-for-bots PR #288 (`@endo/cbor-frame`), per kriskowal's "run the gauntlet" comment.

Two outcomes:

1. **CI fix (base-drift).** The branch was 92 commits behind `llm` and the `lint` job was red on `build:types:check`. Root cause was base-owned: `packages/daemon-cas/tsconfig.composite.json` (added to `llm` by #442) omitted the `@endo/platform` reference its package.json declares. Merged current `llm` (clean, no conflicts) and regenerated composite tsconfigs (head `9d8b2bdf1`); the matrix `lint` job is now green. Only the one regenerated `daemon-cas` composite rode into the PR diff.

2. **Closer review (kriskowal's 2026-07-04 request for a Fable close review).** A Fable agent re-read the head/decode/encode parser adversarially: no correctness or DoS bug found. Applied two follow-ups in head `8a4aad504`: copy the shared `TAG_24_PREFIX` singleton per frame in the chunked writer (harden cannot freeze a typed array's indexed elements, so handing the singleton by reference to an output stream was a shared-mutable hazard), and added the missing test for the reserved additional-info (28-30) rejection branch; plus a README note on overlong-head acceptance.

Verification: 34 cbor-frame tests pass (`ava`); `generate-composite-tsconfigs --check` clean; prettier + eslint clean on changed files; CI green except a `test-ocapn-guile-interop` codeberg.org 504 network flake (re-running). PR is already out of draft, in the maintainer's review queue.

Summary comment: https://github.com/endojs/endo-but-for-bots/pull/288#issuecomment-4938226379
