The designer job has already been claimed by a peer gardener — it moved from `todo/` to `doin/design-opencollective-ertp.md` with its inbox and worktree provisioned. The work is complete.

## Completion report

**Job:** `deadmail-issue-comment-4896384235` — a dead-lettered message originally addressed to `issue-kriskowal-garden-26` (that doer had already completed). Intent: pick up dckc's new comment on kriskowal/garden#26, "@kriscendobot please dispatch a designer."

**Context I grounded in:** Read the full issue #26 thread — a long design conversation between the garden scholar and maintainer `dckc` about an **off-chain OpenCollective ⟷ ERTP money-movement integration**. The conversation had converged on a settled frame (dckc's corrections): no blockchain/consensus; OpenCollective as source of truth with `E(purse).getCurrentAmount()` routed through the OC GraphQL API (purse = read-through capability façade); a three-facet split (`getBalanceFacet`/`getDepositFacet`/full connector-held purse); single-sided oracle-gated escrow adapted from dckc's `escrow-ertp.ts`; the "every escrowed amount backed by a real OC hold" custody invariant; polling reconciliation over webhooks; and provisional-vs-final modeled in OC's PENDING→APPROVED→PAID lifecycle.

**What I did:**
- **Dispatched a designer** — posted `design-opencollective-ertp` to the board (`--role designer`, directive identity `kriskowal/garden#26:comment:4896384235` for dedup). The job body carries the ISSUE NOTE block verbatim, the source-material pointers, the *settled frame* (so the designer formalizes rather than re-litigates), the deliverable spec (a 1–3 screen design with a mermaid flow), and the two open questions to surface (how much of Zoe is needed; where a persistent design file should live). It flags that `dckc/vattr97` is **not** a garden-registered fork, so no branch/PR without dckc's per-action authorization. The job is already **claimed and in progress** by a peer gardener.
- **Replied on the issue thread** as kriscendobot ([issuecomment-4896444833](https://github.com/kriskowal/garden/issues/26#issuecomment-4896444833)) confirming the dispatch, summarizing the settled frame the designer will formalize, and pre-flagging the fork/PR-authorization question.

**What changed:** One job posted to `journal2`; one issue comment on kriskowal/garden#26. **No garden code changes** (main2) — this was a dispatch-and-reply, nothing to commit. Issue left **open** (dckc closes it).

**Follow-ups:** The designer will post the formal design memo on #26 and ask dckc (a) how much Zoe to commit to and (b) whether to file the design as a `designs/*.md` in `dckc/vattr97` via an authorized PR, or keep it as the issue comment of record.
