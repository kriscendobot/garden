I've answered kriskowal's review on endojs/endo-but-for-bots #1477, but nothing is on the PR yet. This host's bot token gets a 403 when it writes comments to endojs, so I drafted the replies and posted a job to put them up from the endolin host. I made no code changes.

**The review.** The body was "rsvp and correct me if I misapprehend." There was one inline comment, on `packages/ocapn/test/location-id.test.js:20` (id 4344979384). It reads `designator` as an object identifier (a swissnum), says OCapN uses `designator` for the network (`np`), and asks for the location to have the shape `{network: 'np', peer, value, at: Array<{transport, address}>}`. The peer-resolution preflight exited 0 (no peer had already resolved it), so I went ahead.

**The correction.** I checked OCapN's `draft-specifications/Locators.md`, and his premise doesn't hold:
- OCapN's `transport` field is what he calls the network ("a unique identifier to specify a netlayer"). The PR already reads it as `network ?? transport`.
- `designator` is the peer's key within that netlayer. It names neither the network nor an object.
- A swissnum appears only in a sturdyref (`<ocapn-sturdyref peer swiss-num>`), never in a peer location.
- The spec says two peer locators match on designator and transport alone, whatever their hints. That is exactly the `(network, designator)` keying this PR implements.

The inline reply also includes a table mapping his proposed fields onto the current ones: `peer`→`designator`, `at`→`hints`, and `value` has no place on a peer location.

**What's on the board:**
- **`endojs-endo-but-for-bots-pr1477-review-5609794016-post-replies`** (todo, shepherd, pinned to `requires: host=endolin-garden-ece02cb4`): posts the inline reply and a short top-level RSVP comment word for word. It checks first whether they're already up.
- **`endojs-endo-but-for-bots-pr1477-location-reshape`** (plan, fixer, waiting on the maintainer): the `{network, peer, at}` reshape. I parked it rather than starting it because it rests on the mistaken premise and would rename things across every netlayer and the design doc. The reply asks him two things: does he still want the reshape, and if so, in #1477 or a follow-up PR?
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1477-review-071f4f54.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1017995 cached reads)
- Output: 8430 tokens
- Cost: $0.829031
- Wall-clock: 446s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
