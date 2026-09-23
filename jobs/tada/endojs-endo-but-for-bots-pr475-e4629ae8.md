Done. Here's the completion report.

## Completion report: `endojs-endo-but-for-bots-pr475-e4629ae8`

**Directive** (erights, comment [5321512737](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321512737)) asked three things: (a) the differences between `toIndexableUint8` (compare.js), `toMutableChunk` (concat.js), `toDecodable` (to-string.js); (b) whether they should be refactored into one shared function, and what else; and (c) whether `ArrayBuffer.isView` could replace the `toStringTag` getter everywhere for genuine-vs-emulated checks.

**Re-derived state (clean requeue, reaped ×3):**
- Asks (a-partial) and (c) were already resolved. A prior attempt of this job posted a thorough site-by-site `isView` audit ([5321672547](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321672547)); erights approved the follow-through, and sibling jobs `pr475-6c19a076` / `pr475-fa8acb7f` **landed the isView code + prose + tests** (head `2d1200239`, "Done" comments 00:27/00:32). Those were verified done, not assumed.
- Ask **(b) — the unification question — was never answered.** The earlier audit described the three functions but gave no recommendation on extracting a shared helper, and erights only followed up on the isView work. This was the one outstanding ask of this job's directive.

**What I did:** inspected the current source of all three functions plus `hex/src/encode.js` at head `2d1200239`, then posted a substantive answer ([5321971680](https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5321971680)):
- **`toMutableChunk` + `toDecodable` are the same function** (derive buffer/offset/length, then `immutable ? copy : view`) and **should** share one `toMutableUint8` helper — differences are cosmetic.
- **`toIndexableUint8` should stay separate** — it's the `isView`/index-in-place axis you just committed; folding it in would force wasteful copies of genuine immutable views.
- **`hex`'s `asUint8View` is a third axis** (iterate-in-place, no copy) — at most shares an `isImmutableBuffer` predicate, not the copy helper.
- Offered to land the extraction on your word (matching the established propose-then-land pattern for this security-adjacent code).

**Notes/follow-ups:**
- No project-code or garden changes were needed — the directive was a question; the answer defers the actual extraction to erights' go-ahead. If he approves, a `fix #475` job would land `toMutableUint8` (concat + to-string) + optional shared predicate.
- One mechanical hiccup, self-corrected: first post used `gh api -f body=@file` (posts the literal path); I deleted it and reposted with `-F` (reads the file). Final comment carries the full body, `garden-reply:5321512737` marker, and provenance footer.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-e4629ae8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 5 on 2 host(s) (4 unmetered)
- Input: 36 tokens (1108294 cached reads)
- Output: 19869 tokens
- Cost: $1.6837630000000001 (4 engagement(s) unpriced)
- Wall-clock: 396s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
