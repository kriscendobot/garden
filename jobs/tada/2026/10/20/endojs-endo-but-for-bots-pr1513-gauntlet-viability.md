**Viability report: endojs/endo-but-for-bots PR #1513** (`feat(ocapn-noise): add tcp+cbor transport framing with @endo/cbor-frame`)

The gauntlet can start. The PR is open and unmerged, nothing has replaced it, and the design step it implements is still unbuilt on `llm`.

**PR state:** open, draft, not merged. Base is `llm-92b91a7` (`92b91a7e93`) and head is `feat/ocapn-noise-tcp-cbor-transport` (`21b45842aa`). It has no reviews or comments yet.

**Deciding question:** Does `llm` still lack a `tcp+cbor` transport in `@endo/ocapn-noise`, with no other PR building one, while the design still calls for it?

**Answer:** Yes.

**Evidence:**
- **Base hasn't moved:** a compare of `92b91a7...llm` shows `ahead_by: 0`, so the pinned base is the current `llm` tip and no newer base history needs checking.
- **Not built on `llm`:** `packages/ocapn-noise/src/transports/` on `llm` holds only `mock.js`, `tcp.js` and `ws-node.js`, and `tcp.js` never mentions CBOR.
- **No competing PR:** searching the repo for `tcp+cbor` / `makeTcpCborTransport` finds no other PR that implements this transport. The matches are other migration steps the PR already accounts for (#1072 step 1, #1507 step 3, #1477 step 4) and unrelated daemon or gateway CBOR work (#1505, #711, #577, #347).
- **Design still wants it:** `designs/ocapn-network-transport-separation.md` on `llm` is marked **In Progress**, and its codec table still lists `tcp+cbor` as a required wire combination, which is Migration Plan step 2.
- **What it builds on has landed:** `@endo/cbor-frame` is on `llm` (#288).
- **One thing for review:** the design calls separate `tcp+cbor:host` / `tcp+cbor:port` hints "an aberration", but this PR advertises exactly those for now. The PR says this is temporary and that the single-hint form comes with steps 3–4. That's a question for the review panel and doesn't make the PR obsolete.

I spent nothing on cleaning, review, fixes, CI or un-drafting, and changed nothing in the garden or the project repo.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1513-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (154646 cached reads)
- Output: 1891 tokens
- Cost: $0.3770212
- Wall-clock: 48s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
