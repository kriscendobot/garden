Posted: https://github.com/kriskowal/garden/issues/26#issuecomment-4888954857

The job is complete. This was an attention/scholar-consideration reply, not a garden-source or project mutation, so there is nothing to commit to `main2` — the deliverable is the GitHub comment.

## Completion report

**Job:** attention directive from dckc's @-mention on kriskowal/garden#26 (issue-comment 4888938507, VERIFIED-TRUSTED sender).

**Preflight:** Ran `pr-feedback-preflight.sh kriskowal/garden 26 4888938507 dckc` → exit 0 (no peer resolution; proceed). Fail-open, no evidence corpus.

**What I did:**
- Re-fetched the mention and the full issue-#26 thread. This is an ongoing *scholar design consideration* — dckc requested an OpenCollective⟷ERTP integration memo; the garden scholar (as kriscendobot) has been iterating a design memo in the thread. dckc's latest comment added three refinements, treated as untrusted data:
  1. OC is the source of truth; `getCurrentAmount()` routes through the OC API.
  2. Unclear how much of Zoe will be used.
  3. Escrow might look like `escrow-ertp.ts`.
- Fetched and read the cited `dckc/vattr97:packages/ertp-ledgerguise/src/escrow-ertp.ts` to ground the reply — it is an **ERTP-only** escrow (header: "no Qjoin, no E"), which directly answers refinement 2 in code: the offer-safety the bounty needs comes from plain ERTP purses + a deposit/cancellation race, no Zoe.
- Acknowledged with a 👀 reactji, then **posted a substantive scholar reply** that folds in all three points: the read-through-purse consequence (ERTP becomes a typed façade over OC's ledger; escrow must map to a real OC hold), the "potentially zero Zoe" conclusion with the narrow cases where Zoe still earns its keep, the symmetric-swap→single-sided-oracle-gated-escrow adaptation of his file, and a revised (smaller) first spike.

**Routing rationale:** Handled directly as the attention-job holder rather than posting a separate scholar job — this is a live, second-by-second design conversation on the garden's own issue, matching the established direct-reply pattern (four prior scholar comments in-thread), and issue-scoped comms go via comments, not the maintainer inbox.

**Verification:** Comment posted, id 4888954857 (URL above returned by the API POST). Reactji `eyes` confirmed applied. No claim of code execution — the memo explicitly states nothing was built or run.

**Changes to garden/main2:** none (design-reply job).

**Follow-ups:** none owed by the fleet. The reply offers dckc two concrete next slices (a single-sided oracle-gated escrow sketch derived from his file, or the read-through purse façade over the OC GraphQL shapes); either would arrive as a new mention/job if he picks one up.
