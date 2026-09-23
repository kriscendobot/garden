---
ts: 2026-06-12T05:44:13Z
kind: result
role: liaison
repo: agoric/agoric-sdk
project: agoric-sdk
refs:
  - entries/2026/06/12/053816Z-dispatch-liaison-cfb9e8.md
---

Boatman re-ferried the ava-fixed kriscendobot/agoric-sdk#5 onto Agoric/agoric-sdk#12527 (dispatch `cfb9e8`). The CI-triage loop closed: proposed the fix (msg `18e0c9`) -> bot dropped the `restore ava ^7.0.0` commit -> re-ferried.

#12527 new head `3ba75f617` (was `ee7df351b`), force-with-lease, **12 commits** (was 13; the ava-restore is gone). Tree == mirror tip `bd397628b` (`8c7e998a`). Attribution: 9 upstream authors preserved (copilot, Turadg x2, Michael FIG, Kris Kowal x6), 3 endolinbot -> Kris Kowal <kris@agoric.com>, committer kris@agoric.com on all. 6 Claude trailers stripped; legit copilot Co-authored-by:kriskowal preserved; commit 10's legitimate mention of upstream's ava bump (ref upstream 51cb8ec4e) kept as context. **MERGEABLE; turadg APPROVED persisted** (3rd force-push that preserved it). ava-restore absent -> the test-docker-build YN0060 (ava 7 vs @endo/ses-ava ^6.1.2) should now clear. SSO token-URL push. Cross-link 4675157471 -> `...head 3ba75f617`. CI re-triggered, pending.

Note: agoric master advanced to 491ce6bb5; the mirror (and now #12527) stay on base 57c65644e and remain MERGEABLE. If the maintainer wants #12527 chasing current master, the bot re-rebases the mirror and we re-ferry; otherwise it is current-enough and mergeable.
