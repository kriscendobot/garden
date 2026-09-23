---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-01T21:17:26Z
---
---
ts: 2026-08-01T00:00:00Z
kind: result
role: stylist
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
---

Jury seat `stylist` on PR #910 (`feat-readableblob-range-attenuation`, base `llm-3ec5585`). Per-juror block follows.

### stylist (naming)

**Verdict:** request-changes

**Findings:**

- `packages/platform/src/fs/interfaces.js:162` — `RichReadableBlobInterface` is minted with the tag `'ReadableBlob'`, byte-identical to `ReadableBlobInterface` at `:146`, while its own comment at `:159-161` asserts "The tag is distinct from the whole-value `ReadableBlobInterface` so the two shapes don't collide in diagnostics". The name and the doc disagree, and the retired `ReadableBlobRangeInterface` did carry a distinct tag, so this is a regression. Either tag it `'RichReadableBlob'` or delete the claim. must-fix. [rule: roles/jurors/stylist/AGENT.md § Secondary surface (doc-name accuracy)]
- Freshly-authored abbreviated identifiers in `packages/platform/src/fs/blob-range.js`: `MAX_SAFE` (`:36`, -> `MAX_SAFE_INTEGER`), `minBig` (`:91`, -> `minBigInt`), `lfAt` (`:128`, -> `lineFeedOffsets`), `lo` / `hi` / `newLo` / `newHi` (`:169`, `:182-184`, -> `low` / `high` or `startOffset` / `endOffset`), and single-letter `s` / `e` in `range` (`:218-219`) and `textRange` (`:231-232`, -> `startOffset` / `endOffset`, `firstLine` / `endLineIndex`). Also `len` at `packages/daemon/src/manager.js:1831` and `packages/daemon/src/mount.js:1555` (-> `length`). This is the mechanical never-abbreviate check, not a judgment call. must-fix. [rule: roles/jurors/stylist/AGENT.md § Abbreviated identifiers; skills/pre-push-gates/SKILL.md `spell-out-identifiers`]
- `packages/platform/src/fs/extended/cas.js:149` — `drainBytesReader(readerRef, expectedSize)` no longer takes a bytes reader. Its own new JSDoc says the argument is "a remotable exposing `streamBase64`" and the sole call site at `:198` passes `blobRef`, so both the function name and the parameter name now lie. Rename to `drainBlobBytes(blobRef, expectedSize)`. should-fix. [rule: skills/rename-discipline/SKILL.md § The original name is wrong against current behavior]
- `packages/platform/src/fs/blob-range.js:171` — `selected()` reads as a predicate but returns `Promise<Uint8Array>`. `readSelectedBytes()` names what it does. should-fix. [rule: roles/jurors/stylist/AGENT.md § Primary surface]
- `packages/daemon-cas/README.md:40` still documents `readRange` as backing "public `ReadableBlobRange.fetch(bigint, bigint)`" — a retired type and a retired method the PR replaces everywhere else. Update to `RichReadableBlob.range(bigint, bigint)`. should-fix. [rule: roles/jurors/stylist/AGENT.md § Secondary surface (doc-name accuracy)]
- `range` / `textRange`: `textRange` takes line indices and returns a blob, so neither half of the name is literally true, and it is asymmetric with the byte-valued `range`. The design document names the pair explicitly (`designs/readableblob-range-attenuation.md` § Relationship to `rangeRead*`), so the rename is warranted; the mismatch is worth one clarifying clause in the `types.d.ts` docstring rather than a rename. comment-only. [rule: skills/rename-discipline/SKILL.md § What counts as warranted]

**Notes (out of scope but worth flagging):**

- `designs/agentry-git-eval-scenarios.md:127-160,399,431` and `designs/README.md:80,732` still specify `rangeRead` / `rangeReadText` as the sed-like blob path; `platform-range-and-tree-reads.md` got a superseded banner but these did not. [rule: skills/rename-discipline/SKILL.md]
- `packages/daemon/src/help-text-data.js` deletes the `glob`, `grep`, and `glorp` `EndoMount` help entries, and reflows `listRetentionPaths` / `followRetentionPaths` / `readLog`. All three methods still exist on `MountInterface` (`interfaces.js:664,673,684`). Not a naming finding; routing to the packager as unrelated churn in a range-attenuation PR. [rule: skills/changeset-discipline/SKILL.md § scope-by-package]

Self-improvement: the sharpest catch this round came from grepping every `M.interface('...')` tag in the touched file rather than reading the renamed export alone; the "name and docstring disagree" slice is cheapest to find by listing the whole family a renamed symbol belongs to. Proposing to the gardener that the stylist brief add that one-line technique under § Secondary surface.
