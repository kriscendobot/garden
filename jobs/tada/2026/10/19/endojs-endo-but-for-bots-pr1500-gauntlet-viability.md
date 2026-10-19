Viability is **proceed**. PR #1500 is open, still a draft, and was opened today (2026-10-19). Nothing has replaced it and the need behind it still holds, so the gauntlet can start.

Deciding question: Does `llm` (or another open PR) already provide a streamable-HTTP `POST /mcp` endpoint for `endo-gateway-mcp` Phase 3, or has the design dropped the idea of an MCP-over-HTTP endpoint for external clients? **No.**

Evidence:
- **PR state:** open, unmerged and draft, with no reviews or comments yet. The base `llm-ca5aaef` is identical to the current `llm` tip (the compare shows 0 commits ahead and 0 behind), so no newer base history needs checking.
- **Not on `llm`:** `packages/agent-mcp-stdio/src/` on `llm` has no `http.js`, only the transport-free projection and the stdio server, which this PR builds on. `designs/README.md` on `llm` still lists `endo-gateway-mcp` as "Not Started", and its M6 "P1: MCP JSON-RPC termination" row is also "Not Started". The premise still holds.
- **No competing PR:** searching for "mcp http" finds only #1500. The related open PRs either build on it or don't overlap:
  - #1499 (Phase 4, Chat "+ Add agent") is stacked on #1500's head branch. It depends on this PR rather than replacing it.
  - #1409 (pruning the catalog at the guest broker) works on the stdio side.
  - #1404 (draft: guests no longer produce or consume ids) removes id methods from the guest API. #1500 resolves bearers through the user's own daemon session (`lookupById` plus a guest-facet check), not through guest powers, so it is not superseded. If #1404 lands first, #1500 may need a rebase.
- **Scope:** the PR's evidence ledger marks Phases 1 and 2 as superseded with reasons and Phase 3 as partial. The remaining work is assigned to the successor `build-endo-gateway-mcp-remaining-phases`, so the PR knowingly delivers part of the design and is not an outdated duplicate.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1500-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (239967 cached reads)
- Output: 1772 tokens
- Cost: $0.47624940000000004
- Wall-clock: 27s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
