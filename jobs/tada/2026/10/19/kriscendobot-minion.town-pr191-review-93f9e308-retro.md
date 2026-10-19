**Retro on kriscendobot/minion.town#191, review 5538982218: recorded as a review miss. It is a repeat of the `identity-gated-authority` pattern, which had been fixed and closed.**

**Idempotency.** No earlier record existed for `kriscendobot-minion.town-pr191-review-93f9e308`. The only #191 record in the store is a dismissal for a different job (`-9f800189`, comment 6201208707).

**Verdict: miss.** Category `security-hardening`, severity moderate, joined to cluster `identity-gated-authority`. I based this on the PR itself, the board and the store, not on the primary's report:
- **What the draft did.** The reviewed draft (`1c3cea0ae2`) asked "which AWS principal may read the root-canary secret". All three of its options gave that authority to a principal named in a trust policy (IAM Roles Anywhere, the shared `garden-fleet` IAM user, an EC2 instance). It took this from the accepted #167 design.
- **The rule it broke.** The designer brief line added on 2026-10-07 (`2782d6294d`) was written for exactly this cluster. It says not to use an owner, principal, subject or caller allowlist, and not to treat an existing identity gate as precedent. It did not stop the draft. The maintainer's ocap reframing (the secret formula identifier is the capability, kept on the host) was already the standing direction for minion.town.
- **Why review never caught it.**
  - #167 passed seven design-panel rounds and merged without the locksmith seat raising the IAM reader role.
  - The only gauntlet on #191 halted at 19:26Z because the PR targets the moving `main` branch, so no panel ran before the maintainer's 19:46Z review.
  - The locksmith probe (`C-locksmith.sh`) only matches code-style checks such as owner equality and allowlists. It would not fire on design prose like "trust policy permits only X".

**Primary job checked.** Its claimed fix is real. Head `2f0fe4f9bb` has the five-session authentication table, keeps the secret on `endolin-garden1` only, and covers the `claude` and `codex` rows. The bot's thread reply (discussion_r4288116388) exists. No discrepancy.

**Store changes** (on journal2, through `review-miss-record.sh`):
- `review-misses/misses/kriscendobot-minion.town-pr191-review-93f9e308.md` written, with a paraphrased body and the URL; no raw review text.
- The cluster now holds 2 misses across 2 PRs (#85, #191) and was reopened. The writer flagged it as a genuine repeat after the fix (`recurrence=1 drain_reopen=0`) and sent the maintainer alert under `review-miss-recurrence-identity-gated-authority`. I did not send a second alert.
- **No improvement job dispatched.** 2 misses is below the 3-miss floor, and a reopened cluster waits for the maintainer instead of starting a second round automatically. That decision and its reasons are recorded on the cluster.

**Follow-ups, for the maintainer to decide:**
- Widen the designer brief line to cover infrastructure identity gates (IAM trust policies, host or instance identity) where a capability secret held on the host would do.
- Give the locksmith probe a design-prose check.
- Look into why design-PR gauntlets on minion.town halt on the floating-`main` check and reach the maintainer without any panel.

Self-improvement: nothing to add. The skill's procedure fit this case.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr191-review-93f9e308-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (968825 cached reads)
- Output: 8960 tokens
- Cost: $0.967533
- Wall-clock: 136s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
