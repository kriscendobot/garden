I reworked README § 2 "Control surfaces" so each lever leads with what a maintainer would say instead of the script behind it. It landed directly on `main2` as commit **054be70266e**; I found no open questions, so there was no PR.

**The Lever semantics table** now has five columns: `You say | What happens | What it does not reach | If it looks stuck, check | Mechanism`. The script name moved to the last column. Every "does not reach" caveat and every "check this other lever" pointer is kept word for word, including:
- a `go-ahead` gate never promotes itself;
- drain versus the foreman target;
- the sysop's benign versus attested tiers.

Two example rows:

| You say | What happens | What it does **not** reach | If it looks stuck, check | Mechanism |
| --- | --- | --- | --- | --- |
| "go ahead on X" / "promote X" | Moves one parked job to `todo/`; for a `go-ahead` gate, your explicit direction is the authorization. | Merely writing `gate: go-ahead` does not authorize, schedule, or auto-promote anything. The foreman auto-promotes only `deferred`. | Inspect `jobs/plan/<job>.md`, then promote explicitly (plan-queue procedure). | `promote-plan.sh <job>` |
| "throttle petunia to 2 workers", "drain petunia", "reset petunia's failed units", "restore petunia" | Sends a benign host op to that host's sysop, which applies `set-workers`, `drain`, `reset-failed`, or `restore` there. | It does not confer authority for `unit`, `deploy`, `local-model`, or `maintain`. | The latter tier needs a maintainer-authored `authorized_by: <login>` attestation. | `send-host-op.sh <GARDEN> op=…` (sysop benign tier) |

**Other prompt-first fixes in the same section:**
- The bold callout above the table now opens with "Saying 'go ahead on X' is the only thing that starts a parked job gated `go-ahead` or `awaiting-maintainer`."
- In the liaison subsection, "Answer workers" now tells you to answer in plain words; `maintainer-reply.sh` is only a trailing reference.
- In the GitHub-issues subsection, the latency paragraph now starts with asking the liaison "how fast are comments being acknowledged?"; the probe script is a parenthetical.
- The ferry subsection now opens with "Say **'ferry #96'** … then run `scripts/ferry.sh` yourself", instead of saving that for the end.

**One correction I found along the way:** README and `context/operations/scaling.md` both said the foreman's active target is 2. `scripts/systemd/garden-foreman.service` sets `GARDEN_FOREMAN_ACTIVE_TARGET=10`, which matches CLAUDE.md, so I changed both files to 10.

**Checks:**
- **Links:** every relative link in both edited files resolves.
- **Whitespace:** `git diff --check` is clean.
- **Other doc gates:** `scripts/checks/run-all.sh` reports 1 of 5 gates fired, `maintainer-inbox-information-hiding`. It flags `roles/botanist/AGENT.md` and `skills/foreign-content-preclassification/SKILL.md`, neither of which I touched. It most likely dates from the recent Jev commits (c6043712940 / 1f4dc4b82e5), though I didn't re-run it on the prior revision to confirm. The other four gates passed.

**Follow-up:** someone needs to fix that inbox-information-hiding gate failure in the botanist and foreign-content-preclassification files. The gate's output suggests the rewording; I left it alone because it's outside this job's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/doc-readme-control-surfaces-prompt-first.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (667004 cached reads)
- Output: 8637 tokens
- Cost: $0.7565008000000001
- Wall-clock: 453s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
