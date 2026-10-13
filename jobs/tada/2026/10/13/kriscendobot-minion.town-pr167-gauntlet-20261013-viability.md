**Viability gate: kriscendobot/minion.town PR #167** ("design: non-interactive root MCP principal for the kriscendobot canary")

Verdict: **proceed**. The PR has not been superseded, and the need behind it still holds.

Deciding question: Does the base branch still lack any way for the fleet to sign in as kriscendobot's root over MCP without a person present, while the maintainer is still working on this design?

Evidence:
- **PR state:** open, not merged, still a draft. Base `main-a5a557a`, head `af8df333` on `design/root-canary-principal`. It changes one file, `designs/root-canary-principal.md`.
- **The maintainer is still working on it:** kriskowal left 8 inline review comments on 2026-10-13 at 04:59Z, answering the design's open questions. At 09:14Z the bot posted a "Maintainer-answer revision" folding all eight answers in, with "fresh design-panel gauntlet" as the next step. A critic seat had already looked at the revised head at 09:23Z. Restarting the gauntlet now is what the maintainer's answers call for.
- **No replacement exists:** I checked the 30 newest commits on `main` (through `a5a557a`, 2026-10-13), which covered dependabot bumps, prod-probe runner fixes (#182), credit metering (#174) and token-client-auth hardening (#94). None adds a root-canary principal.
  - The base file tree has no root-canary design or scripts. The only "canary" paths are `deploy/probe/canary*`, which are the probe site and unrelated.
  - `designs/claude-agents-capability.md` on base names the root canary as a step that still needs evidence ("a follow-up after the root-canary evidence exists"), so the gap remains.
- **Related open PRs complement it rather than replace it:** #171 validates the pinned harness through an SSM observer, and #183 is inference phase 3 (credentials and a prompt-origin gate). Neither gives the fleet a root session without a person signing in.
- **The need is current:** the PR exists because the #165 deploy validation stopped at the missing root session (kriscendobot/garden#89 items 4–5). Nothing on base has filled that gap, and the maintainer's answers this morning confirm the direction: kriscendobot's production root, sign-in and MFA as a one-time interactive step, minting limited to `endolin-garden1`.

I spent nothing on clean, panel, fix, CI-wait or un-draft work.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr167-gauntlet-20261013-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (221863 cached reads)
- Output: 2088 tokens
- Cost: $0.4527166
- Wall-clock: 146s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
