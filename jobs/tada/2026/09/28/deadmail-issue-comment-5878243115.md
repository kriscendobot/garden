I updated the description on garden issue #58 and posted the sitrep kriskowal asked for. I made no repo commits, opened no PRs, and left the issue open.

**Sitrep comment:** https://github.com/kriscendobot/garden/issues/58#issuecomment-5878414237. It covers:
- what changed on the checklist;
- what has landed since the last sitrep on 09-04;
- what is in flight;
- which schedules are running now;
- three decisions for the maintainer: the federation deploy chain, whether to submit `ocap.site` to the Public Suffix List, and 21 stale draft PRs.

**Description:** it's now dated 2026-09-28. I rewrote the status notes and kept the original spec text. The evidence comes from the live state of kriscendobot/minion.town and endojs/endo-but-for-bots, plus header checks I ran today against a live clip on `*.ocap.site`.
- **Newly checked: clip origin isolation.** The live clip returns a strict CSP, the COOP/COEP/CORP isolation headers, `X-Frame-Options: DENY` and `Referrer-Policy: no-referrer`. `ocap.site` is a separate domain, so `minion.town` cookies don't reach it. Submitting `ocap.site` to the Public Suffix List is still to do.
- **Content-addressed store and cache: "nearly done", still unchecked.** The content-hash ETag and `immutable` cache headers are live. I couldn't confirm that content is served without going through CapTP.
- **`/.well-known` WebSocket endpoints: "mostly live", still unchecked.** `ocapn-cbor`, `ocapn-syrup` and `endo-captp` answer `426 Upgrade Required`. `/.well-known/ocapn-bootstrap` returns 404, so I left the box open.
- **Guest publish capability: "half done".** Each guest has its own publish facet, and the web invite/accept flow merged in #81. Publishing is still charged at 0 through a stub payment processor, and ERTP credits exist only as a design.
- **Later phases:** the distributed store, DynamoDB and node→endor items now point to today's draft planning PRs (#123–#127). The garbage-collection item points to the merged design (#89) and its two draft builds (#83, #93).
- **Other updates:** #17 is marked merged, and the OCapN item now links the upstream `EndoGuest.accept` merge, the daemon re-pin (#112) and #117.

**Worth a look:** kriscendobot/minion.town#117 merged at 20:47 today, but its PR body said "must not be merged or activated yet." It went in on kriskowal's "conduct and validate in production" approval. Federation is still off, because its deploy script isn't in CD and it waits on endojs/endo-but-for-bots#1332 and #1333. The sitrep states this plainly.

The garden's `gh` wrapper refused the first posting attempt because of bare `#N` references. I rewrote them as full links before posting.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/deadmail-issue-comment-5878243115.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (987054 cached reads)
- Output: 11962 tokens
- Cost: $1.0198268
- Wall-clock: 128s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
