# Completion report: endojs-endo-but-for-bots-pr1414-gauntlet-fix-6 (fix round 6)

**PR:** https://github.com/endojs/endo-but-for-bots/pull/1414 (still a draft design PR)

I applied the must-fix items from round-6 panel review 5391422217 and pushed the fix. CI came back green: 28 of 28 checks passed, with `ci-wait-merge` exiting 0.

## Pushed
I pushed one follow-up commit, `df57dc6011`, onto `31b62f0fc2` with `safe-push-pr-head.sh`. It was a fast-forward and nothing was rewound. The only file changed is `designs/daemon-guest-delegated-host-channel-confinement.md`.

## Must-fix items addressed
- **`sameCapability` rationale (critic).** The design no longer says it "adds no reach." It now calls it a new one-bit equivalence oracle. The design does not require `guestFacetFor` to return the same facet object each time, so comparing two lookups with `===` cannot answer the question. The new text says why the bit is safe to give out: it is neither authority nor a name the daemon resolves, it covers only paths the caller can already resolve, and the `@`-name refusal applies to both arguments. It also says why the method sits on every facet rather than in a floot-only variant.
- **Channel facet under forwarding (skeptic/decomplector).** The design now states a rule: every way a pet-store binding becomes a live reference for a guest goes through `guestFacetFor`. Those ways are listed: lookup, list, adopting from mail, the facet's lookups and makers, `evaluate` endowments and the powers of `makeUnconfined`. Forwarding with `copy`/`move`/`send` moves only the binding, so the receiving guest still gets the redacted facet. The design also explains why hosts need a durable formula and channels do not. A Test Plan case now covers forwarding.
- **Name collision with `ClaudeSessionProvisioner` (pedant/integrator), plus the ergonomist's point that "provisioner" undersold the surface.** I renamed the concept throughout:
  - `provisioner` → `attenuated-host`
  - `@provisioner` → `@attenuated-host`
  - `EndoProvisioner` → `EndoAttenuatedHost`
  - Open Question 3's example opt-in → `@full-host`

  A new paragraph explains the rename and names `claude-session-provisioner.js` as the collision.
- **PR body template (pedant pre-pass).** I added the missing "Documentation Considerations" and "Testing Considerations" sections in template order, and updated the body to the new name.

## Should-fix and comment items also addressed
- Explained where fae's `selfName` comes from: it is the guest's `provideGuest` name, so the `copy` reaches into the factory's own pet store. I added a Test Plan case for that step and made it a precondition for Phase 3.
- The Phase 3 rename is now marked as depending on how Open Question 4 is answered.
- Removed the "fact 2" reference that appeared before the facts were introduced.
- Added a link to `runtime-container-fs-mount.md` under Related.
- Added a sentence to the problem section saying Gap 1 stays open for floot until Open Question 3 is answered.

## Not addressed
- The copyeditor's sentence-splitting suggestions.
- The critic's should-fix about re-running the #1404 survey if that PR changes.

**Next:** the gauntlet driver re-posts panel round 7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 50 tokens (1858223 cached reads)
- Output: 13610 tokens
- Cost: $1.2959646000000002
- Wall-clock: 968s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
