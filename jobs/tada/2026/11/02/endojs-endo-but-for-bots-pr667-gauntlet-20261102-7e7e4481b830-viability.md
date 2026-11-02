**Viability report: endojs/endo-but-for-bots PR #667** (`feat(genie): stdio JSONL RPC bridge (endopi-stdio-rpc-bridge)`)

The gauntlet can start. The PR is open, not a draft, and GitHub reports it MERGEABLE. Its base is the frozen `llm-9a14ddf`, which is only 4 commits behind `llm`. The head is `7e7e4481b8`. Nothing has replaced it, and the need it was opened for still exists.

Deciding question: Does `llm` still lack a stdio JSONL RPC bridge for the agent loop, with the `endopi-stdio-rpc-bridge` design still open, so this PR is still the only implementation of a live need?

Answer: yes.

Evidence:
- **Design still open:** `designs/endopi-stdio-rpc-bridge.md` on `llm` is still listed in the design index (`designs/README.md`, line 511) as **In Progress**. It is also still in the roadmap table as an M-sized item ("LF-delimited JSONL RPC for embedding the Lal/Fae agent in another process; short-term shape before `endor-bus-tui`"). It has not been marked Superseded, Abandoned or Implemented.
- **Nothing else on `llm` does this:**
  - `packages/agentry/src/rpc/` does not exist on `llm`.
  - Code search finds `serveRpc` and the bridge only in this PR. The one `makeLineDecoder` hit is in `packages/claude/src/cli-backend.js`, which decodes the Claude CLI's own output stream rather than serving a bridge.
  - No other PR, open or closed, implements a stdio RPC bridge.
  - `endo-guest-stdio-mcp` is a different surface (MCP for guests).
- **Moving packages didn't change the purpose:** `@endo/genie` was retired on `llm` (42bc7d5161). On 2026-07-13 kriskowal asked for changes: "refresh this but move these facilities into agentry or agent-tools." The 2026-10-30 weave did exactly that and moved the bridge into `@endo/agentry`. The requested direction itself confirms the work is still wanted.
- **Earlier review passed:** the code panel review on 2026-07-10 passed with no must-fix items. The remaining blocker is kriskowal's re-review after the move, which has been requested.

Caveat for later stages: the spawnable `rpc.js` runnable was dropped along with genie, so nothing on `llm` launches the bridge as a process yet. The weave comment offers that as a possible follow-up. The protocol core is still what the design asks for.

I spent nothing on clean, panel, fix, CI-wait or un-draft work, and changed no files.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr667-gauntlet-20261102-7e7e4481b830-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (369458 cached reads)
- Output: 3335 tokens
- Cost: $0.5586636
- Wall-clock: 47s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
