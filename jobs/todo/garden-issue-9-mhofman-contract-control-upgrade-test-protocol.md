# #9 ymax0 — execute mhofman's definitive contract-control-upgrade test protocol (via inquisitor)
Repo: kriskowal/garden issue #9 — ymax0 XS value-stack overflow. **This is the definitive #9
validation — it consolidates the prior #9 guidance jobs; one owner runs the whole protocol.**

**mhofman** (trusted contributor; comment 4849982001, 2026-07-01T03:26Z) specified the exact test —
a **contract control upgrade test through inquisitor** for ymax0, in three steps:

1. **Baseline (prove the process works).** "Null-upgrade" ymax0 to the **current bundle** — release
   tag **Ymax v0.3.2606-beta2** (Agoric/agoric-sdk releases/tag/ymax-v0.3.2606-beta2; read the release
   artifact read-only). Exercise **contract control for ymax0** to perform the null upgrade and
   **confirm success: incarnation number increases + the expected log message.**
2. **Reproduce the failure.** **Install the beta3 bundle first**, then perform the contract-control
   upgrade; **confirm it FAILS due to the stack overflow** (capture the overflow signal / exit-12).
3. **Verify the fix.** **Install the patched beta3 bundle (with the flatMap fix)**, perform the
   contract-control upgrade, and **report whether it succeeds.**

**Report** all three outcomes on #9 (reply to mhofman) with **real evidence** — actual incarnation
numbers, the actual log messages, the actual overflow on step 2, and the step-3 success/failure. Per
the verification-integrity rule: cite real execution, do NOT assert results you didn't observe; if a
step couldn't run, say so honestly.

**Scope:** investigation on the bot's own repro infra / inquisitor. Reading the Agoric release tag +
bundles is **read-only reference**; do **NOT** comment on or link any artifact to upstream
Agoric/agoric-sdk. Bot identity.
