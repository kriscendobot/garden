---
role: shepherd
tier: mentor
fallback-tier: minion
requires: host=endolin-garden-ece02cb4
dispatch: automatic
---

# Post the drafted RSVP replies on endojs/endo-but-for-bots PR #1477

Host oros-studio-garden-ce242c49 gets a 403 when it writes PR comments to endojs, so this job is pinned to endolin.
The parent job endojs-endo-but-for-bots-pr1477-review-071f4f54 already resolved kriskowal's review
https://github.com/endojs/endo-but-for-bots/pull/1477#pullrequestreview-5609794016 and drafted the replies below.
The content is settled. Post it verbatim and do nothing else: no code edits.

First check whether a peer already posted these (for example, a kriscendobot reply under comment 4344979384
that already contains "Here is the correction you asked for"). If one exists, complete as a no-op.

1. Inline reply to review comment 4344979384:
   gh api -X POST repos/endojs/endo-but-for-bots/pulls/1477/comments/4344979384/replies -F body=@<file with INLINE BODY>
2. Top-level PR comment:
   gh pr comment 1477 -R endojs/endo-but-for-bots --body-file <file with TOP-LEVEL BODY>

===== INLINE BODY =====
RSVP. Here is the correction you asked for. I checked the current OCapN draft spec ([Locators.md § Peer Locator](https://github.com/ocapn/ocapn/blob/main/draft-specifications/Locators.md)) against this code, and the words line up differently from how your comment reads them:

- OCapN's **`transport`** field is the axis you are calling the **network**. The spec defines it as "a unique identifier to specify a netlayer", the `np` in `ocapn://<designator>.np`. We already treat it that way: `network ?? transport`, with `transport: 'np'` kept on the wire only for compatibility (`designs/ocapn-network-transport-separation.md` § Target Model).
- OCapN's **`designator`** is the **peer** identity within that netlayer, "usually representing the key". For `np` it is the 64-hex Ed25519 public key. It does not name the network.
- It is also not a swissnum. A peer location (`<ocapn-peer transport designator hints>`) has no referent. The swissnum lives only in `<ocapn-sturdyref peer swiss-num>`.
- The spec also says "the designator and transport are the only pieces of information which need to match" when comparing peer locators, and that hints may differ. That is the `(network, designator)` keying this PR implements.

So in this test, `designator` means the peer's public key. Your proposed shape maps onto the current one like this:

| proposed | current in-memory / OCapN wire |
|---|---|
| `network: 'np'` | `network` (wire: `transport`) |
| `peer: string` | `designator` |
| `at: Array<{transport, address}>` | `hints` (`{'tcp+cbor': '127.0.0.1:3469', ...}`) |
| `value: string` | not on a peer location; `swiss-num` on a sturdyref |

I have **not** renamed anything in this PR, because your premise was the thing in question. If you still want the in-memory `OcapnLocation` reshaped to `{network, peer, at}` (with `value` living on the sturdyref type), that change touches every netlayer, the codecs' in-memory projection, and the design doc's vocabulary. The wire record stays `ocapn-peer transport designator hints` regardless. I have parked it as a separate job that waits for your answer, so this PR stays scoped to the location-ID keying. Two questions to settle it:

1. Do you want that reshape at all, now that `designator` = peer key?
2. If so, should it land in this PR or in a follow-up?
===== END INLINE BODY =====

===== TOP-LEVEL BODY =====
@kriskowal RSVP on [your review](https://github.com/endojs/endo-but-for-bots/pull/1477#pullrequestreview-5609794016). I replied [inline](https://github.com/endojs/endo-but-for-bots/pull/1477#discussion_r4344979384) with the correction you asked for. In OCapN's Locators.md, `designator` is the peer's key within the netlayer, not the network and not a swissnum. The network is OCapN's `transport` field, which this PR already reads as `network ?? transport`. The spec also says peer locators match on designator and transport alone, whatever their hints, which is the `(network, designator)` keying #1477 implements.

I made no rename here. The `{network, peer, at}` reshape you sketched is parked as `endojs-endo-but-for-bots-pr1477-location-reshape` until you answer the two questions in the inline thread.
===== END TOP-LEVEL BODY =====
