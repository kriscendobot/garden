CI is GREEN (rc 0). Fix stage complete.

## Completion report

Applied the design panel's round-1 must-fix items to PR #77 (kriscendobot/minion.town, `docs(designs): reconcile proposed MCP tool names`) in one pass, pushed as a follow-up commit (`48411b8`, `d0aaa6b..48411b8`), and CI came back **green**.

**Root cause the seven seats converged on:** the reconciliation cited the README's *migration table* as if it were a forward naming rule, applied inconsistent collision policy (`cancelInvite` pre-qualified against an unbuilt name while `submit` mounted bare), leaned on an unreconciled fourth design, and slipped a novel async-handle interaction shape in under cover of a rename.

**Changes:**
- **README.md** — split the section: a new `### Naming convention` subsection states the rule as its own anchor (mirror the method; strip the `guest_`/`clip_` prefix; qualify **only a present collision**, by facet, on the **later** mount), with the old→new table demoted under `### Migration` as history. All three designs repointed from `#mcp-tool-name-compatibility` to `#naming-convention` with one uniform citation lead-in (dropping the inconsistent "interface-native" coinage). *(critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant)*
- **remote-guest-endo-cli.md** — mount the invite facet's `cancel` **bare** (no present collision → rule 3 qualifies nothing) instead of the ungrounded `cancelInvite`; removes the asymmetry and the reliance on the unbuilt `reminder_cancel`.
- **git-remote-capability.md** — the `request` tool now **mirrors `GuestAgent.request(to, description, responseName)`** and settles the response into the guest directory (no new async-handle primitive; `has`/`readText`/`listMessages` + `adopt` redeem it; `messageNumber` carries identity; `resolve` is the responder side). `lookup` now states its serialized return (a descriptor, not the live capability, which is taken up via `adopt`). §7(b) rationale de-duplicated to point at §12; parallel-list and stranded-preposition prose fixed. *(decomplector, ergonomist, skeptic, critic, copyeditor, pedant)*
- **claude-agents-capability.md** — `submit` reframed as the proposed forms verb (**not on today's `GuestFacet`**) mounted only under the `ENDO_CLAUDE_ENABLED=1` wiring, resolving the provenance gap and the deployment-gate contradiction. *(skeptic)*
- **endo-reminder-minion-town.md** — added a note that the `reminder_*` names are provisional and reconcile under the convention at build time, **stating the exclusion** so the sibling designs no longer silently lean on an unreconciled name. *(critic, skeptic, novice)*

Grounded every factual claim against `src/endo/guest-control.ts` (confirmed `request`/`lookup` signatures, no `submit` in `src/`, `resolve` = responder side). Docs-only; CI (typecheck + vitest) unaffected and green.

No follow-ups. Per the gauntlet contract I stopped after one fix round; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr77-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (2881223 cached reads)
- Output: 25771 tokens
- Cost: $2.9917305000000005
- Wall-clock: 443s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
