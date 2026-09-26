The fuzzer files are untracked (never committed), HEAD is the detached PR head as expected, and my inbox is empty. The work is complete.

---

# Completion report — disposable fuzzer for the ReadableBlob range/textRange system (PR #910)

## Verdict

**errors discovered: yes** — one real, cross-producer consistency defect in the landed range surface. Root cause is a single site in the shared maker (`streamWindowBase64`); it reproduces minimally and deterministically.

## Live-state caveat (precondition NOT met)

The job's precondition was "PR #910 is merged." **It is not.** Re-checked live: PR #910 is **OPEN** (`mergedAt: null`, `mergeCommit: null`), and the range system has **not** landed on `llm` (HEAD `33f0a5dbc` — `packages/platform/src/fs/blob-range.js` does not exist there). Rather than fail out, I fuzzed the **exact implementation under review**: the PR head commit **`4fa0a45f3ea80df7f33cebeaec2778ed8be09a28`** (fetched into an isolated project worktree). This is the identical code that will land, so the findings are directly consumable — but the next builder should note the implementation could still change before merge. I did **not** emit the orchestration-failure signal because the fuzzer *was* built and exercised; the failure trigger is specifically inability to do so.

## What I built

A disposable, **uncommitted** differential fuzzer (`packages/daemon/fuzz-blob-range.mjs`, plus a minimal `repro-streambase64-maxsafe.mjs`) — both left untracked in the disposable project worktree, never `git add`ed, no PR opened. It exercises **all five real producers** of `makeBlobRangeMethods` against an independent byte-slice + LF-scan oracle **and against each other**:

- `BlobRef` (in-memory, no `streamBytes` → derived `streamBase64` uses the `readWindow`-chunk loop)
- `StreamSource` (synthetic, has `streamBytes` → exercises `copyByteWindow`, the git/daemon path)
- `LocalBlob` (`packages/platform/src/fs-node`, real `node:fs`)
- `EndoMountFile` (`packages/daemon/src/mount.js`, live source, has `streamBytes`)
- `GitBlob` (`packages/git` native backend, real git repo via `git cat-file`)

Coverage: interval composition (nested range/textRange to depth 4), omitted & extreme bounds (0, EOF, `MAX_SAFE_INTEGER`, `2^60`), EOF/short reads, UTF-8 multibyte + astral boundaries, BOM (leading-stripped vs interior-preserved), chunked/base64 across the 48 KiB base64 and 64 KiB read boundaries (content to ~170 KB), derived-vs-direct equivalence, `textRange(a,b).text() === decoded.split('\n').slice(a,b).join('\n')`, and EINVAL rejection of negative/inverted/non-safe/fractional args. All repository/PR text treated strictly as data (encode/decode only, never eval'd).

## Campaign (reproducible)

- Command: `node packages/daemon/fuzz-blob-range.mjs <seed> 1`
- Seed 1: `2654435761` — **25,273 checks / 8,527 chains / 77.9 s**; producers run: BlobRef 4051, StreamSource 4120, LocalBlob 116, EndoMountFile 120, GitBlob 120.
- Seed 2: `305419896` — **25,009 checks / 8,512 chains / 77.7 s**.
- Both seeds surfaced **only** the one bug class below (14 raw reproducers seed-1, all the same root cause; second seed identical shape). ~50k checks with no other divergence is strong evidence the range system is otherwise correct across every dimension exercised.

## The finding — `streamBase64()` on a near-`MAX_SAFE` open-ended range throws `EINVAL` instead of streaming empty

**Minimized reproducer:** `makeBlobRefExo(bytes).range(9007199254740991n)` — i.e. `range(MAX_SAFE_INTEGER)`, a **documented valid empty attenuation** (see `blob-range.test.js` "composing nested open-ended ranges", which asserts `range(max).text() === ''`).

Observed on that same attenuated blob:
```
range(MAX).text()          = ""      (correct, empty)
range(MAX).getInfo().size  = 0n      (correct, empty)
range(MAX).streamBase64()  → THROWS  EINVAL: "end" "[9007199254790143n]" exceeds Number.MAX_SAFE_INTEGER
```
Three of the four read methods answer "empty"; the fourth throws. That inconsistency is the defect.

**Affected producers:** `BlobRef` and `LocalBlob` — the two producers **without** a `streamBytes` primitive, whose derived `streamBase64` takes `streamWindowBase64`'s else-branch. Producers **with** `streamBytes` (`StreamSource`, `EndoMountFile`, `GitBlob`) correctly stream empty (they route through `copyByteWindow`, which never passes a bigint `end` to a producer's `readWindow`). This is also a genuine producer-path divergence the differential harness caught directly.

**Exact threshold (confirmed):** throws for `absoluteStart > MAX_SAFE_INTEGER − 49152`, i.e. within one `BASE64_CHUNK_RAW_BYTES` (48 KiB) of `MAX_SAFE`. At `MAX_SAFE − 49152` `streamBase64` yields 0 bytes (OK); at `MAX_SAFE − 49151` it throws.

**Root cause** (`packages/platform/src/fs/blob-range.js`, `streamWindowBase64`, ~line 209): in the no-`streamBytes` branch,
```js
const windowEnd =
  end === undefined ? position + chunk : minBigInt(position + chunk, end);
```
When `end === undefined`, `windowEnd = position + chunk` is **not clamped to `MAX_SAFE_INTEGER`**. With `position` at/near `MAX_SAFE` (a legitimate empty open-ended selection), `windowEnd` exceeds `MAX_SAFE`, and the producer's `readWindow` validates its `end` via `toSafeNumber` and rejects with `EINVAL`. Note the maker already clamps composed offsets to `MAX_SAFE_INTEGER` in `intersectInterval`; `streamWindowBase64` simply omits the same clamp on its per-window `end`.

**Proposed fix (for the builder child — I did not apply it):** clamp the sub-window end into the safe-integer domain, consistent with `intersectInterval`. E.g.:
```js
const windowEnd =
  end === undefined
    ? minBigInt(position + chunk, MAX_SAFE_INTEGER)
    : minBigInt(position + chunk, end);
if (windowEnd <= position) return; // fully past the safe-integer domain → empty
```
`MAX_SAFE_INTEGER` is already in scope (line 59). Reading `[position, MAX_SAFE)` clamps at content length anyway (content can't exist past `MAX_SAFE`), so it short-reads to empty and the stream ends cleanly.

**Why the PR's own tests missed it:** the nested-open-ended test exercises `range(max)` but only calls `.text()`/`.getInfo()` on the result — never `.streamBase64()`. A regression test should assert `range(MAX_SAFE).streamBase64()` drains to empty on a no-`streamBytes` producer (BlobRef and/or LocalBlob).

## Clean dimensions (no defects found)

Byte-interval selection & clamping, nested composition never escaping the parent, omitted-end (to-EOF), `start === end` empties, EOF clamping, UTF-8 multibyte/astral splits, leading-BOM stripping vs interior-BOM preservation, `range(0,size).text() === text()` identity, `textRange` line-equivalence incl. CRLF/terminal-LF/blank-lines/unterminated-final-line, multi-chunk base64 round-trips (both `streamBytes` and `readWindow`-loop paths), `getInfo` selected content-address, `json()` parse/reject, and full cross-producer byte/text/size/hash agreement — all held across both seeds and all producers.

## Follow-ups for the next builder child

1. Apply the `streamWindowBase64` clamp above and add the missing `range(MAX_SAFE).streamBase64()` regression on a no-`streamBytes` producer.
2. The fuzzer is disposable and gc'd with this worktree; re-run via the exact command/seeds above against the merged `llm` once #910 lands to reconfirm (the run here was against PR-head `4fa0a45f3`, not merged).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/pr910-review-4941452327-fuzzer.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 86 tokens (4508333 cached reads)
- Output: 55431 tokens
- Cost: $4.949545500000001
- Wall-clock: 994s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
