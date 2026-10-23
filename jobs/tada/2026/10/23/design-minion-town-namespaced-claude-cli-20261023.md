I wrote the design proposal and opened it as draft PR **kriscendobot/minion.town#217**. The PR is marked so no review panel runs, and nothing was built, enabled or deployed.

- **PR:** https://github.com/kriscendobot/minion.town/pull/217, from `design/namespaced-claude-cli` (commit `ad2b7f92`) against a frozen snapshot of `main` (`main-68c3960`).
- **Design file:** `designs/namespaced-claude-cli.md` (slug `namespaced-claude-cli`). The diff is that one file.
- **No gauntlet:** the PR body carries the `<!-- garden-design-open-questions -->` marker. It also says this is a deliberate, maintainer-directed use of that marker on a fork repo. I posted no gauntlet job.
- **Checks:** the one mermaid diagram parses, and the cliché and British-spelling greps found nothing.

**What the design settles:**
- **Unum:** I could not find or verify Josh Corbin's Unum or devoker; neither is public. pivoker is public, in `endojs/endo-but-for-bots` under `pivoker/`, but it is a Bash harness that runs a task queue under systemd and does no namespace confinement. The design makes no claims about Unum and asks the maintainer for its source.
- **Sandbox:** it builds on the open bwrap slice in endo PR 1408. Changes from that slice:
  - It drops the shared network: only `lo` exists, with no DNS.
  - It cuts the file set to the binary and its libraries on a read-only root.
  - It adds seccomp.
  - The only way out is a proxy reached through a unix socket, allowing only the Anthropic hosts Claude Code needs, with no TLS interception.
  - Each guest gets its own MCP socket, which fixes minion.town #149.
- **Terms of use:** this is the main finding. Anthropic's Claude Code legal page (fetched 2026-10-23) says third parties may not "collect, store, or intermediate Claude.ai credentials", and may not route requests through Free/Pro/Max credentials on behalf of their users.
  - That rules out the "authentication by proxy" idea, where a proxy holds the token and the CLI never sees it. The design keeps it as an option only with Anthropic's written agreement. It is also the only variant whose credential passes the bearer-token test from #180/#203.
  - It appears to conflict with what already ships: the stored `setup-token` from #119 and the root user's subscription serving other guests through delegation (#120, #140).
  - The only shape the page explicitly allows is each guest signing in to the unmodified CLI with their own subscription, through Anthropic's own flow. The design specifies that, with the login run inside the guest's sandbox.
- **Federated identity:** Anthropic's federation options (Workload Identity Federation, the Claude apps gateway) only cover API-billed or cloud-provider accounts. None carries a Pro/Max subscription.
- **Also covered:**
  - A comparison table against the Lal/Fae approach and today's backend.
  - Where this fits with the pinned responders (#165), delegation, `@endo/inference`, and what it would keep that endo #1543 would delete.
  - Host requirements: the AWS box is Ubuntu 24.04, which needs an AppArmor profile for bwrap.
  - An eight-phase plan, each phase one builder job, starting with a spike that runs `claude` end to end in the sandbox.
  - Ten open questions.

**Follow-ups:**
- **Not built yet:** the maintainer asked for discussion only, so I posted no build job. Any build waits for the maintainer to answer the open questions on #217.
- **Questions for Anthropic:** several open questions (1–5) should probably go to Anthropic before any phase that touches guests' credentials. That decision is the maintainer's.
- **Contradiction to settle:** endo #1543 says `--bare` rejects subscription tokens. A comment in the vendored `spawn-files.js` says a subscription token sent as `ANTHROPIC_AUTH_TOKEN` worked on CLI 2.1.280. I did not resolve this; the spike (Phase 1) is set up to.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/design-minion-town-namespaced-claude-cli-20261023.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3900981 cached reads)
- Output: 36552 tokens
- Cost: $4.127477600000001
- Wall-clock: 680s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
