All work is complete and pushed to `main2` (`ef591a3370`).

## Completion report

**Job:** `kimi-k3-takes-opus-work-with-opus-fallback` (designer + implementation). Directive: *kimi-k3 starts taking work away from opus, for evaluation, with an automatic opus retry if kimi fails.*

**What I did** — resolved the blocking tension (opus's exclusive work is exactly what a mystic is barred from) by building the fallback **first**, then relaxing the bar **behind it**, shipped **disabled by default**.

### Design
`designs/kimi-k3-takes-opus-work-with-opus-fallback.md` (+ README index row): graduated **builder-first** relaxation, a failure taxonomy mapped to existing reaper signals, the re-route mechanism, the one-hop ping-pong bound, the evaluation metric (acceptance-first, cost-second, fallbacks charged to kimi so the comparison can't lie), operational scope/share, phasing, open questions, and a stated kill switch. Mermaid validated (parse-only).

### Implementation (all landed)
- **`common.sh`**: `reroute_job_model` (pure frontmatter transform — advance `model:` to the `fallback-model:` chain head, pop it into `model-burned:`) and `kimi_fallback_enabled` (reads per-instance journal flag `config/kimi-takes-opus-work`, default off).
- **`reaper.sh`**: on a **genuine** failure requeue (not outage, not productive) of a kimi-k3 job carrying a fallback chain, re-route `model:` to opus so an opus gardener claims the **same base**, reset the reap counter, and record the kimi arm `accepted: false`. Bounded to one hop.
- **`claim-job.sh`**: a mystic may claim a `role:builder` kimi-k3 job **only when armed AND it carries a fallback chain**; designer stays barred.
- **`set-kimi-fallback.sh on|off`**: the finer kill switch (`set-mystics.sh 0` is the blunt one) — both journal-state, no code edit.

**Session/worktree freshness** is correct by construction (opus finds no Claude transcript for a re-routed base and resets the leftover worktree) — proven by the test, not asserted.

### Demonstration
`test/kimi-opus-fallback-test.sh` — **26/26 assertions pass**, including the DoD crux: a deliberately-failed kimi job re-routes to opus, **fresh session (`--session-id`, not `--resume`), in a clean worktree, exactly once, bounded**, with the kimi-arm failure event written and the whole thing gated off by the flag. Adjacent suites (worker-spine 136/0, reaper-live-guard 3/0, poison-park 7/0, outage-pause 10/0, productive-cycle 10/0) still green.

**To turn it on** (a maintainer decision, off by default): `set-kimi-fallback.sh on`, then post builder jobs with `model: kimi-k3` + `fallback-model: opus`.

**Follow-ups (designed, deferred to phase 2):** a "completed-but-bad" board edge so a panel rejection triggers a fallback; auto-stamping a tunable share of builder jobs; designer graduation. Cost-ranking depends on the open `build-token-cost-ledger`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kimi-k3-takes-opus-work-with-opus-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 137 tokens (11633322 cached reads)
- Output: 74403 tokens
- Cost: $11.4697755
- Wall-clock: 1404s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
