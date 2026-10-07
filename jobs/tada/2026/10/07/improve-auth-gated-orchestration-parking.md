## Completion report: improve-auth-gated-orchestration-parking

When a serial orchestration's validation child is blocked only by interactive MFA that the fleet cannot do, the orchestration now parks the remaining validation and sends the maintainer one action notice. It no longer halts as a failed deployment. The orchestration tests cover it and pass.

**What was already on `main2`:** a prior attempt landed `fa76a688ed7` ("fix(orchestrate): park auth-gated validation"). It handles the watcher side:
- `orchestrate.sh` reads `orchestration-auth-unavailable: true` in a finished child's report.
- A serial run then ends as `parked-auth-unavailable`, leaves the downstream children parked, and sends one notice keyed `<orch>-auth-unavailable`. It does not also send a child-failed or halted notice.
- `post-orchestration.sh --resume-from` can resume that parked campaign.
- Orchestrate-test subtest 17b covers it.

**What was missing, now pushed as `7ece247af52`:** there was no reliable way for a child to set that field. A worker could only type it into its report by hand, or emit the failure signal, which is what caused the minion.town#165 halt. The new signal works the same way as `<<<GARDEN-ORCHESTRATION-FAILED>>>`:
- **`common.sh`:** adds the `<<<GARDEN-ORCHESTRATION-AUTH-UNAVAILABLE>>>` marker and a detector that only counts it on the report's last line.
- **`complete-job.sh`:** a new `--orchestration-auth-unavailable` flag strips the marker and writes `orchestration-auth-unavailable: true` into the report's leading frontmatter.
- **`gardener.sh`:** sends that flag when the marker is present. The two places that append notes to a report (draft-gauntlet handoff, panel-head freshness) keep the marker as the last line.
- **`handlers/worker-common.sh`:** every worker prompt now tells a validation child to emit this marker, instead of the failure marker, when interactive auth is the only thing blocking it.
- **Docs:** `post-plan.sh` usage, `skills/orchestration/SKILL.md` and `roles/orchestrator/AGENT.md` describe the signal.
- **Tests:** `completion-signal-test.sh` gets detector tests (it is recognised as different from the failure marker, and only counts on the last line) and an end-to-end case, SUBTEST 2A2. The test stub gets `GARDEN_STUB_ORCHESTRATION_AUTH_UNAVAILABLE`.

**Verification:**
- `orchestrate-test.sh`: 79 passed, 0 failed, including 17b.
- I ran the new path by hand through `gardener.sh` → `complete-job.sh` with a stub child report. The finished report had `orchestration-auth-unavailable: true` at the top and no leftover marker.
- The new detector checks in `completion-signal-test.sh` pass.

**Known issue, not caused by this change:** the gardener end-to-end cases in `completion-signal-test.sh` fail on this host, including the new SUBTEST 2A2. The same cases also fail on an unmodified copy of `origin/main2`. In the test setup, claims are refused with "budget pool 'anthropic:test' is at its high-water mark", so the gardener never picks up a job. Raising the test's budget cap lets the claim through, which is how I ran the new path by hand. I did not fix the test setup.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-auth-gated-orchestration-parking.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 62 tokens (2500006 cached reads)
- Output: 13790 tokens
- Cost: $1.4912092000000001 (1 engagement(s) unpriced)
- Wall-clock: 3939s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
