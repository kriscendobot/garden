Both journal actions are confirmed on `origin/journal2`, with correct `reply_to`/`blocked_on` frontmatter, and no garden files needed changing.

## Completion report

**Gate re-checked and still closed. No code written — the design's hard gate forbids a fallback. Re-parked on a corrected artifact, and posted the missing prerequisite that was blocking the gate from ever opening.**

### Why this job woke (false clear)

It was promoted to `todo/` at 2026-09-17T21:51:10Z, **41 seconds after** `endojs/endo-but-for-bots#1125` was *closed* at 21:50:29Z. `unblock.sh` treats merge and plain close alike, so the park cleared even though #1125 never merged — @kriskowal asked for it to be retired and split (review scroll-back too deep) into `endojs/endo-but-for-bots#1304` → `#1306` → `#1305`.

### Gate evidence (captured today)

On `llm`, `packages/daemon/src/interfaces.js`: `GuestInterface` spans lines 236–336 and ends at `evaluate` with no `invite` and no `accept`; both appear only in `HostInterface` (lines 551/553). `guest.js` defines neither.

The more consequential finding is about the **successor stack**. At `#1305`'s head (byte-identical in source and tests to #1125's retired head `9fad002`), `GuestInterface` gains `invite` but **still has no `accept`** — nor `adoptFromLocator` nor `locateWithHints`. So even after all three PRs merge, a guest has no method by which it can redeem an invitation locator. All three are OPEN/draft, and the base of the stack targets pinned `llm-387ea66`, not `llm`.

### The structural gap I found and gave an owner

Design PR `endojs/endo-but-for-bots#1116` specified **both** halves of the guest vocabulary. The invite-half builder (`minion-town-remote-guest-endo-cli-endo-invite-primitive`) scoped itself to `invite`, and **nothing owned `accept`** — no job, no PR, anywhere on the board. The minion.town design (§ 3.2) states the build "remains blocked until Endo can accept into the calling guest", so the gate could never have opened; this job would have churned indefinitely.

- Posted **`endo-guest-native-accept-primitive`** (builder, parked `gate: blocked` behind `#1305`), carrying the verified guest-surface evidence, the scope from #1116, the same-daemon requirement minion.town actually needs, and the instruction to stack on `#1305`'s head. Parked rather than live so it does not open a fourth concurrent slice against the review load that motivated the split.
- **Re-parked this job** via `block-job.sh` on that job, replacing the dead `#1125` edge.

### Two things I put in the park body to stop the churn

1. **A 60-second gate predicate with the trap named.** Grepping `invite|accept` over `interfaces.js` matches lines ~551/553 *inside `HostInterface`*, which reads as a pass. The check must be bounded to the `GuestInterface` block. This is most of what the last two wakes cost.
2. **An explicit warning that no single PR merge implies the gate is open**, since the stack merges bottom-up into its own branches off a pinned base — so any wake is a signal to re-run the predicate, never proof.

Also re-recorded the four `RemoteInviteFacet` contract deltas the invite stack introduced (`cancel()`, no TTL, guest-visible `@pins` + `provideGuest` `pins`/`networks`, and the `hostAgent`→`invitingAgent` rename with the invitation's result name now being the connection root).

### Follow-ups

- This job resumes automatically when `endo-guest-native-accept-primitive` reaches `tada/`. **Expect its deliverable to be a draft PR, not a merge to `llm`** — one more wake-and-re-park is likely before the gate genuinely opens.
- Worth the maintainer's eye: `endo-guest-native-accept-primitive` is a fourth slice on a stack that was just split for review depth. If that is unwelcome timing, withdraw it — but the acceptance half needs *some* owner or the minion.town arc stays permanently gated.
- The three-PR stack's base is a pinned `llm-387ea66`, so it needs a merge path back to `llm` that nothing currently owns either.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-invitation-onboarding.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 64 tokens (2039968 cached reads)
- Output: 24965 tokens
- Cost: $2.428634 (2 engagement(s) unpriced)
- Wall-clock: 998s

<!-- garden-usage-end -->
