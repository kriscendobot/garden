# Mirror PR #1 — fix the two UPSTREAM #320 CI failures (reproduce locally; fork CI can't be trusted)
Repo: **kriscendobot/agoric-3-proposals** (BOT FORK; bot identity). **PR #1** (our mirror of upstream #320)
— branch `add-proposals-111-116`, head e37b4f027 — https://github.com/kriscendobot/agoric-3-proposals/pull/1.
The prior feedback job (`agoric-3-proposals-mirror-pr1-address-320-feedback-and-ci`, tada) advanced #1 but
**upstream Agoric/agoric-3-proposals#320 still fails two CI checks**:
1. **`test-packages`**
2. **`proposals-matrix-test / build`**
**HARD SCOPE:** read upstream #320 + its failing CI logs **READ-ONLY** for the actual errors. Do NOT
comment on / push to upstream Agoric/agoric-3-proposals. Fix on the FORK branch; all artifacts on PR #1.
**Task:**
1. Read the #320 job logs (read-only) for **`test-packages`** and **`proposals-matrix-test / build`** to get
   the concrete errors.
2. **Reproduce each failure locally / on the fork** — the fork PR #1's CI may NOT run Agoric's full suite,
   so a green fork check does NOT mean it's fixed (same trap as the #58 test-harness-vs-real-usage bug).
   Run the actual `test-packages` and the `proposals-matrix-test` build steps locally against the branch.
3. Fix the root causes, push to `add-proposals-111-116` on the fork, and **confirm the reproduced failures
   now pass locally**.
4. Post a **summary comment on the FORK PR #1**: each failure, the fix, and the reproduced-then-passing
   evidence. Verification-integrity: cite what you actually ran; honest "couldn't reproduce X locally" beats
   asserting a fix. Preserve the prior work (proposals 111–116, bundles, documented omitted 113, changeset).
Bot fork; no upstream Agoric contact.

---
claim:
  host: endolinbot2
  gardener: 83
  claimed_at: 2026-07-01T22:29:13Z
