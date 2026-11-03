**FIX round 6 is done for kriscendobot/minion.town#199: the panel's fixes are pushed and CI is green at `859e7eb8`.** `ci-wait-merge` returned rc 0, with 2 of 2 Actions runs passing. This PAT can't read `statusCheckRollup`, so it polled the Actions runs API, and any commit statuses or non-Actions checks weren't visible.

I applied the round-6 verdict (review 5752080361) from breaker and pruner in commits `3c67b135` and `859e7eb8`.

**Breaker fixes**
- **No throttle on redemption:** `POST /api/guest/coupon` now allows 30 attempts per network per hour, reusing the waitlist's in-memory limiter. Past that it answers 429 with `Retry-After` before touching the ledger.
- **Stranded attachments:** an attached coupon is now held for 3 days (`ATTACH_HOLD_MS`). After that the holder can attach it to a new invitation, but only once they have no unattached coupon left. Both links then carry the coupon and the first redemption wins.
- **Reused root names:** books now store a one-way SHA-256 digest of the recipient's identifier, so the credential itself stays out of the ledger.
    - `attachForHolder` matches on the digest, which made `guestNamesFor` dead code, so I removed it.
    - Delivery also refuses a name now held by another guest. It reports that on the book and leaves the book pending.

**Pruner cuts**
- **PR body:** cut from about 460 to about 300 words, keeping the two deviations, the default-off override and the evidence ledger.
- **Docs:** trimmed README passages that repeated the design or script headers. The `runuser` sentence and verb list actually duplicated `endo-root-host.sh`, not `deploy-coupon-store.sh` as the verdict said, so the README now points to that header.
- **Design and changeset:** the design now states its rules without the review narrative, and I cut the changeset's "Changed" bullet and pointed "Migration" at the README.
- **Comments and headers:** deleted the listed comments that restated the code, except the `issuer.ts` and `daemon-socket.ts` ones already removed by the edits above. Only `ledger.ts` now cites the design.

**Tests**
- **New coverage:** throttle, attachment release and preference order, reused names for both attach and delivery, and the DynamoDB attach paths.
- **Local results:** typecheck is clean, and the full suite had 1729 passing and 1 failing.
- **The local failure:** `test/git-remote/capability.test.ts` ("propagates a git failure…") is in a file this round didn't touch, and I didn't diagnose it. CI's green result covers the workflows, including the step that runs the real-daemon coupon suite, which skips locally.

**For panel-7 to check**
- **Throttle limits:** the 30-per-hour limit and 3-day hold are my choices, since the verdict gave no numbers. The count is per network and resets on restart, as the README now says.
- **Book digest:** the digest is a new ledger field, justified in the design's "no guest identifier" rule.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (1293695 cached reads)
- Output: 26312 tokens
- Cost: $1.8545950000000002
- Wall-clock: 804s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
