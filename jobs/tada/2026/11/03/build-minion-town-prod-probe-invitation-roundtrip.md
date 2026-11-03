I added the invitation round trip to the minion.town prod probe as draft PR https://github.com/kriscendobot/minion.town/pull/234. CI is green, including the live-daemon suite, which ran its 4 tests rather than skipping them. Until the PR deploys, the new check fails with `step reset: answered 404, want 204`, because the cleanup routes it needs only exist on this branch.

**The probe check (`local-invitation-roundtrip`)**
- It uses two standing guests (an inviter and an acceptor), not the existing anonymous probe guest. It never calls `POST /api/guest`, so it keeps working after the coupon flip.
- Each pass resets both guests, mints an invitation, accepts it, accepts again (expects 200), and has the inviter redeem its own spent link (expects 404). It then checks both contact lists, sends one message each way, and cleans up even if a step failed.
- The acceptor must hold exactly one contact, the correspondent handle (the inviter's pet name). No state answer may contain either bearer or the invitation link.
- Failures read `step <name>: <status>` and never quote a response body, bearer, or link.
- A 404 on accept right after a mint means a deploy voided the in-memory invitation, so the pass mints again (up to 3 tries). A deploy after the accept falls back on the probe's existing single retry, which starts over from the reset.
- 23 tests cover it in `deploy/probe/prod-objectives.test.mjs`: repeated runs leave no state behind, leftovers from a dead pass are cleared, a deploy mid-pass is retried, and failures name the step without leaking secrets.

**Server change, needed to keep growth bounded.** The web API had no way to remove a contact or dismiss mail. Fixed pet names would get a 409 on the second run, and rotating names would grow forever. I added two routes on top of the daemon's own remove and dismiss operations:
- `DELETE /api/guest/contacts/:petName` (204, including when the name is already gone)
- `POST /api/guest/mail/dismiss-all` (204)

Both are tested over HTTP and against a real daemon, where the test forgets, dismisses, and re-introduces the same names.

**Provisioning on prod (done before the flip)**
- I minted two guests and stored their bearers in Secrets Manager as `minion/prod-probe-invitation-guests`. The same values are in the `prod-probe` environment secrets `MINION_PROBE_INVITER_BEARER` and `MINION_PROBE_ACCEPTOR_BEARER`, which `prod-probe.yml` now passes to the probe. DEPLOYMENT.md documents this and how to rotate the guests.
- Against live prod, with only the two undeployed routes stubbed, every step passed and no secret appeared in the result. That run left one contact and two messages on each guest; the first real pass after deploy clears them.
- That prod run also showed the daemon names a message's sender and recipient by handle locator rather than pet name, and keeps the sender's own copy in its mailbox. The check therefore proves delivery by unique, direction-tagged message text.
- While working this out I printed two handle locators to my local session output (no artifact, PR, or summary). As a precaution I deleted that guest pair and minted the pair now in both secret stores.

**Follow-ups**
- Accepted invitations stay in the server's in-process map (that is what makes re-accept idempotent), so it grows by one entry per pass between deploys. Pruning them after a TTL would bound it fully.
- I haven't verified whether the daemon frees storage for dismissed messages; they just stop being listed.
- After the flip, replacing the standing guests will need whatever admission path replaces `POST /api/guest`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-prod-probe-invitation-roundtrip.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5062374 cached reads)
- Output: 38237 tokens
- Cost: $2.7781428
- Wall-clock: 821s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
