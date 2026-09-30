---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet fix round 3 for kriscendobot/minion.town PR #144: fixes pushed, but CI is red because GitHub Actions billing is blocked

I applied the round-3 panel's must-fix items to `designs/guest-coupons.md` and pushed them to `design/guest-coupons` (`8de865b` → `6970365`). CI failed, but not because of the diff. GitHub refused to start any job with: *"The job was not started because recent account payments have failed or your spending limit needs to be increased."* All three checks (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) failed about 2s after starting, with no steps run. I reran it once (run https://github.com/kriscendobot/minion.town/actions/runs/36691445004) and got the same refusal. The previous head, `8de865b`, was green, and this commit only touches the design doc.

## What changed, by panel seat
- **critic**
  - § 6 no longer states `coupon` as the settled `GUEST_ADMISSION` default. It now says "proposed default", with open question 4 deciding when it flips.
  - § 2 now says the issuer's `provisioner` (`provideGuest`) is its one granted root-naming power. The root driver keeps custody of the root host and does every *other* root-name effect.
- **skeptic**
  - `coupon.describe()` now returns `{ expiresAt, available }`. `available` is a single yes/no that lumps all spent, expired and revoked states together, so it reveals nothing that trying to redeem wouldn't.
  - The shell's "Attach a coupon" now picks the soonest-expiring coupon that is still `available`.
  - Added a test that `POST /api/guest` refuses under `GUEST_ADMISSION=coupon`.
  - The sweep now runs every 5 minutes instead of 15, so a stale lease is finished within 20 minutes; the doc says so.
- **decomplector:** added a daily sweep pass that recounts the capacity counters from the row statuses and corrects drift. The write only lands if the capacity row hasn't changed since the recount started. Added a note on why the counters are stored separately, plus tests.
- **ergonomist**
  - `coupon-revoke <serial>` now throws `RootControlError` (`refused (not-issued)`, exit 1), like `bind`, `repoint` and `promote`. `coupon-revoke-book` keeps its skip-and-count output.
  - Added a `coupon-books [run-id]` verb so an operator can find a lost book id.
  - Changed the facet to `reserve(count, bookId, ttl)` so its argument order matches `coupon-issue`.
- **novice:** "root account" is now "root host" in § 1. ERTP gets a short gloss on first use. "the coupon exo" is now "coupon-minting facet" in § 2 and its table.
- **copyeditor:** the unclear test line now reads "A's `locate(name)` still returns type `invitation`".
- **pedant:** the flagged lines 611–612 don't exist in the 596-line file. The new list items use consistent indentation.

## Follow-ups
- **Needs a person:** kriscendobot's Actions billing or spending limit has to be fixed. Until then, CI on every kriscendobot/minion.town PR will fail the same way. I sent the maintainer a message about it.
- Once billing is fixed, rerun CI on `6970365`. It should pass, since the change is only to the doc. The driver's panel-4 then follows.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr144-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1191556 cached reads)
- Output: 9739 tokens
- Cost: $0.9677632
- Wall-clock: 213s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
