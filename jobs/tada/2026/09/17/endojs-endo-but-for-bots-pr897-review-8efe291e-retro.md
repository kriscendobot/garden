Retrospective complete on endojs/endo-but-for-bots PR #897, review `5085400547` (kriskowal, CHANGES_REQUESTED).

**Idempotency:** No prior record existed; ran fresh.

**Grounding (world, not the primary report):** Re-fetched the PR and review. Review body + inline comments on `packages/daemon/src/help.md` object that the PR implicitly split a pet-name string on slash and described cross-path-discipline translation inside the core daemon Exo interface. Confirmed the primary's resolution is real — commits `7eac1629d` ("keep string paths as single names") and `a0020fbaf` ("keep Git path translation in its adapter") exist on the PR, replies posted. No false-no-op discrepancy to report.

**Verdict: miss** (category `process`). The layering the maintainer enforces is an *existing* repo convention, not new direction: slash-string→array parsing lives in the CLI adapter (`packages/cli/src/pet-name.js` `parsePetNamePath`) and the daemon interface types pet-name paths as arrays (`NamePathShape` / `string[]`). PR #897 added slash-splitting into `packages/daemon/src/mount.js` (the daemon/Exo layer), duplicating/misplacing a responsibility the CLI adapter already owns — foreseeable by tracing the existing route/layer, the same mechanism as the #658 miss.

**Cluster + threshold:** Joined `existing-cli-surface-equivalence` → count=2, prs={658, 897}, status=open, recurrence=0. Below the K≥3 floor (the two-PR requirement is now met, but the three-miss count is not); severity moderate with no standing rule bound, so the single-major bypass doesn't apply. **Held — no `review-improve-*` dispatch this cycle.** A third matching panelled path-handling branch that ignores the existing route/layer should join and trip a fresh threshold call.

**Artifacts written:** `review-misses/misses/endojs-endo-but-for-bots-pr897-review-8efe291e.md` (via the store writer, one CAS transaction) and result entry `entries/2026/09/17/104618Z-result-prosecutor-1f8c35.md`.

**Follow-ups:** none required now; the cluster is one qualifying miss away from dispatch. No garden `main2` code changes (a hold produces only journal store/entry writes).

Self-improvement: nothing this time.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr897-review-8efe291e-retro.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1473817 cached reads)
- Output: 22987 tokens
- Cost: $2.2666005000000005
- Wall-clock: 384s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
