**Viability: proceed.** PR #250 is open and in draft, at head `bcd20df6576`. Its base `main-7a0bcc9` is the same commit as current `main` (`7a0bcc90`), so no newer base history exists.

Deciding question: Is the #244 finding about owner-wide authorization through `directoryFor(ownerKey)` still undecided on current `main`, with no newer design or implementation having settled it?

**Answer: yes.**

Evidence:

**Not superseded**
- `designs/api-key-agent-directory-authorization.md` is not on `main`, and no other file on `main` records this decision.
- A title search for the directory and attenuation terms found no competing PR.
- #250 has no comments or reviews, so nobody has disputed or displaced it.
- #249 and #228 do not displace it:
  - #249 closes the other must-fix findings from the same review and says the broad-facet finding is "intentionally deferred to a separate design-first follow-up, per maintainer decision". #250 is that follow-up, from job `design-minion-town-agent-directory-attenuation-20261105`, recorded as done on `origin/journal2`.
  - #228, an open draft for the chat Clip, keeps agent management in the owner's chrome and gives the confined Clip only a per-conversation `ChatSession` locator. That fits the boundary #250 draws rather than replacing it.

**Motivating need still holds**
- The code the finding describes is unchanged on `main`:
  - `src/auth/inference-provider-endpoint.ts:449-454` derives `ownerKey` from the identity and calls `agents.directoryFor(ownerKey)`.
  - `src/auth/agent-endpoint.ts:257` still calls `agents.setWake(agentId, …)` on the owner-wide directory.
  - `src/endo/agent-service.ts:114-147` still defines `OwnerAgents` that way.
- No `controlFor` per-agent facet exists in these three files.
- #244's finding (review 5777291018) has no recorded decision. #244 was closed after its work was integrated on `main`, and its gauntlet halted.
- The API-key agent surfaces are live on `main` behind default-off flags, so the boundary needs deciding before those flags turn on.

**For the panel (not viability blockers)**
- The maintainer's tentative preference was option 2 (per-agent facet) only if a real gap is established. #250 chooses option 1 and argues no gap exists, so review should test that argument.
- The workbench design (`designs/api-key-agent-workbench.md:432`) does support the owner's capability reaching every descendant.
- The other baseline design, `api-key-inference-providers-and-pinned-agents.md`, lives in `endojs/endo-but-for-bots` (#1543), not in this repo.

I made no changes and spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr250-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (425198 cached reads)
- Output: 7111 tokens
- Cost: $0.7071396000000001
- Wall-clock: 134s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
