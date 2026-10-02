# Gauntlet fix round 5 — endojs/endo-but-for-bots PR #1414

I applied the round-5 panel's must-fix items to the PR head as one follow-up commit (`38ad01d0a6` → `31b62f0fc2`) and trimmed the PR body. CI is green: `ci-wait-merge.sh` returned rc 0 with 28 of 28 checks passing and none failed.

## Changes to `designs/daemon-guest-delegated-host-channel-confinement.md`
- **critic, must-fix (copy-then-lookup bypass):** the design now says the provisioner refuses `@`-special names on every name or path argument of every exposed method, checked once before forwarding to the host. That covers both the source and destination of `copy` and `move`, `remove`, the file methods, the endowments passed to `evaluate` and `makeUnconfined`, and `sameCapability`. It explains why checking only `lookup` is not enough, and notes that a host formula found under an ordinary name still looks up as a provisioner. `@provisioner` is now an allowed special name, alongside `@main` and `@pins`.
- **skeptic, finding 1 (`evaluate` passes `@agent`):** I checked the two claude-sandbox files that build per-session powers (on `90b4f72604`). They use the endowed host only for `provideMount` and `remove`, and the provisioner exposes both. So the Provisioning Changes table now moves that endowment from `@agent` to `@provisioner`, and passing `@agent` through a provisioner throws.
- **critic, finding 2:** guest facets now also cover the channel's and the member's `getMember`/`getMembers`, which hand back a full member.
- **skeptic, finding 2:** the text now credits floot's `provideHost` hit to the second grep (the peer and bootstrap audit), not the first.
- **decomplector:**
  - Added a stated reason for keeping `sameCapability` on every provisioner: it gives no extra reach, because the caller can already look up both paths.
  - Addressed what happens when the same capability is detached and re-attached: it gets a fresh pin and a new key. That is safe because the last detach tears down the bridge and the pin.
- **novice:** channels and `ClaudeClient` now get a short explanation where they first appear.
- **copyeditor:** capitalized "Open Questions" consistently and removed a double negative.
- **Test Plan:** added cases for each of the above.

## PR body
- **pruner:** removed the "Documentation Considerations" and "Testing Considerations" sections.

## Not done
- **ergonomist (should-fix):** I did not rename the registrar's `pin`/`pinDirectory`. The existing paragraph that tells the three "pin" names apart stays.
- **ergonomist (comment-only):** I did not act on the points about `maybeLookup` throwing or the `@provisioner-unattenuated` name.

The panel was not re-run in this stage; the driver posts panel-6 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1414-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1377993 cached reads)
- Output: 9128 tokens
- Cost: $1.1325346
- Wall-clock: 922s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
