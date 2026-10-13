---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-13T17:37:10Z
job: book-hyperlink-references-after-copyedit-20261004
claim: d312b399e890ae9b
---
Opened draft PR https://github.com/kriscendobot/garden-book/pull/13 against current `main`, head `56467b5d102636a651dcf9a74f47ec86a2cf203d`.

Converted about 600 references across the title page, all ten chapters, and `build/README.md` into exact internal anchors or verified external links. The renderer now preserves chapter-qualified fragments; review-economics figures have stable anchors; a whole-book test checks that every internal fragment resolves. Spatial references to unheaded nearby prose/whole tables, hypothetical issue numbers, and retired figures without current anchors remain deliberately plain.

Verification: `npm ci`; `npm test` (62/62); `node build/build.mjs chapters out` (10 files, 36 roles, 98 skills); browser check at phone/desktop in light/dark; all 36 equilibrium chart browser cases; garden pre-push probes (9/9); local verify. All passed. The review successor `garden-book-review-supervisor-after-hyperlinks-20261013` was sent the PR URL and exact head. Publication remains with the existing publisher after merge.

Self-improvement: nothing this time.
