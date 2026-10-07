## Retro report: endojs/endo-but-for-bots#1407, review 5410056994

**Verdict: review miss** (category `process`, severity moderate). It is recorded at `review-misses/misses/endojs-endo-but-for-bots-pr1407-review-1d8c37a5.md` on journal2. There was no earlier record, so the idempotency check passed.

**What I checked myself (PR, panel reviews and journal board):**
- **The review.** kriskowal asked for changes: a separate Unix socket per guest is an odd direction, because closing and cleaning up those sockets is error-prone for little gain. The harness and object-capability rules already confine the MCP process, so it should connect to the Endo root and look up the guest by its formula ID.
- **This is not new direction.**
  - kriskowal had already rejected per-guest sockets in the same design document (`designs/endo-guest-stdio-mcp.md`) on #1226, review 5231787250 on 2026-09-17. The merged design uses that lookup instead.
  - #1407 rebuilt the rejected mechanism anyway, and marked the design's open question about it as "resolved".
  - The builder's own completion report says the broker already used that lookup to restrict a root connection to one guest. The existing path already gave the boundary the feature was meant to add.
- **The panel had six code rounds** (2026-10-01 to 10-03), and every one ruled must-fix. The findings were the problems the maintainer predicted: revoking a guest's socket, revocation only working with `ENDO_GC=1`, shutdown noise, timing races, a guest being revived mid-issue, and a silent fallback to full host access. Each round added more mechanism. No seat asked whether the socket was needed.
- **Why no seat asked.** The decomplector juror has a "minimum viable abstraction" check that covers exactly this question, but it only sits on the design panel. #1407 was a code PR that made a design decision, so that check never ran.
- **Where the build came from.** It was item 4 of the bot's own follow-up list on #1371. The #1371 review job took the maintainer's "build" to mean building every item on that list.
- **The fix exists.** Fix job `fix-endo-pr1407-single-socket-guest-lookup` removed the socket code. #1407 merged on 2026-10-05 (`7a4e957410`) after kriskowal approved, and only the design document changed (+39/−45). The primary job's claim checks out.

**Cluster:** the miss joined `design-bespoke-mechanism-over-existing-path`. It now has 3 misses across 2 PRs (#1226 and #1407), so it is open and at the dispatch threshold. The cluster's previous note already said to dispatch once a second PR joined.

**Dispatched:** builder job `review-improve-design-bespoke-mechanism-over-existing-path`, identity `review-cluster:design-bespoke-mechanism-over-existing-path`. The cluster is now marked `improvement-dispatched`, with my reasoning recorded. The job has to deliver both halves:
- **Prevention:**
  - The builder and designer briefs require naming the existing path before adding a new channel, endpoint or formula type.
  - They must stop and ask the maintainer before reversing a maintainer decision made on an earlier PR.
  - A guard parks any bot-authored follow-up that reopens a design question, rather than building it on autopilot.
- **Detection:**
  - A panel-hints probe adds the decomplector to code PRs that touch `designs/*.md` or add a new socket, endpoint or formula type.
  - The decomplector's brief gets a code-panel mode.
  - A repeat-finding signal: if three or more rounds return must-fix findings on the same mechanism, the panel is forced to ask "is this needed?"
- **Re-review test:** the job must show the new checks would catch each past miss, run against the historical diffs.

The related held cluster `vestigial-mechanism-unquestioned` (#1125) is named in the job as supporting evidence; its status is unchanged.

**Follow-ups:**
- A second retro for this PR, `endojs-endo-but-for-bots-pr1407-review-4504ec86-retro`, is still parked in plan. If it joins this cluster, the writer won't dispatch a second improvement job because the cluster is already marked dispatched.
- No recurrence was detected (`recurrence=0`), so the maintainer was not alerted.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1407-review-1d8c37a5-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1145695 cached reads)
- Output: 10682 tokens
- Cost: $1.048803
- Wall-clock: 128s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
