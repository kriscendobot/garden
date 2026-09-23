---
ts: 2026-06-16T21:00:00Z
kind: result
role: fixer
worktree: dispatches/fixer--eba5aa/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/16/035500Z-dispatch-fixer-32650e.md
  - entries/2026/06/16/042700Z-result-fixer-32650e.md
---

# Fixer result: PR #435 erights 7-nudge follow-up on lib.js

Addressed the seven follow-up nudges erights posted 2026-06-16T20:49 to 20:53Z on `packages/immutable-arraybuffer/src/lib.js`.
All seven trace to original asks in his CHANGES_REQUESTED review id 4502549835 that the prior fixer 32650e missed.
Fixer 32650e claimed 29/29 resolved.

## SHAs

Pre-engagement HEAD: `82b8fa90f`
Post-engagement HEAD: `b1eceee2b`

Two append-only commits:

- `707e57280` `refactor(immutable-arraybuffer): capture WeakMap.prototype methods, drop polymorphic-call disables`
- `b1eceee2b` `style(immutable-arraybuffer): apply lib.js naming and shape suggestions`

## Per-ask resolution mapping

| Nudge id | Line at review | Original ask id | Ask summary | SHA |
| --- | --- | --- | --- | --- |
| `3423950174` | 117 | `3418039191` | Capture `WeakMap.prototype.{get,set,has}` and use `apply`; drop `@endo/no-polymorphic-call` disables | `707e57280` |
| `3423951091` | 118 | `3418043528` | Remove "Safe because this WeakMap owns its has, get, set" comment | `707e57280` |
| `3423952652` | 135 | `3418046228` | Rename `amplifyArrayBuffer(immuAB)` -> `amplifyArrayBuffer(arrayBuffer)` | `b1eceee2b` |
| `3423954326` | 156 | `3418057077` | Reword "constructor is inherited" -> "is unchanged" | `b1eceee2b` |
| `3423955326` | 158 | `3418106363` | Inline export: `export const immutableArrayBufferLibProperties` | `b1eceee2b` |
| `3423957218` | 177 | `3418082665` | Prefix possibly-undefined captured accessors with `opt` | `b1eceee2b` |
| `3423965637` | 304-305 | `3418110947` | `freeze(immutableArrayBufferLibProperties);` | `b1eceee2b` |

No items declined.

## Test results

- `corepack yarn workspace @endo/immutable-arraybuffer test`: 53 passed.
- `corepack yarn workspace @endo/pass-style test`: 30 passed.
- `corepack yarn workspace @endo/bytes test`: 32 passed.

## Pre-push-gates

Both commits gated. Final run: `result: gate passed.`
`yarn format` and `yarn lint --fix` each auto-fixed and re-staged one path per commit;
no manual intervention required.
All eight probes pass; `yarn typecheck` skipped (no per-package script in `@endo/immutable-arraybuffer`).

## URLs

Top-level summary comment: `https://github.com/endojs/endo-but-for-bots/pull/435#issuecomment-4723658923`

Seven inline replies:

- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424036683` (on r3423950174)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424037298` (on r3423951091)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424037493` (on r3423952652)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424038197` (on r3423954326)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424038444` (on r3423955326)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424038736` (on r3423957218)
- `https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3424038877` (on r3423965637)

## Recommended next stage

`next: liaison`.

PR #435 remains `reviewDecision: CHANGES_REQUESTED` until erights re-reviews on the new head.
Expected: APPROVED on the next pass (the seven asks are now landed, the substantive WeakMap refactor matches what erights cited from his "PR on master").
If erights surfaces further follow-up asks, dispatch a third fixer.
If APPROVED, dispatch boatman to ferry upstream to `endojs/endo`.

CI status on the new head was not checked in this dispatch.
Recommend the steward's per-cycle PR scan picks that up; if any matrix went red on either commit, dispatch a shepherd.

## Self-improvement

Root cause of the 32650e overcount: the prior fixer enumerated 29 inline comments under review id 4502549835 and treated that as the complete ask list.
What it missed is that erights also posted seven additional comments as REPLIES on seven of those threads (with `in_reply_to_id` set), refining or adding to the original asks.
A walk that filters comments to `pull_request_review_id == REVIEW_ID AND in_reply_to_id == null` returns 29 (the top-level openers) and misses the seven refinements.
The corrected walk for a many-thread iterated review is:

```sh
gh api repos/<o>/<r>/pulls/<N>/comments --paginate \
  --jq '.[] | select(.pull_request_review_id == <REVIEW_ID>)'
```

with NO `in_reply_to_id == null` filter, then group by thread root (the `in_reply_to_id` chain) and address the deepest unresolved ask per thread.
In this case the 29 originals were addressed, but seven of those threads had a deeper unresolved ask that the prior fixer's pre-walk did not see.

The lesson generalizes beyond #435: any review where the reviewer iterates within a thread (a suggestion-block refinement, a "still please do this" nudge) needs the no-filter walk; the simpler walk only works on a one-shot single-pass review.
Routing this lesson to `skills/pr-review-thread-replies/SKILL.md` § Pitfalls as an addition to the "REST index lag" entry; the gardener will land the wording when the orchestrator forwards.

Self-improvement: candidate skill update for `skills/pr-review-thread-replies/SKILL.md` — add a pitfall "When the reviewer iterates within a thread (a follow-up suggestion-block or nudge on the same path:line), the per-thread walk must enumerate all comments with `pull_request_review_id == REVIEW_ID` and group by the `in_reply_to_id` chain rather than filtering to `in_reply_to_id == null` openers; otherwise a multi-pass review's refinements are silently dropped."
