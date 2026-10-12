I ran round 1 of the panel on PR #183. It came back **must-fix** and I posted the verdict on the PR.

**What happened**
- I set up an isolated checkout of `kriscendobot/minion.town` on `build/inference-phase3-secrets` at head `1380e9e` and ran `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh … 183 main-bc11010`. It exited 0 with `code-panel single-round — must-fix`, and all 33 seats returned `ok`.
- My first launch was a background run whose 10-minute limit was too short, so I killed it after about a minute. That left an interrupted record (`8f245d76a29b`). The clean run that produced the verdict is recorded at `panel-runs/kriscendobot-minion.town-183/ab4bfa8ee315.md`.
- I posted the verdict as a formal review: https://github.com/kriscendobot/minion.town/pull/183#pullrequestreview-5496940879. It has the panel-verdict shape: a header listing must-fix items (in scope), selected should-fix items and an out-of-scope section, followed by every seat's output.
  - The review was posted as `COMMENTED`, not request-changes. GitHub refused request-changes because kriscendobot opened the PR and can't request changes on its own PR. The must-fix verdict is stated in the body.
  - The full aggregate was about 94 KB, over GitHub's review size limit. The 5 request-changes seats are included in full; the other seats' output is cut short and marked as such. The full text is in the run directory's `round-1.md`.

**Must-fix items**
1. **locksmith:** `readSecret` trusts the `secretName` stored in the on-disk state file, so anything that can write the state directory can point a subject at another secret. The fix is to re-derive the name with `secretNameFor(subject)` on read.
2. **prover:** the security wiring has no test. Reverting any of the three production wiring changes leaves every test green.
3. **migrator:** the root `providerFor` gate removes every non-root-authored path with no deprecation step.
4. **corner-prober:** migrating a legacy `version: 1` record has no unit test. The integration test does have one legacy fixture, so the fixer should check how far this claim holds.
5. **corner-prober:** concurrent first reads of a legacy record are untested and can collide in `createBase64`.
6. **pruner:** the PR description is padded (475 words).

**For the fix stage:** the PR head moved while the panel ran. Two commits were pushed at 23:06 and 23:09 UTC, so the head is now `8428fb3`, which is the commit the review attached to. They are a `package-lock.json` bump and a refactor that adds a `credentialStateFileNameFor` helper. Neither addresses any must-fix item, so the verdict still applies to the current head.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr183-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1761473 cached reads)
- Output: 7985 tokens
- Cost: $1.0702425999999998
- Wall-clock: 233s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
