---
ts: 2026-05-19T03:28:45Z
kind: message
role: steward
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/05/19/032458Z-result-fixer-59c029.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 288
    role: source
---

# Gardener style-guide notes (×6) + two out-of-scope job postings from #288 review

## (1) Six style-guide / naming-guide notes for gardener

The fixer on #288 aggregated these from kriskowal's CHANGES_REQUESTED:

1. **Favor `undefined` over `null` for faults** (`maybeRead`
   precedent: missing result is absence of value, not a sentinel).
2. **Same-length abbreviation pairs (e.g., `hi`/`lo`) are
   acceptable** when local and the same-length property does
   legibility work (transposition errors stand out at the call site).
3. **Avoid ASCII-art section banners in test files** (AVA test names
   provide enough orientation).
4. **Blank lines between tests** (one blank line between consecutive
   `test(...)` invocations).
5. **Avoid garden procedural jargon in test prose** (specifically
   "adversarial sweep" — `jargon-de-jardin` our reviewers don't
   want to read).
6. **Future builders: omit hand-rolled CHANGELOG.md placeholders for
   new packages** (changesets writes the file on first release; first
   release is at 1.0.0).

These land in the project's active style guide / naming guide
(wherever that lives on the `llm` branch — `STYLE.md`?
`docs/style.md`?). Gardener decides the home.

Each was a "make a note in the style guide" / "make a note for
future builders" line from the maintainer's review — encoded so the
notes accumulate across PRs rather than only landing on the local
PR's reply.

## (2) Two out-of-scope job postings

Both arose from inline comments #4 and #5 of kriskowal's review and
are deliberately not handled by the #288 fixer:

- **`verb: weave` (or a specific brief)** target `llm` branch on
  `endojs/endo-but-for-bots`: confirm `@endo/bytes` (already on
  master) is also on `llm`; if not, update `llm` to bring it over.
  After the weaver lands, post a follow-up to rebase #288 onto the
  new `llm` HEAD and switch `test/cbor-frame.test.js:29` from
  ad-hoc helpers to the `@endo/bytes` API.
- **`verb: build` target a new PR on `endojs/endo-but-for-bots`**:
  add a utility to `@endo/stream` matching the `test:37` shape
  (sans the slice), so a follow-up cbor-frame revision can adopt it.
  Kriskowal explicitly said "we will leave [the existing test] as
  is", so the cbor-frame PR doesn't change; the new `@endo/stream`
  utility lands separately, and a future cbor-frame revision (post-
  merge) can replace its test helper.

These are liaison-shaped postings (the steward isn't a producer per
`skills/job-board/SKILL.md` § Inputs).

## (3) Status (no action required)

Two concurrent contractor-claimed jobs landed this cycle too:

- Job `a5f036` (multiplier-test-broaden-75) → done by contractor.
- Job `1077c8` (syrup-singular-109) → done by contractor; result
  `037980`; PR #109 head pushed, re-requested kriskowal review;
  ADD line on review-queue at `03:23:45`.

The contractor is actively claiming from the board while the steward
holds the #288 thread.

Self-improvement: nothing new this turn beyond what's in (1) and (2).
