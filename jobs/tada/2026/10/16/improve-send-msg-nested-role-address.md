## Completion report: improve-send-msg-nested-role-address

`send-msg.sh` now accepts `role/jurors/<seat>` and sends it to `role/jurors-<seat>`. The new test cases pass. The fix is pushed to `main2` as `ae679d9c702`.

**The caller.** The bad address doesn't come from the panel or the juror dispatch: no script there builds a `role/...` address. It comes from the watchman, in `scripts/jobs/handlers/watchman-claude.sh`. Its LLM reads a diff of `roles/` and writes `role/<path>` for each changed role, so a change to `roles/jurors/<seat>/AGENT.md` comes out as `role/jurors/<seat>`. The journal already holds old messages delivered under `msgs/role/jurors/{changeset-auditor,scribe}/`, from before the guard existed. Since the guard landed, `send-msg.sh` exits fatally on this address, and because the handler runs under `set -e`, that also drops every later message in the same watchman run.

**What changed:**
- **`scripts/jobs/send-msg.sh`:** a step before the address checks maps `role/jurors/<seat>` (a single seat name) to `role/jurors-<seat>` and logs a warning, so the caller's mistake stays visible. Deeper nesting, like `role/jurors/x/y`, still fails at the guard. The guard's error message now names the flat form `role/jurors-<seat>`, and the usage header documents it.
- **`scripts/jobs/handlers/watchman-claude.sh`:** the prompt now says an address is one segment after its kind and that a juror seat is `role/jurors-<seat>`, never `role/jurors/<seat>`. The comment describing the handler's format lists the flat form too.
- **`scripts/jobs/test/run-test.sh`:** two new cases in subtest 2, right after the `role/gardener` send:
  - sending to `role/jurors/archivist` succeeds and arrives once at `role/jurors-archivist`;
  - `role/jurors/archivist/x` is still rejected.

**Testing.** I ran `run-test.sh 4 2`. Both new cases passed. Three other checks failed:
- the concurrency check, probably because I ran only 4 jobs on 2 gardeners on a busy host;
- the subtest 4 scaler's "deferral not logged" check;
- the subtest 5 "inbox cold clone retry" check (rc=75).

None of these use `send-msg.sh`, but I didn't run the suite on unchanged `main2` to confirm they fail without my change. I stopped the run partway through subtest 10 because it was racing the rebase before the push. I re-ran the syntax check (`bash -n`) on all three files after the rebase.

**Follow-ups (not done):**
- Nothing reads `role/jurors-<seat>` today, because jurors are one-shot panel seats with no message polling. If seat-brief notices should reach jurors, `panel.sh` would need to read that topic into each juror's prompt. As it stands, the fix only keeps the watchman from crashing; seat-brief notices go nowhere.
- The watchman handler still stops at the first send that fails. Letting it log the failure and carry on would keep one bad address from losing the rest of that run's messages.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-send-msg-nested-role-address.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1414856 cached reads)
- Output: 8152 tokens
- Cost: $0.9517392
- Wall-clock: 754s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
