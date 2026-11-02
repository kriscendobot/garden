**Viability: proceed.** PR #1636 is current and nothing has replaced it. I spent no gauntlet budget (no clean, panel, fix or CI-wait work).

**PR facts:** It's open, unmerged and a draft, opened 2026-11-02T01:28Z. The head is `feat/ocapn-noise-hint-grammar` @ d7d7e4ae, and the base is the frozen `llm-48d6f3e` (48d6f3e0). It has no comments or reviews yet. It touches five files and only adds code: `packages/ocapn-noise/src/hints.js`, a test file, a README section, one `package.json` export and a changeset.

Deciding question: Does `llm` still lack a `<transport>+<codec>` hint-grammar module, while the live `designs/ocapn-network-transport-separation.md` still calls for that grammar (Migration Plan step 1)?

Evidence:
- **Not superseded:**
  - `packages/ocapn-noise/src` on `llm` contains only `bindings.js`, `bytewise-compare.js`, `network.js`, `transports/`, `types.d.ts` and `wasm/`. There is no hints module, and a code search for `parseHintKey` finds nothing.
  - The last `ocapn-noise` commits on `llm` are 2026-10-01 handshake and settlement fixes plus Dependabot bumps. None of them adds a hint grammar.
  - No other PR, open or merged, implements this. The related open PRs are not substitutes: #1072 (single TCP hint), #1013 (relative-routing design), and #1513, #1507 and #1477 (framing, listen split, session key). The PR body says it is independent of all of them.
- **Premise holds:**
  - The design on `llm` still has status "In Progress". Its last edit was 2026-08-31 (#1071), and it still defines the combination as `<transport>+<codec>` with `tcp+cbor` as a `host:port` value.
  - Its § Target Model still describes splitting each component on the first `:`, and it still uses the `@wss+cbor:…@tcp+cbor:…` locator example. That is exactly what the PR implements.
- **Base is current:** comparing `48d6f3e0...llm` shows ahead 0 and behind 0, so the frozen base is the current `llm` tip and no newer history changes the picture.
- **Open but not blocking:** the PR body flags the list-versus-table question from the #1072 reviews. The module handles one hint at a time and works either way, so this doesn't affect viability. The panel may still raise it.

No follow-ups. The gauntlet can begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1636-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (181938 cached reads)
- Output: 1951 tokens
- Cost: $0.45407959999999997
- Wall-clock: 28s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
