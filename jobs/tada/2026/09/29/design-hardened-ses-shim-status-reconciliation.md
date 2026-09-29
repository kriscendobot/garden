The text-codecs design record now shows its upstream implementation in draft PR endojs/endo-but-for-bots#1381. Per the job note, the URL half was already done (#1355) and I left it alone.

**What changed:**
- **Status:** `designs/hardened-text-codecs-shim.md` moves from Not Started to **Implemented (Phases 1–2)**.
- **Evidence:** the new `## Status` section cites endojs/endo#3322, merged 2026-07-22 as `8021d268e7`. That PR added the permits, a changeset, and 18 tests covering test-plan items 1–5. It also cites the follow-up endojs/endo#3340, merged 2026-08-11 as `dc504ca993`, which blocks a Node-only debugging method on both prototypes. I checked that both merge commits are ancestors of `llm` at `7ff30afbce`.
- **Remaining items**, recorded in the design as not blocking M2:
  - The XS smoke test (test-plan item 6) is still in draft PR #1349. That PR also found that the current `xst` does define both codecs, which the design assumed it did not.
  - The Phase 3 audit was never done. `packages/*/src` has 17 `Buffer.from(` / `.toString('utf…')` call sites, all in Node-host code.
  - A known Node bug makes `decode()` throw on a hardened `TextDecoder` instance (endojs/endo#2813, with open fix endojs/endo#3245).
- **Index:** `designs/README.md` gets the updated index row and recent-additions note, and the totals move one record from Not Started to Complete/Implemented (76→77, 19→18).

The PR's base is a new frozen branch `llm-7ff30af`. Nothing was committed to the garden repo; the work was docs-only in the project repo.

**Follow-ups:**
- #1381 and #1355 edit adjacent README lines, so whichever merges second needs a small conflict fix. #1355 also doesn't update the totals for `hardened-url-shim`, so that adjustment should happen then too.
- The Phase 3 audit would need its own cleanup job if anyone wants it. It doesn't block M2.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-hardened-ses-shim-status-reconciliation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 34 tokens (1401207 cached reads)
- Output: 8846 tokens
- Cost: $1.1566974
- Wall-clock: 148s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
