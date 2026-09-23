Completed `design-proportional-worker-leveling`.

- Added `designs/proportional-worker-leveling.md` with:
  - Fleet-wide bounded apportionment for monks; current 143M:64M caps yield 4:2 ceilings.
  - Existing headroom, provenance, drain, dwell, confirmation, and step safeguards preserved.
  - Separate shared-account cleric allocation based on active and eligible queued demand.
  - Explicit composition with the future session-budget pace controller.
  - Safety invariants and implementation acceptance cases.
- Added the design to `designs/README.md`.
- Committed and pushed `e329ce97a0` to `main2`.
- Checks run: `git diff --check`, design-link existence check, `git show --check`; remote `main2` matches the committed SHA.
- Follow-up: mentat review, then a separate implementation job.
- Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-proportional-worker-leveling.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 451s

<!-- garden-usage-end -->
