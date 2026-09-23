---
ts: 2026-06-10T22:18:42Z
kind: result
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/220923Z-dispatch-liaison-f5b22f.md
---

**Garden's first upstream ferry to agoric/agoric-sdk complete** (boatman dispatch `f5b22f`). Multi-author re-ferry of kriscendobot/agoric-sdk#5 -> Agoric/agoric-sdk#12527.

#12527 new head `8d2ccb2b9a`, force-with-lease `a6212a802...8d2ccb2b9a`, 13 commits. Tree byte-identical to the mirror tip (`a519b3537`); rebuilt via commit-tree to set per-commit attribution with zero conflict risk (a straight range cherry-pick had a lockfile replay artifact).

**Attribution (the point):** commits 1-9 original authors PRESERVED (copilot-swe-agent[bot], Turadg <turadg@agoric.com>, Michael FIG <mfig@agoric.com>, Kris Kowal <kris@agoric.com> x4, Turadg, Kris Kowal); commits 10-13 normalized endolinbot -> Kris Kowal <kris@agoric.com>; committer kris@agoric.com on all. **Garden-injected `Co-Authored-By: Claude Opus 4.6/4.7` trailers were present on commits 4,5,6,7,9,10 and stripped** (the trailer gate earned its keep again - these rode on Kris-Kowal-authored commits); the legitimate copilot `Co-authored-by: kriskowal` on commit 1 was preserved. No DCO sign-off (agoric does not use it).

**turadg's APPROVED PERSISTED** (force-push did not dismiss it - agoric master protection did not fire dismiss_stale_reviews on this push, better than the assumed-worst-case). No re-review routed (maintainer declined).

**Two follow-ups:**
1. #12527 is **mergeable: CONFLICTING** - it sits on the mirror's daf7a86 base, 1 day behind current agoric master `57c65644e`; the boatman correctly did not re-rebase (scope boundary). To make it mergeable a weave onto current master is owed - but the weaver runs under bot identity and cannot push to agoric upstream, so the shape is: weave the bot-side mirror kriscendobot/agoric-sdk#5 onto current master, then re-ferry. The maintainer deliberately built on daf7a86, so confirm before chasing 57c65644e.
2. **SSO push finding (encodable):** agoric/agoric-sdk is behind SAML SSO. `gh auth status` shows kriskowal push:true and the token reads fine, but SSH origin and HTTPS-with-keychain/bearer are SSO-REJECTED for writes; the only working push form on this host was `https://x-access-token:$(gh auth token)@github.com/agoric/agoric-sdk.git`. Worth a gardener encode: a line in pr-handoff § Identity discipline and the agoric-sdk project README. This is also the project's first active engagement (was passive standing watch) - the README's "until the first PR" clause has now tripped and the scholar should promote it out of passive watch.

Cross-link created on kriscendobot/agoric-sdk#5 (comment 4675157471). CI pending (Mergify, Socket Security).
