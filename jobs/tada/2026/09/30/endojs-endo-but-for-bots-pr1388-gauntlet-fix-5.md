# Gauntlet fix round 5: endojs/endo-but-for-bots#1388

I applied all the panel-5 fixes to `designs/ocapn-cloudflare-netlayer.md` in one follow-up commit, pushed it, and CI came back green: 28 checks, 0 failed.

**Push:** `6f463d3e35` ("design(ocapn): address cloudflare netlayer panel round 5") went onto `design/ocapn-cloudflare-netlayer` with `safe-push-pr-head.sh` in advance mode, moving the head from `d93e36ebeb` to `6f463d3e35`.

**Must-fix items**
- **Pedant (em-dash):** the design quoted a comment from `handshake.js` that contains an em-dash. I paraphrased the quote so the prose no longer has one.
- **Novice (`verifyPeerLocation` never defined):** the design now says what the hook is where the argument relies on it. It is an optional netlayer hook (typed in `packages/ocapn/src/client/types.js`) that binds the peer's claimed location to an identity the transport authenticated. It also explains why that doesn't work here: a DO or service-binding call carries no caller identity. I checked this against the actual source.

**Should-fix items (also addressed)**
- **Critic:** the trust-model section no longer claims that a confined facet can get end-to-end protection today. It now says the needed supervisor relay for encrypted traffic isn't designed yet and is future work for phase 4, with a matching Known Gaps entry.
- **Skeptic:**
  - I added a phase 0 smoke test to the Phased Implementation section. It checks that `@endo/ocapn` runs in workerd with `lockdown()` and `harden()` before any codec work, and I reworded the Known Gaps entry to match.
  - I added a network test for the reconnect claim: after an abort, the next `provideSession` opens a new session and traffic works end to end.
- **Decomplector:** Open Question 1 now states that running two `makeOcapn` instances splits the vat's references into two separate sets, which makes it an identity question.
- **Ergonomist:**
  - I split a new `pingTimeout` option (defaulting to `idleProbeInterval`) out of `idleProbeInterval`, with a sentence on why they are separate.
  - I renamed the `capnweb` flag to `allowCapnweb`.
- **Novice:** `.np` (the Noise network) and E-ordering are now explained where they first appear.
- **Copyeditor:** "protection from the platform" now reads "protection only against the platform operator".

**Left as is:** the em-dash in the "— dckc" attribution line under Prompt stays; it credits a quotation and the pedant didn't flag it. The copyeditor's other comment-only style notes are unchanged.

**Follow-ups:** none. The driver re-posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1388-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1032694 cached reads)
- Output: 6875 tokens
- Cost: $0.8450227999999999
- Wall-clock: 882s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
