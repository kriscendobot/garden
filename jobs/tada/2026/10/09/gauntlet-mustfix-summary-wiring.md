The must-fix summary now shows up wherever a gauntlet stops early (review budget reached, halted, or parked on CI billing). It's on main2 as `fad05c57898`, and `scripts/jobs/test/gauntlet-test.sh` passes 93/93.

**What changed in `scripts/jobs/gauntlet.sh`:**
- **Two new helpers.**
  - `gauntlet_mustfix_block` runs the existing renderer. It caps the output at 40 lines and closes any code fence the cut leaves open. If the renderer fails or can't parse a report, it prints nothing and still returns 0, so it can't stall a tick or lose the terminal state.
  - `gauntlet_resume_hint` prints the exact resume command (`scripts/jobs/gauntlet.sh --resume-from-stage <base> panel --add-rounds 2`) and what it adds ("2 more panel/fix round(s): max_iterations M -> M+2"). For a halt, it names the stalled stage plus `--iteration`.
- **(a) PR comment:** the one-line receipt is unchanged. The summary now follows it in a collapsed `<details>` block under the same idempotency marker.
- **(b) Maintainer notice:** the halted and parked notices now include the summary and the resume command. A review-budget stop previously sent the maintainer no notice at all; it now sends one with both. Held-draft still gets none.
- **(c) Journal record:** the gauntlet's own terminal report in `jobs/tada/` gets an `## Unaddressed must-fix` section. It sits inside that report rather than in a separate file, so it lands in the same commit as the terminal state.

**Docs:** `roles/proxy/AGENT.md` has a new section saying the minion.town arc supervisors act on this record, not the maintainer, and pointing to the 2026-10-07 message. Endo PRs stay on maintainer review.

**Tests:**
- The review-budget case checks that the comment block is collapsed with balanced fences, the summary is in the terminal report, and the notice has the summary, resume command and budget wording.
- The halt case checks the notice carries the resume command.
- I did not add a test for parked-ci-billing. It goes through the same halt code as `halted`, but it has no test of its own.
- A summary-renderer failure is only covered indirectly: the existing failed-comment test passes and the helper always returns 0. No test injects a crash in the renderer itself.

**Journal message:** sent to the maintainer inbox. The worked example comes from the real #995 halt (`endojs-endo-but-for-bots-pr995-gauntlet`, 6 rounds). Its panel reports came before the structured must-fix list, so it shows the reduced form: "Unaddressed must-fix: unknown · list unavailable (panel report has no structured must-fix list) · rounds spent: 6 · cost so far: $61.19". Panel reports written from now on will get the full summary.

**Follow-ups:**
- The resume hint suggests 2 rounds by default; the maintainer can choose any number.
- Older halt reports never get the full list.
- Add a parked-ci-billing test and an injected renderer-failure test.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/gauntlet-mustfix-summary-wiring.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1077125 cached reads)
- Output: 11978 tokens
- Cost: $0.9897369999999999
- Wall-clock: 324s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
