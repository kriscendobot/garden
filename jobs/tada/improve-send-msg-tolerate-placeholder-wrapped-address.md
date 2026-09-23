Pushed cleanly to main2.

## Completion report

**Job:** `improve-send-msg-tolerate-placeholder-wrapped-address`

**What I did:** In `scripts/jobs/send-msg.sh`, added deterministic recovery for an unsubstituted template placeholder address immediately before the existing validation `case`.

**What changed:** When `$addr` matches a `<...>`-wrapped form, the script now strips a leading `<` and optional `address:` label, strips the trailing `>`, and trims surrounding whitespace to extract the inner candidate `X`. If `X` is itself well-formed (`role/?*`, `job/?*`, or `broadcast`), it sets `addr=X`, emits a `log` warning that an angle-bracket-wrapped placeholder was unwrapped (keeping the agent-side defect visible), and proceeds to send. A genuinely malformed unwrapped value falls through to the existing `die`. This converts the 2026-06-29 21:38 message-losing `[send] FATAL` (which dropped a valid `role/web-designer` message wrapped as `<address: role/web-designer>`) into a logged, recovered send while preserving the hard failure for malformed addresses.

**Verification:** Tested the unwrap logic against all spec'd forms (`<address: role/web-designer>`, `<role/web-designer>`, `<job/foo>`, `<broadcast>`, `<address:job/bar>` → unwrap; `<garbage>` → fall through; bare `role/web-designer` → untouched). `bash -n` passes; shellcheck shows only the pre-existing annotated SC1091 source info.

**Commit:** `cabd3e06a`, pushed to `origin/main2`.

**Follow-ups:** None. The change is self-contained; the placeholder-substitution responsibility now lives in the script rather than relying on the calling agent.
