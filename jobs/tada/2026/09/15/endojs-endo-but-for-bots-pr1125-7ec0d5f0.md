Done. The directive is executed and verified.

## Completion report

**Directive (untrusted comment 5688228987, kriskowal):** "I do want to keep the hostPins and guestPins and wake-on-message machinery." — routed as an objection to the just-pushed removal.

**What I found:** The immediately-prior commit `12000263c0` ("use invitation result names as connection roots") had over-reached. Beyond the redundant retention edge, it stripped the entire host-only pin feature: the `hostPins` guest-formula field, its directory creation/threading (`formulateNumberedGuest` → `makeGuest`), `formula-record` surfacing, `types.d.ts`, the formula-inspector registry entry, the invitation-accept local-guest retention that populates `hostPins`/`@pins`, and the `hostPins` arm of `reincarnateMailboxPins` (the wake-on-message reincarnation that resurrects a host-pinned responder on mail delivery). kriskowal's earlier requests (r3995156916 "allow the caller to specify a pins directory", r4019101570 "guests and hosts should both have host and guest pins") confirm these are wanted features, not vestige.

**What I did:**
- Reset PR #1125 head from `12000263c0` back to **`97891bb30f`** (the prior review head, CI-green across the matrix per comment 5687399933), restoring `hostPins`, `guestPins`, and the wake-on-message machinery byte-identically.
- Verified on the restored tree: `mail-pins` + `formula-record` unit tests pass (14 tests, including the restored `mail receipt reincarnates both guest pin directories`); daemon `tsc` (`lint:types`) clean.
- Force-pushed with lease to `kriscendobot/bot/build/endo-guest-invite-primitive` (lease held; no peer had pushed).
- Posted a top-level summary comment (issuecomment-5688323305) naming exactly what was restored and linking the standing "why the pin exists" reasoning to the earlier adversarial-review thread (discussion_r4009312397: the pin is the reincarnation trigger + revocation handle; the result name alone does not re-incarnate the responder).
- Re-requested review from @kriskowal.

**Preflight note:** the exit-2 HINT was not a resolution — no peer had addressed this; I did the work.

**State / follow-ups:** PR stays draft; CI re-runs on the restored head `97891bb30f`. The forward-looking retention-labels work remains tracked separately by the previously-posted `design-endo-daemon-retention-labels` designer job (first-class retention-reason metadata + host-facing browse/prune of hidden `hostPins`), untouched by this revert.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1125-7ec0d5f0.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1832358 cached reads)
- Output: 25496 tokens
- Cost: $2.390507
- Wall-clock: 409s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
