---
ts: 2026-05-14T00:47:00Z
kind: dispatch
role: liaison
project: endo
to: "*"
refs:
  - entries/2026/05/14/004348Z-dispatch-liaison-be2777.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 75
    role: source
  - repo: endojs/endo
    pr: null
    role: target
---

Dispatching the boatman to ferry `endojs/endo-but-for-bots#75` (`@endo/random` + `@endo/chacha12` packages) to `endojs/endo`. Concurrent with the #223 dispatch above. User direction: "make note in the journal about the mirroring" — captured here and in the result entry that will follow.

**Source**: `endojs/endo-but-for-bots#75`, branch `kriskowal-random-chacha12`, head `836928335be1b3e6aadff6a71bb2bd6c9746038e`. State OPEN, MERGEABLE, mergeStateStatus CLEAN. Diff +4775/-255 across 49 files.

**Source title**: `feat(random,chacha12): factor @endo/random from @endo/chacha12 [resync to actual/kriskowal-random-chacha20]`. The `[resync to actual/kriskowal-random-chacha20]` suffix is bot-internal framing about a previous resync; drop it. Suggested upstream title: `feat(random,chacha12): factor @endo/random from @endo/chacha12`.

**Source body framing notes**:
- `Refs endojs/endo#3232 (Gibson review)` is an UPSTREAM issue ref (note `endojs/endo#`, not a bare `#`). Keep as-is, possibly just `Refs: #3232 (Gibson review)` once the boatman is in the upstream context.
- The body otherwise reads as clean technical content (security/scaling/docs/testing/compat/upgrade considerations). No bot-bookkeeping paragraphs to scrub.

**Mirroring note**: this is a "garden mirrors a feature already in flight on the bot side". The garden source PR (`#75`) tracks the work; the upstream PR is the human-authored landing of that work on `endojs/endo`. The two are linked via this dispatch entry's `prs:` array (`source` + `target`) and via the journal `result` entry the boatman will write. The forward-link comment goes on the source PR after the upstream PR lands; the upstream PR body does not reference the source.

**Upstream**: `endojs/endo`, target branch `master`.

**Human**: `Kris Kowal <kris@cixar.com>`.

**identity_switch_authorized: true** — explicitly authorized by the user in this dispatch.

**Source-branch caveat**: large diff (+4775/-255). The squash-via-diff approach used on prior dispatches should still work; if the merge-base diff includes commits that are not part of the random/chacha12 feature (e.g., resync merges), the boatman should filter them at the diff stage as before.

**Expected report**: upstream PR URL, head SHA, attribution-verified, source PR forward-link comment, journal `result` entry, `Self-improvement: ...`.

Per-dispatch worktree triple to be created via `skills/dispatch-worktree/dispatch-prepare.sh boatman ferry-random-chacha12-75 endojs/endo-but-for-bots kriskowal-random-chacha12`.
