Both reconciliations confirmed present in the landed commit (the earlier `0` was just a line-wrap artifact). The job is fully complete.

## Completion report — register Fireworks GLM 5.2 as a mentor model (resumed)

**Status:** already completed in the prior session; the requeue lost no work. Verified on resume — working tree clean, landed commit intact on origin/main2.

**Landed on main2:** `8c5971b8bb` (github.com/kriskowal/garden, direct to main2, no PR). Now sits under newer peer commits (current origin/main2 tip `dd3eec1c2c`); `git branch -r --contains` confirms my commit is on origin/main2 and its content is present.

**What this job delivered:**
- The GLM 5.2 mentor registration itself was already landed by prior commits (`aead286daf`, `172d086c87` #69, `ff5dba6b33`): the live verified selector `accounts/fireworks/models/glm-5p2` lives in the closed inventory as `fireworks/accounts/fireworks/models/glm-5p2` (garden `fireworks/` namespace, stripped before the wire), classified **mentor**; routing defaults, the `--provider-canary fireworks mentor` mechanism, resolver, and hermetic tests all present and correct; no wildcard classification survives.
- My commit closed the two remaining reconciliation gaps:
  - `designs/provider-model-catalog.md` §2.7 was updated from "one reviewed Fireworks selector" to the full **four-selector** closed inventory (glm-5p2/mentor, kimi-k3/mentor, deepseek-v4-pro/minion, gpt-oss-120b/myrmidon), naming the first-match GLM-vs-K3 mentor collision, the fail-closed contract, and the Moonshot-K3-lane separation.
  - `context/operations/fireworks.md` gained the discriminating secret-safe availability probe and a **probe of record (2026-08-01)**: GLM 5.2 wire id recognized/live (bogus control 404s, GLM returns 412), auth accepted, but the account has an unmet precondition — canary blocked on clearing billing/terms, not on any garden-side defect.

**Verification (done in prior session, still valid):** resolver exercised hermetically (`mentor→glm-5p2`, `minion→deepseek-v4-pro`, `myrmidon→gpt-oss-120b`; `mentat`/bogus fail closed); `fireworker-harness`, `worker-spine-kinds`, `model-routing` suites pass; `bash -n` clean; secret-safe live probe emitted only HTTP status codes.

**Deploy/activation:** advance the deployed root via the deliberate drained `scripts/jobs/deploy-garden.sh` (signalled by `garden-upgrade-monitor`) — not a manual fast-forward. Then inside `./garden sh`: re-run the per-model probe; on **200**, `set-fireworkers.sh 1` → `post-job.sh --provider-canary fireworks mentor fireworks-glm52-canary canary.md` (body carries provider+tier only, never a concrete model) → confirm the `tada/` report shows `worker_kind: fireworker` / provider `fireworks` / model `fireworks/accounts/fireworks/models/glm-5p2` with tool-verified evidence → `set-fireworkers.sh 0`.

**Follow-ups:** (1) canary blocked on a Fireworks **account precondition** (412), not a garden defect — clear billing/terms then re-probe; out of a gardener's authority. (2) Pre-existing unrelated failure: `tier-vocabulary-routing-test.sh` "designer/builder default" expects Codex but code returns Opus per CLAUDE.md — stale test, worth a separate alignment fix. (3) The mentor-tier GLM/K3 collision remains a documented maintainer routing decision.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-fireworks-glm52-register.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 7 tokens (242511 cached reads)
- Output: 2635 tokens
- Cost: $0.8046054999999999 (2 engagement(s) unpriced)
- Wall-clock: 2832s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
