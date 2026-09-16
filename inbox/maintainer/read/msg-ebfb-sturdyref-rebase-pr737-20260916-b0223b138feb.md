from_host: endolin-garden-ece02cb4
from: gardener:ebfb-sturdyref-rebase-pr737-20260916
reply_to: ebfb-sturdyref-rebase-pr737-20260916
msg_key: msg-ebfb-sturdyref-rebase-pr737-20260916-b0223b138feb
notice_count: 1
first_seen: 2026-09-16T11:21:38Z
last_seen: 2026-09-16T11:21:40Z
sent_at: 2026-09-16T11:21:40Z
---
BLOCKER — sturdyref stack rebase (endojs/endo-but-for-bots#737) halts the serial orchestration ebfb-sturdyref-stack-rebase-20260916.

Live `llm` has INDEPENDENTLY SHIPPED a complete, tested sturdyref implementation in @endo/ocapn using a DIFFERENT design than this stack proposes. This is a design collision, not mechanical drift.

- llm's design: WeakMap `sturdyRefDetails` + `makeTagged('ocapn-sturdyref')`; exports getSturdyRefDetails; wire codec in codecs/descriptors.js; toStringTag `[object ocapn-sturdyref]`. Consumers OUTSIDE endojs/endo-but-for-bots#737's footprint depend on it: packages/thixotrope/test/hub.test.js (asserts the ocapn-sturdyref toStringTag on a round-tripped client.makeSturdyRef) and packages/goblin-chat/src/uri-parse.js.
- endojs/endo-but-for-bots#737's design: first-class pass-style 'sturdyref' + standalone @endo/sturdyref shim; rewrites client/sturdyrefs.js (getSturdyRefLocator, enliven cache, makeSturdyRefTracker); toStringTag 'SturdyRef'; removes getSturdyRefDetails/makeTagged.

Rebasing endojs/endo-but-for-bots#737 onto llm cannot be done as a rebase: it requires (a) a DESIGN DECISION — does the stack's first-class-pass-style sturdyref supersede llm's shipped ocapn-sturdyref? — and (b) if yes, re-authoring to update out-of-footprint llm consumers (thixotrope, goblin-chat) and reconcile the wire codec. That violates the job's own success criterion (diff == PR footprint only) and is beyond a rebase's remit.

This undermines the whole stack premise: the bridge PRs endojs/endo-but-for-bots#698 through endojs/endo-but-for-bots#704 build on the ocapn sturdyref wire codec, which now collides with llm's shipped version. The premise "llm is a clean ancestor, only @endo/ascii landed" missed that llm shipped a competing sturdyref.

Actions taken: rebase aborted, origin branch build/sturdyref-pass-style-ocapn-single LEFT UNTOUCHED at 1854bdc247. Nothing force-pushed.

Need your decision on which sturdyref design wins on llm before this stack can be rebased.
