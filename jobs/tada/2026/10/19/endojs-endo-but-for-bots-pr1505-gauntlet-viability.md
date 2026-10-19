Viability is **proceed**. PR #1505 is open, unmerged and still a draft. It was created today (2026-10-19T15:55Z) by `build-daemon-cbor-frame-migration`, and nothing newer has displaced it.

Deciding question: Is the daemon still netstring-only on `llm`, with no other PR already adding a cbor-frame framing seam or bilingual accept, while the design (#711) and its `@endo/cbor-frame` prerequisite (#288) are still live?

Evidence:
- **No framing seam on `llm`.** `packages/daemon/src/framing.js` does not exist there. `connection.js` exports only `makeNetstringCapTP`, with no sniffing or cbor-frame code. `serve-private-path.js` still accepts with `makeNetstringCapTP`. The last change to `connection.js` on `llm` was 2026-08-30 (#475), and it has nothing to do with framing.
- **No competitor.** A search of all PRs (any state) for "cbor-frame" finds no other daemon framing-seam implementation. Related PRs are the design #711 (open), the package #288 (open, approved by kriskowal on 2026-08-15) and unrelated OCapN/gateway work. #718 (closed) and #738 (merged) only renamed things and settled design questions; neither implements this.
- **The premise still holds.** #711 is open with a panel round of must-fix comments. Nobody has rejected or withdrawn it, and this PR is the design's Phase 1. #288 has not been merged or rejected, and the frozen base `feat/cbors-package-3ee0814` equals #288's current head (`3ee08149e7`), so the stack is consistent.
- **One thing to watch:** #288's most recent gauntlet, on 2026-10-08, ended `halted` without running any rounds. The base package is still unmerged, so this PR stays stacked until #288 lands. That is a sequencing risk, not a sign the PR is overtaken.

I spent no clean, panel, fix, CI or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1505-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (212552 cached reads)
- Output: 1920 tokens
- Cost: $0.42124639999999997
- Wall-clock: 40s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
