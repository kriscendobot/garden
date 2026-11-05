---
handed-off: endojs-endo-but-for-bots-pr1652-review-5782081346-replies
deliverable-complete: false
---
I addressed all nine inline comments in the design and pushed them to `design/unified-virtual-filesystem` (`7041c0f28f` → `4ca7b3319c`), but the RSVP itself hasn't posted. This host's token gets a 403 on PR writes, so the replies, PR body and summary comment are relayed to successor job `endojs-endo-but-for-bots-pr1652-review-5782081346-replies`, pinned to `endolin-garden-ece02cb4`, with every text embedded. The job is on the board and its host pin parses correctly; it hasn't been claimed yet.

The preflight exited 0, so no peer had already resolved this review.

| Comment | Resolution | Commit |
|---|---|---|
| 4478343101: drop `{ algorithm, hash }` | Methods name the algorithm (`sha256()`, `treeSha256()`); `TreeRef` and `BlobInfo` results are retired | `964dd55004` |
| 4478476350: store names and `Cell` | Renamed to `BlockStore`, `LogStore`, `MapStore`, `SetStore`, `BagStore` and `Cell`; added a `Value` kind for direct entries | `8be613c95a` |
| 4478476350: locator projection | Locator files carry a 256-bit marker that Endo writers refuse (`RESERVED_CONTENT`), plus an Ed25519 signature checked against the locator's `peerKey` | `a90c8b517a` |
| 4478490457: hash-line reads and searches | Answered yes: added `readHashLines`, `grepHashLines`, `glorpHashLines`, and renamed to `editHashLines` | `e6414aa25d` |
| 4478504470: just `snapshot`? | Answered yes: removed `identity()` and `ContentIdentity`; `expected` takes a snapshot | `918674a8f8` |
| 4478559585: `snapshot` and `capture` | These two methods replace `snapshot({ strict })` | `a9d10b6441` |
| 4478518955: conflicts as copy data | Conflicts are now hardened copy records framed by hash-line anchors, with nothing to dispose | `7128aa0de9` |
| 4478524547: `keep`, `drop`, `insert` | Transforms are one edit script per target | `e3e443338c` |
| 4478568564: `narrow` | Replaces `limitResults` | `52cea41fd0` |
| 4478586504: compare-and-swap | No locks; the fastest mutator commits and the rest throw `PRECONDITION_FAILED` | `5f47e22150` |

A final commit, `4ca7b3319c`, only rewraps lines and removes a stale term.

**Verification:** the deterministic probes, `thesaurus-cliche-grep` and `orthographer-divergence-grep` all pass against the pinned base. This is a design-only change, so there were no tests to run.

**Choices for kriskowal, all flagged in the relayed summary:**
- The name `Value` for direct entries is mine.
- I folded `withResultBudget` into `narrow({ records })`.
- I removed last-writer-wins from `applyPatch`.
- `## Open questions` asks how a tree gets another peer's signature, since locator minting signs nothing today, and whether archives should keep the signed manifest.

**Follow-ups:**
- If `endolin-garden-ece02cb4` is over its token cap, the relay can sit unclaimed for an hour or more, and until it posts kriskowal sees only the commits. If that happens, the maintainer needs to be told.
- Queued gauntlet panel round 4 will review the new head; I didn't change the gauntlet. No bot-authored follow-ups needed parking.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1652-review-358defcf.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (3221401 cached reads)
- Output: 67233 tokens
- Cost: $3.3939562000000003
- Wall-clock: 987s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
