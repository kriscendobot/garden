---
ts: 2026-06-16T04:33:00Z
kind: result
role: fixer
worktree: dispatches/fixer--678c48/project
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/16/043000Z-dispatch-fixer-678c48.md
---

# Fixer result: PR #435 erights follow-up on lib.js:83 JSC/SpiderMonkey versions

## Task

erights asked one follow-up at `packages/immutable-arraybuffer/src/lib.js:83`
(discussion r3418021461, review id 4503137227):
"what versions of JSC and SpiderMonkey have neither `structuredClone` nor
`ArrayBuffer.prototype.transfer`?"

Researched version data and replied inline. No code change pushed.

## Version research

| API | JavaScriptCore (Safari) | SpiderMonkey (Firefox) |
|---|---|---|
| `structuredClone` | 15.4 (Mar 2022) | 94 (Nov 2021) |
| `ArrayBuffer.prototype.transfer` | 17.4 (Mar 2024) | 122 (Jan 2024) |

Sources:

- MDN / caniuse: `structuredClone` Safari 15.4, Firefox 94 (Nov 2 2021).
- web-platform-dx / Bugzilla 1865103: `ArrayBuffer.prototype.transfer`
  Firefox 122 (Jan 23 2024), Safari 17.4 (Mar 5 2024), Chrome 114 (May 30
  2023).

An engine lacks **both** only when older than the earlier of the two rows
(i.e., the `structuredClone` row):

- **JSC**: Safari **< 15.4** (pre-March 2022).
- **SpiderMonkey**: Firefox **< 94** (pre-November 2021).

## Dead-code verdict

The else-branch at `lib.js:101-104` (where `optArrayBufferTransfer = undefined`)
is **not dead** in absolute terms. The fallback remains load-bearing for:

- Hermes (no `structuredClone`, no `transfer`).
- Node 16 (lacks both, per the same JSDoc bullet and `README.md:71-72`).

The JSC-specific bullet ("Apparently some versions of JavaScriptCore that
are still of concern") resolves to Safari < 15.4. Whether to *drop the
bullet* depends on the package's de-facto Safari floor: at or above 15.4,
the JSC bullet is stale; below 15.4 (very unlikely four years after release,
March 2022), it stays. I deferred the actual removal to erights' confirmation
of the floor rather than guessing.

The reply offered to remove the JSC bullet (and any mirrored "of concern"
hedge in DESIGN.md / README.md) on confirmation.

## Action

- Posted threaded reply on r3418021461 via `POST .../pulls/comments/<id>/replies`
  (id `3418142184`,
  <https://github.com/endojs/endo-but-for-bots/pull/435#discussion_r3418142184>).
- No code commit. The dispatch authorized "optionally remove in small
  commit" only if dead; the analysis turns out to require a confirmation
  the fixer can't supply unilaterally.

## Pre-engagement HEAD

`9926e4187` (unchanged; reply-only engagement).

## Recommended next stage

Wait for erights' confirmation on the Safari floor. If he confirms
>= 15.4, dispatch a small follow-up fixer to drop the JSC bullet from
the JSDoc at `lib.js:80-83` and audit `DESIGN.md` / `README.md` for the
mirrored phrase. If he indicates the floor is older, leave the comment as
written and the thread is resolved by the version data alone.

Self-improvement: nothing this time. The pr-review-thread-replies skill
(`/replies` endpoint, threaded vs top-level) carried the engagement
without surprise; the version-research shape (MDN compat + web-platform-dx
+ Bugzilla cross-check) is a normal one-off that does not warrant a new
skill.
