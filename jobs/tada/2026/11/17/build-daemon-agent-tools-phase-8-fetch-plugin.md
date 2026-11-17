I didn't build anything or open a PR, because Phase 8 has already been built twice and a third PR would only duplicate it.

- **Already built:** draft PR [#1661](https://github.com/endojs/endo-but-for-bots/pull/1661) is the Phase 8 build that makes the `@endo/fetch` plugin the canonical HTTP provisioning path and adds HTTP to the composed workspace tools. It came from the job `build-daemon-agent-tools-phase-eight-fetch-plugin`, finished 2026-11-15. My job is the same request again, only with "8" in the name where the earlier one had "eight". `ensure-pr.sh` searches by job name, so it didn't find #1661.
- **Overlap:** [#1593](https://github.com/endojs/endo-but-for-bots/pull/1593) ("compose HTTP workspace tools") changes the same files. The viability stage of #1661's gauntlet judged #1661 overtaken by #1593 and stopped there, with no clean, panel or fix-loop pass. It is waiting on your decision. Its recommendation is to close #1661 and review #1593; the alternative is to close #1593 and run the gauntlet on #1661.
- **Design not settled:** the Phase 8 heading only exists in design PR [#1497](https://github.com/endojs/endo-but-for-bots/pull/1497), which hasn't merged. The single-package `@endo/fetch` plugin is also disputed by draft #1588, which splits it into an unconfined base plus a separate `@endo/confined-fetch`.

I sent you this summary through the maintainer inbox. There is also a parked, reaper-doomed copy of the same job, `build-daemon-agent-tools-phase-8-fetch-plugin-20261106`, in `jobs/plan/`. Delete it so this request doesn't come back a fourth time.

**Decision for you:** which of #1661 and #1593 to keep. Once #1497 merges, the Phase 8 checkboxes can be ticked against whichever PR survives.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-daemon-agent-tools-phase-8-fetch-plugin.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (696619 cached reads)
- Output: 4027 tokens
- Cost: $0.6605517999999999
- Wall-clock: 699s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
