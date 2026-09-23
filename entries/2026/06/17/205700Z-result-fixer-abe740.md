---
ts: 2026-06-17T20:57:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/205500Z-dispatch-fixer-abe740.md
---

# Result: add Moddable XS row to immutable-arraybuffer support table (fixer--abe740)

## What landed

- New branch `docs/immutable-arraybuffer-xs-row` based on the frozen `master-4a04d07`.
- One commit, `1047add92` (`docs(immutable-arraybuffer): add Moddable XS row to support table per phoddie info`).
- Adds a Moddable XS row to the Engines table in `packages/immutable-arraybuffer/README.md` § Platform support for `transferToImmutable`, alongside V8 / SpiderMonkey / JavaScriptCore / Hermes.
- Extends the legend paragraph with a fourth status, `native transferToImmutable`, since XS is unique in the table for shipping the proposed method itself rather than only the `transfer` or `structuredClone` primitives the shim falls back on.
- Adds a short paragraph after the table noting XS is the only entry shipping the proposed method natively and that the XS dates are approximate.

## XS row data

| Cell | Value | Provenance |
| --- | --- | --- |
| First version with `structuredClone` | approximately 2022 | @phoddie on PR #435: "structureClone was 4 years back, according to Git" |
| First version with `ArrayBuffer.prototype.transfer` | approximately 2023 (at the Immutable ArrayBuffer proposal's Stage 1) | @phoddie on PR #435: "Immutable stuff was when we got Stage 1" |
| Status as of shipping today | **native `transferToImmutable`** | @phoddie on PR #435: XS ships `ArrayBuffer.prototype.transferToImmutable()` itself |

@erights' authorization (`r3427486065`) included "It is ok if approximate", which the row honors explicitly with the word "approximately" in each cell.

## XS is not in the Runtimes-and-browsers table

XS on Moddable functions as both engine and runtime on embedded targets, so the Engines table is the right home. Adding a duplicate row to the runtimes table would either repeat the engine-table content or imply a distinction (host date vs. engine date) that does not exist for XS. The commit message and PR body both call this choice out.

## PR

- Number: **#451**.
- URL: https://github.com/endojs/endo-but-for-bots/pull/451.
- Head SHA: `1047add9212bfa16c7b563bfe11b120eee656211`.
- Base: `master-4a04d07` (the same frozen base as merged #435).
- State: **DRAFT**, opened by the bot. Body @-mentions @kriskowal @erights @phoddie and cites both of @erights' originating threads (r3425079666 and r3427486065) and @phoddie's confirmations.

## Inline reply

- Comment id: `3431403581`.
- URL: https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3431403581.
- Posted on the `/replies` endpoint of `r3427486065`, citing PR #451, the addressing SHA `1047add92`, the row contents, and cc'ing @phoddie for accuracy review on the XS row.

## Recommended next stage

`next: liaison`. The PR is DRAFT and addresses a single review-thread request on a merged PR. The liaison should decide whether to run the gamut (cleaner → judge → fixer-loop → un-draft) or to leave it DRAFT pending @phoddie's confirmation that the row reads accurately, then un-draft. Since the row is explicitly approximate and the maintainer wants @phoddie to confirm, my recommendation is to leave it DRAFT until @phoddie reacts or comments on either #451 or the r3431403581 reply, and only then run the gamut. The liaison should set the right plan.

## Pre-push gates

The change is a single-file Markdown edit. Touched no ASCII-banner-bearing source, no `import()` JSDoc, no test-package `main`, no SECURITY.md, no filename-stutter cases, and no `yarn.lock`. Sentence-per-line markdown convention preserved across the new paragraph. No lint/typecheck surface affected.

## External-repo etiquette

The dispatch explicitly authorized: push to the new branch, open the DRAFT PR with the described body, and reply on r3427486065. All three actions match the authorization; no other PR was touched, no other comment was posted, no upstream `endojs/endo` action taken.

Self-improvement: nothing this time. The "row addition on a merged-PR follow-up branch" shape is unusual but well-covered by existing skills (`pr-review-thread-replies`, `frozen-base-branch` framing on the base choice). The legend-extension instinct (when adding a value not in the existing legend, extend the legend in the same commit) is general enough that it lives in `pr-formation` already and does not warrant a new skill.
