---
orchestration-failed: true
---
orchestration-failed: true

**CI is red on the fix commit, so I'm not reporting `fix=done`.** The panel-4 fixes are pushed to PR #250 as `e3c78e91` (was `ab0b29d9`), but CI never ran on that commit. `ci-wait-merge` returned rc 3.

## CI failure
- **Symptom:** in [run 41982294057](https://github.com/kriscendobot/minion.town/actions/runs/41982294057), `changes` and `test` failed in about 2 seconds with 0 steps and no runner, and the harness job was skipped. One rerun failed the same way.
- **Likely cause:** this looks like the Actions billing refusal, not the diff, which only touches a design doc. The last hosted run that passed started at 06:20Z.
- **Not confirmed:** this host's PAT gets a 403 on check-run annotations, so I can't read the refusal message. That is also probably why the script returned rc 3 rather than rc 5, so I did not emit `ci-billing-blocked`.
- **Runner switch:** I did not change `CI_RUNS_ON`. The PAT gets a 403 reading Actions variables and runners, and the runner-switch skill requires confirming the billing message first.
- **Maintainer alert:** sent as `msg-kriscendobot-minion.town-pr250-gauntlet-fix-4-ef075f2eb6db`, because the billing watchdog may not have fired. It asks for the annotations on job 127094943638 to be read from a host with `checks:read`.

## Panel-4 fixes
All changes are in `designs/api-key-agent-directory-authorization.md`. Nothing was executed, since CI didn't run and no local tests apply to a docs-only change. The new isolation contract comes from reading the code and deploy config.

| Juror | Fix |
|---|---|
| **critic** | Owner list, get, create, recovery, and lifecycle actions now commit to one owner-wide CapTP facet. REST stays permanent only for the page load and the locator mint. A new migration section covers the door, facet, holder, cutover, and new actions, and the shell session is named as a prerequisite to build. |
| **skeptic** (real factory) | The real-factory integration test is now an adoption gate rather than a follow-up. Until both gates pass in CI, the decision stays proposed and production may not set `API_KEY_GUEST_AGENTS=1`. |
| **skeptic** (Clip) | Added a Clip isolation contract and a hostile-Clip browser test as a second gate, with a relaxed-CSP variant and a positive control. |
| **novice** | Added "The question" and a capability table (holder, scope, operations) before the Decision section. |
| **pedant** | Replaced the section sign with "the Decision section". |

While checking the Clip contract, I found that legacy `<hash>.weblet.minion.town` hosts are still served and are same-site with `minion.town`, so `SameSite=Lax` doesn't protect them. A directly opened Clip also has no sandbox. The contract and the second gate now cover both cases.

## Follow-ups
1. Confirm the block from a host with `checks:read`, and apply `skills/minion-town-ci-runner-switch` if it is billing. Then rerun CI on `e3c78e91` and resume the gauntlet at panel 5; no new fix is needed unless CI shows a real failure.
2. **Garden bug:** `actions_billing_blocked` in `ci-wait-merge.sh` can't see billing refusals with this PAT, so they look like ordinary red CI. I added this to the existing memory note but did not fix it.
3. **Not in this PR:** both gating tests and the CapTP migration are design commitments only, and `DEPLOYMENT.md` doesn't mention the new `API_KEY_GUEST_AGENTS` gate yet.
4. My last inbox check didn't finish, so any message that arrived after the first check at claim time is unread.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1796344 cached reads)
- Output: 28573 tokens
- Cost: $1.7889127999999999
- Wall-clock: 1623s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
