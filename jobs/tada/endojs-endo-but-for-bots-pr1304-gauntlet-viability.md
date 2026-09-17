All evidence gathered. Here is my viability determination.

## Viability report — endojs/endo-but-for-bots PR #1304

**PR state:** OPEN, unmerged, draft. Title: *"feat(daemon): read-only directory attenuation (1/3 of #1125)"*. Base `llm-387ea66` (pinned snapshot), head `bot/build/1125-readonly-directory-attenuation` @ `a8d2980e`.

**Deciding question:** Is #1304 still the current, non-superseded base slice of the #1125 split — i.e. was #1125 retired *in favor of* this split (not the other way round), and do its sibling slices still depend on this primitive? **Yes.**

**Evidence:**
- This PR was created today, **2026-09-17T21:46Z**. Its parent #1125 was **CLOSED at 21:50Z the same day** (never merged), explicitly retired into a 3-slice split per @kriskowal's reviewable-depth request. A kriscendobot receipt-forward comment on #1304 confirms it as "slice 1/3 (read-only attenuation) of the #1125 split."
- All three split slices are open and live: **#1304** (1/3, this), **#1306** (2/3, guest provisioning), **#1305** (3/3, guest-owned invitation primitive). The PR body records that #1306's `networks` option consumes `EndoDirectory.readOnly()` — the primitive this slice adds — so the downstream slices structurally depend on it.
- The diff is real and scoped to the primitive: `packages/daemon/src/directory.js`, `interfaces.js`, `manager.js`, `types.d.ts`, `test/endo.test.js`, plus a changeset. Nothing here is byte-drift; it is the base of a freshly-minted stack.
- No newer PR displaces it — it *is* the supersessor of #1125, not the superseded party. The motivating need (guest-owned invitation / provisioning work, an active goal) still holds; #1125 was closed specifically to be replaced by this split, this hour.

Both claims hold: not superseded, motivating premise intact. The gauntlet may begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1304-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (138962 cached reads)
- Output: 2336 tokens
- Cost: $0.4695870000000001
- Wall-clock: 44s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
