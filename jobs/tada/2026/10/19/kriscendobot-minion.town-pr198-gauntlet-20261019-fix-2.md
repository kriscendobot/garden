Fix round 2 for https://github.com/kriscendobot/minion.town/pull/198 is pushed. CI was still queued when the 3600s deadline ran out, so I have no CI result for it yet.

**What I fixed.** There was no pre-pass block, so I worked from the latest panel verdict (review 5567058974). Everything is in one commit, `f18f25ec`, pushed with `safe-push-pr-head.sh --mode advance` (`e8e73598..f18f25ec`):

- **decomplector and curator (must-fix): two routes created a guest.** I removed the unauthenticated, guest-creating branch of `POST /api/guest/invitations/accept`, along with its retry state (`provisional`, `connectedTo`, `connectedPetName`). `src/web/guest-web-router.ts`, `src/web/guest-web-service.ts` and `test/web/guest-web-http.test.ts` are back to their base versions.
  - Accept requires the guest bearer again, so `POST /api/guest` is the only route that creates a guest or returns a credential.
  - This restores the two-step flow the maintainer asked for in the review on https://github.com/kriscendobot/minion.town/pull/56: a visitor with no guest creates one first, then accepts as it.
  - On the invitation card, `home.js` now creates a guest with `POST /api/guest`, stores it, and then accepts as it. The button reads "Create a guest and accept".
  - The page now checks a stored credential before offering to accept as it, and forgets one the API rejects. This also covers the assessor's should-fix about a dead stored guest blocking acceptance.
  - `test/home-page.test.ts` now asserts that the accept handler is the only place that creates a guest, and that it does so before accepting.
- **archivist (must-fix): a claim about a flag not in the tree.** `designs/closed-beta-waitlist.md` now says `GUEST_ADMISSION` and the coupon land with https://github.com/kriscendobot/minion.town/pull/199 on another branch, and that guest admission is open on this branch. I rewrote § The one landing for the two-step flow. In `designs/invitation-only-guest-onboarding.md` I put back the base text for the create-then-accept step and the rule that only creation returns the credential.
- **archivist (should-fix):** "Signed-in accounts with no bond" and "CSP" are now `###` headings, so the section reference resolves. I removed the decorative rule from the `.env.example` comment.

`tsc --noEmit` is clean, and vitest on the home page and `test/web/` passes: 83 passed, 2 skipped (the real-daemon tests in `guest-web-daemon.test.ts`).

**The maintainer's earlier decision.** The decomplector asked to stop for maintainer confirmation before going further. I messaged the maintainer. The liaison answered as a stand-in: this direction is right, and `POST /api/guest` stays open here while https://github.com/kriscendobot/minion.town/pull/199 gates it. That answer is provisional until the maintainer reviews it.

**CI.** `ci-wait-merge.sh` returned rc 4 (pending) after its first 560s window; my tool calls are capped near 10 minutes, so I couldn't run it with the full 3600s deadline. I kept polling the Actions run for `f18f25ec` until about 3600s after the push (07:06Z). All three jobs (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) were still queued for the self-hosted `ci-minion-town` runners, behind 6 other queued runs. That is a runner backlog, not a billing block.

**Follow-ups:**
- The driver should re-post this stage to collect CI, then run panel-3.
- These should-fix items are still open:
  - pruner's comment and prose de-duplication
  - curator's export trimming in the waitlist module
  - procurer's suggestion to use the rate limiter from `@endo/http-confine` (the PR body already explains why the local one is kept)
  - assessor's lost-201 note, which no longer applies now that acceptance no longer creates a guest

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3230683 cached reads)
- Output: 16995 tokens
- Cost: $1.7734286000000001
- Wall-clock: 3819s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
