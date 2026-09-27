---
handed-off: evaluate-reauth-escalation-default-after-oauth-relay-20260927
deliverable-complete: false
---
I didn't do the evaluation, because its prerequisite hasn't happened yet: there is still no browser OAuth relay. The foreman promoted this job only because it was parked with the auto-selectable `deferred` gate. I re-parked it as a new job that only the maintainer can promote.

**What I checked:**
- **minion.town `origin/main` (`561472a`, the merge of #96):** only the `claude setup-token` path ships. `designs/claude-agents-capability.md` § User-driven authentication still lists the browser OAuth relay (`claude auth login --claudeai`) as deferred. It stays deferred until a live run shows a stable callback and a non-interactive handoff.
- **Relay work:** no job, branch or PR builds the relay. The open Claude PRs (#105, #106, #119, #120) are about inference backends, reauth detection and delegation, not the relay.
- **The dependencies the job named:** `ebfb-endo-gateway-oauth-flow-design`, `design-endoclaw-oauth-caretaker-attenuation` and `minion-town-oauth-stage1`/`stage2` all finished in July. They cover MCP and user-login OAuth, not the Claude-subscription relay, so they don't count as progress.

**What changed:**
- I parked a successor, `evaluate-reauth-escalation-default-after-oauth-relay-20260927`, in `jobs/plan/` with `gate: go-ahead`, `role: designer` and `priority: low`. I confirmed it is on `origin/journal2`.
- It carries the original body plus a "Gate check history" section recording today's findings and what should trigger promotion.
- I chose `go-ahead` because `deferred` lets the foreman auto-promote the job whenever the board is idle, which is how it got promoted early. `blocked` doesn't fit because there's no relay job or PR to name as the blocker yet.
- No code or design files changed.

**Follow-up:** promote the successor once a job or PR exists for the relay and a live `--claudeai` run proves the callback works. If a relay job does get posted, re-park the successor as `--blocked --blocked-on <that job>` so it is promoted automatically when that job finishes.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/evaluate-reauth-escalation-default-after-oauth-relay.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (433579 cached reads)
- Output: 3891 tokens
- Cost: $0.5618798
- Wall-clock: 88s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
