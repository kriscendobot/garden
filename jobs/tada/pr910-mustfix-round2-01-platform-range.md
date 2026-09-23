PR head is my pushed commit `2aa00f72b` and it remains **draft**. Work is complete.

## Completion report

**Job:** PR #910 fix round 2, child 01/06 — platform blob-range invariants (`endojs/endo-but-for-bots`). Worked in an isolated project worktree; pushed two commits to `feat-readableblob-range-attenuation` (fast-forward `955f53be9..2aa00f72b`, no force-push). PR left **draft**; did not un-draft/merge/re-run the panel (later children own those).

**Blocker 7 — interval-composition overflow** (`packages/platform/src/fs/blob-range.js`). `intersectInterval` (the panel's `compose`) clamped composed endpoints to the parent's end only when the parent was bounded. On an open-ended parent, two individually valid offsets (each `≤ MAX_SAFE_INTEGER`) could sum past it — a nested open-ended `range(MAX)` of a `range(MAX)` — and failed far later at read time with a bare EINVAL instead of yielding an empty past-end selection. Now both composed endpoints are clamped into the safe-integer domain at the single construction site (monotonic, preserves `start ≤ end`). Regression test added.

**Blocker 2 — BOM (U+FEFF) reconciliation.** Round 1's fix (unify onto a BOM-stripping decoder) missed the interior-U+FEFF-at-window-start case, because a default `TextDecoder` strips a leading BOM regardless of absolute offset. Adopted one normative rule on every read path: **strip a U+FEFF only when the selection begins at absolute offset 0; preserve any interior U+FEFF (including one that begins a derived window) as literal content** → position-independent decoding, so `range(0n,size).text() === text()` holds on every producer. The derived path strips iff `absoluteStart === 0n`; the daemon `EndoMountFile` (which decoded via Node's BOM-retaining string reader) now strips a leading BOM explicitly to match every other producer. Documented in the design's § Text ranges and the changeset. Equivalence tests added for BlobRef, LocalBlob, and the mount face — each including a selection beginning at an interior U+FEFF.

**Blocker 10 (test half) — missing multi-chunk LocalBlob regression.** Added a ~130 KB LocalBlob test (non-multiple of the 64 KiB read window, 48 KiB base64 sub-window, and 3): byte-exact `range`/`getInfo` across a 64 KiB boundary, whole-value `streamBase64` round-trip across several sub-windows, and a `textRange` straddling a read boundary.

**Gates:** `@endo/platform` (336 tests) and `@endo/daemon` mount suites (122+ tests) pass; `tsc` and eslint report **0 errors** on `@endo/platform`, `@endo/daemon`, `@endo/git`. Posted the required top-level PR summary comment (no inline threads existed — the panel review is a single body). No reasoned-decline (PLAT-05/19/25/33, GD-07/08/11) was reopened.

**Follow-ups:** none owned by this child; sibling children 02–06 own the remaining daemon/CAS/Git/XS/changeset blockers.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-mustfix-round2-01-platform-range.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 139 tokens (10079763 cached reads)
- Output: 91097 tokens
- Cost: $9.188195499999997
- Wall-clock: 1425s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
