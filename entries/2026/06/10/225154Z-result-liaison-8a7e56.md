---
ts: 2026-06-10T22:51:54Z
kind: result
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/10/224622Z-dispatch-liaison-fec201.md
---

Boatman re-ferried the rebased kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527 (dispatch `fec201`); **CONFLICTING cleared -> MERGEABLE**.

#12527 new head `ee7df351b6` (was `8d2ccb2b9a`), force-with-lease, 13 commits, built via commit-tree from current master `57c65644e` (the mirror's new base). Tree == mirror tip `02782246b` (`0d35960c7`). **mergeable: MERGEABLE** (was CONFLICTING; now on current master). **turadg's APPROVED persisted** across the force-push (re-review not requested, per maintainer). Attribution: 9 upstream authors preserved (copilot, Turadg x2, Michael FIG, Kris Kowal x5), 4 endolinbot -> Kris Kowal <kris@agoric.com>, committer kris@agoric.com on all. Claude trailers stripped from commits 4-7,9,10; legit copilot Co-authored-by:kriskowal preserved; one bot-internal Refs/journal line dropped from commit 11. SSO token-URL push form used. CI freshly green-ish (5 done, rest running). Cross-link 4675157471 -> `...head ee7df351b6`.

The two-step that worked: bot rebased the mirror onto current master (its weave), then this re-ferry carried it -> #12527 is now current, mergeable, approved. The earlier daf7a86-based ferry's CONFLICTING is resolved.

Standing follow-ups (unchanged): the SSO push-form finding + the "agoric-sdk is now an active engagement (out of passive watch)" promotion are still worth a gardener/scholar encode when the maintainer wants it.
