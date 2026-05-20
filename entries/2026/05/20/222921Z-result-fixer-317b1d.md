---
ts: 2026-05-20T22:29:21Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Addressed kriskowal CHANGES_REQUESTED review on PR #329 (`docs: introduce
spackle, the polyfill+ponyfill race pattern`, branch `docs/spackle`). All six
inline asks landed in one commit on `docs/spackle.md`.

Commit: `edb1b06f6` `docs(spackle): address kriskowal review on #329`. Pushed
to `origin docs/spackle` (398eb22c4..edb1b06f6).

Per-ask disposition:

| comment id | ask | disposition | reply id |
|---|---|---|---|
| 3277500246 | Title: "Eval twins" | renamed `## Why a new pattern` to `## Eval twins` | 3277554105 |
| 3277502993 | "structure or convention" | swapped "merely on convention" → "merely on structure or convention" | 3277554168 |
| 3277506991 | seminal citations | added Remy Sharp (2010) for "polyfill" and Sindre Sorhus (2014) for "ponyfill"; noted "shim" as a general systems-software term predating the JavaScript usage | 3277554226 |
| 3277512162 | "Omit." | dropped the "the package's README describes ... this section describes ..." framing under `## How @endo/harden uses spackle` | 3277554278 |
| 3277519775 | "Also presences." | extended `## Forthcoming: @endo/eventual-send` to cover presences alongside non-native promises | 3277554339 |
| 3277526788 | add conclusion | added `## Conclusion` with the supplied text, sentence-per-line wrapped | 3277554428 |

Pre-push gates: the two probes relevant to a single-`.md` diff
(`no-ascii-banners`, `sentence-per-line-md`) ran on the staged diff and
passed; the other five probes (`filename-no-stutter`, `no-pull-citations`,
`no-inline-import-jsdoc`, `test-package-no-main`,
`security-md-hash-uniform`) do not apply to a docs-only diff and their
whole-tree findings reflect pre-existing repo state unrelated to PR #329.

Did not re-request review (per fixer norms, that step is post-CI-green and
the dispatch did not authorize a top-level summary comment beyond the
threaded replies); leaving review re-request to the orchestrator's next
dispatch.

Self-improvement: nothing this time.
