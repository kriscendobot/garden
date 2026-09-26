FIX round 3 complete. CI is green (rc 0).

## Completion report

**PR:** endojs/endo-but-for-bots#1228 — `design(claude): finish the bare CLI caplet contract` (design-only diff: `designs/endo-claude.md` + `designs/README.md`).

**Panel-3 verdict** was `must-fix`, driven by three should-fix findings. I applied all three plus the concrete should-fix items from the request-changes seats, in one follow-up commit (`12e24bb5a`):

- **DD6 scope-narrowing untracked (critic, skeptic):** added an Open Question tracking whether the acceptance boundary may narrow from the § *Prompt*'s conjunction (OS isolation **and** tool-surface substitution) to substitution alone; hedged all three derivative `designs/README.md` restatements (milestone table, LLM-agents prose, mermaid comment) to "proposed narrowing pending maintainer confirmation, not settled."
- **Argv-boundary misattribution (skeptic):** corrected the claim that the OS slice "closes" the tool-result residual. The decision-level threat (a `tools/call` result steering the model into a legitimate-but-harmful *in-allow-list* call) is now stated as a distinct residual the OS slice cannot close and `attenuateArgs` only partially bounds, owned as an unmitigated open gap with a new Open Question.
- **Isolation attestation overclaims verification (decomplector, critic, ergonomist):** rewrote DD6, the acceptance step 6, and § Package shape so the prose says the harness only checks the field is present-and-recognized, never that the asserted isolation holds; added the verified-slice-handle upgrade as an Open Question.

**Smaller should-fixes also applied:** `openGuestMcp`→`makeGuestMcp` (ergonomist verb consistency); `co-located-trusted`→`co-located-accepted` (ergonomist enum voice); `materialize`→`materialise` in the three prose spots to match the `materialise()` identifier (pedant); recast the problem-statement appositive and the DD6 semicolon (copyeditor); glossed the one-guest MCP surface and the DD6 attestation at first use in the acceptance condition and dropped the dated self-reference in the argv.js table row (novice).

**Not applied (deliberate):** the confined/unconfined axis rename (decomplector #2) — the doc's Vocabulary-convention glossary is the chosen mitigation and was endorsed by other seats; the em-dash and single "cancelled" comment-only nits, whose scope the pedant/orthographer themselves flagged as unsettled for this repo's design docs and which conflict with the pervasive `{cancelled}` identifier.

**Push & CI:** advanced `endojs/design/endo-claude-bare-caplet` `517db987`→`12e24bb5`; bounded CI wait returned **rc 0 (GREEN)**, 7/7 checks, 0 failed. A pre-existing unrelated worktree artifact (`packages/floot/package.json` unicode-escape normalization from install) was reverted and not committed.

Stopping here per stage contract — did not re-run the panel; the driver re-posts panel-4.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1228-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (3340113 cached reads)
- Output: 24501 tokens
- Cost: $3.2511544999999993
- Wall-clock: 949s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
