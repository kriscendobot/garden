**Viability result for kriscendobot/minion.town#199: proceed.** I spent no clean, panel, fix, CI-wait, or un-draft budget and changed nothing.

Deciding question: Does `main` still lack a coupon admission gate, with nothing else replacing it, while the maintainer still wants the feature? Yes.

Evidence:
- **PR state:** #199 is open, unmerged, and a draft. Its head is `90e41d68` on `feat/guest-coupons`.
- **Base:** the base is `main-c5c3504`, and that commit is the current tip of `main`. The PR is 22 commits ahead and 0 behind, so the weave's force-push has already landed. The weave job file is still in `doin/`, so I didn't rely on its report.
- **Not superseded (code):** `main` has no `src/coupons/`, and `src/config.ts` has no `GUEST_ADMISSION` or `COUPON_STORE`.
- **Not superseded (docs):** `designs/closed-beta-waitlist.md` on `main` says "`POST /api/guest` is ungated" and that a coupon gate "is not in this tree". A PR search for coupon, waitlist, and admission terms found no competing implementation.
- **Related work on `main` supports it:**
  - Design #144 merged on 2026-10-21 and names #199 as the build of its first slice of phase 1.
  - #198 (waitlist and landing) only adds the splash and waitlist, and its design leaves the gate to coupons.
  - `designs/invitation-only-guest-onboarding.md` points to the coupon design for growth governance.
  - The handle grammar in `src/endo/root-host-socket.ts` already accepts `coupon-<serial>`.
- **Need still holds:** kriskowal approved on 2026-11-03T05:21:21Z, writing "Please integrate. I would like this feature enabled." The merge job (`kriscendobot-minion.town-pr199-conduct-20261103`) is parked, and the production flip (`minion-town-coupon-admission-flip-20261103`) is parked behind it.
- **CI on this head:** the Actions runs `test (typecheck + vitest)` and `clip frame browser gate` both succeeded. The bot's token can't read the check-runs API, so this comes from the Actions runs API only.

Follow-ups for later stages:
- **PR text is out of date:** the title still says "for a future closed beta", and the body still calls #144 a draft and says the PR ships `open`, with no garden job allowed to flip it. The code default can stay `open`, but the 2026-11-03 go-ahead now lifts that restriction for the one parked flip job.
- **Maintainer question still open:** the 06:08 comment asks kriskowal to say if "enabled" meant only merging default-off, or if they want different numbers. Answer it before the flip job runs. No reply had arrived when I read the PR, and my inbox was empty.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (290438 cached reads)
- Output: 5051 tokens
- Cost: $0.6504516000000001
- Wall-clock: 143s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
