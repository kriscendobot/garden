Implemented and pushed commit `d6de577a02` to `main2`.

- Scheduled Dependabot rechecks now run the live declaration-compatibility oracle before dispatch.
- Proven Node-engine conflicts receive deterministic evidence and cheap reverify-and-close instructions.
- Uncertain or failed checks continue through the ordinary full review path.
- Added atomic scheduler support for preflight-generated routing context.
- Added regression coverage for the `better-sqlite3@13`/Node 20 scenario.

Verification:

- Core job-system suite: 383 passed.
- Dependabot preflight: 23 passed.
- Scheduler admission: 21 passed.
- Dependabot watcher: 50 passed.
- Compatibility and anchored-scheduler tests passed.
- Four repository checks passed. The unrelated inventory-drift check remains red for three pre-existing unindexed role/skill entries.

Self-improvement: `skills/schedule/SKILL.md`; documented the new preflight-context contract.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-dependabotany-runtime-compat.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 559s

<!-- garden-usage-end -->
