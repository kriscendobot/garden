PR endojs/endo-but-for-bots#1543 ("design(agents): replace bare subscriptions with API-key providers") is now out of draft. It is still at head `81e5e47ae3d16223e94692e9f6fd0bf821621dc9`, the exact commit the panel passed.

**What I did:**
1. **Advisory appellate pass:** I ran a light `claude -p` (sonnet) review over the PR diff, which touches 5 files under `designs/`. It does not block anything. Its points for the maintainer to look at:
   - **README counts:** the status totals in `designs/README.md` (Proposed, In Progress, Superseded) may be off by one, because the endo-claude row's status changed. A recount of the table would settle it.
   - **Mismatched status:** `endo-claude-inference-backends` is listed as "Draft" in the README but says "phases 1 and 2 built and in review" in its own file. This predates the PR.
   - **Wording varies:** the subscription route is called "closed", "refuses", and "unsupported" in different places. It should use one term, "unsupported" by policy.
   - **Migration authority:** the legacy migration writes `AgentRecord.ownerId` from the root of the delegation chain, but no design names who is allowed to do that write.
   - **Grant id as a bearer:** anyone holding the `AgentInference` grant id can spend from it. The design should say that id is never shown in the UI or written to logs.
   - **Probing other owners:** `idempotency-conflict`, `agent-name-conflict`, and the status lookup should be confirmed to be limited to the caller's own `ownerId`, so they can't reveal other owners' records.
   - **Unverified references:** the cited minion.town PRs and Claude Code issue #82566 can't be checked from the diff. It's also worth confirming the referenced `chat-inventory-create-menu.md` and `daemon-secret-manager.md` sections exist.
   - **Roadmap schedule:** M3's body still says "4-5 weeks" while the summary table now says 10–13. The shifted milestone dates (for example M8, "Apr to May" → "Mid Apr to mid Jun") don't clearly add up to the stated +2 weeks.
2. **Check before acting:** the PR was OPEN, still a draft, and at the passing head.
3. **Un-draft:** ran `gh pr ready`, which succeeded.
4. **Check after:** the PR is no longer a draft and the head is unchanged.

No garden repo changes and no commits.

**Follow-ups:** none required. The maintainer may want to look at the README count and M3 schedule points before merging.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1543-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (285192 cached reads)
- Output: 1677 tokens
- Cost: $0.4406024
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
