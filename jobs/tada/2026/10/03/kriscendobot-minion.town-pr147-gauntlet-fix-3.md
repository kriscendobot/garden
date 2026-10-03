I fixed every must-fix item from round 3 of the panel review on kriscendobot/minion.town#147 in one commit, pushed it to the PR, and CI passed (all 3 checks green). I did not re-run the panel; the driver will post panel round 4.

**Commit:** `4e03a39`, pushed to `design/mcp-resources-getting-started`, moving the head forward from `b93e5cc`. Only `designs/mcp-resources-getting-started.md` changed (+33/−22).

**Must-fix items:**
- **Build order (critic):** § 8 now runs the harness and baseline as slice 2, before any resource ships. The serving PR moves to slice 3, with an explicit note not to merge it until the baseline is recorded, because merging to `main` deploys it.
- **Sessions losing their files (skeptic, decomplector):** I took the decomplector's simpler fix. A session now reads every resource body into memory when it starts (40 KB total at most), and reads never go back to disk. A long-lived session therefore can't lose its copy when old copies are pruned. I removed the claim about a session idle timeout, which the code doesn't have. Pruning is now free; the deploy scripts keep the newest five copies only for rollback. I updated the matching text in Figure 1 and the § 5 table.
- **"mount" undefined (novice):** § 3.2 now defines a mount (the `clips` and `submit` tool groups, enabled per session) and a session's mounts.
- **Wording (copyeditor):** § 3.1 now says "five ways… uses two and rejects three", and the `guide/clips` row now has subject-verb agreement.

**Should-fix items also done:**
- The "…" characters are now plain ASCII `...`.
- `guide/troubleshooting` now has the same body in every session: it always ends with a pointer to `minion-town://guide/clips`, instead of a line that appears only when clip tools are mounted.
- `back` now has a short definition where § 3.3 first uses it.

**Left for later:** five should-fix and comment-only suggestions. These are:
- tasks for two troubleshooting entries the test suite never triggers;
- moving the facts in the `instructions` string into `resources/`;
- linking the companion designs consistently in the body;
- the ergonomist's notes;
- splitting the pass-bar sentence in § 6.4 into a list.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 26 tokens (762664 cached reads)
- Output: 5559 tokens
- Cost: $0.7329048000000002
- Wall-clock: 310s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
