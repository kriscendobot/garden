FIX round 2 for kriscendobot/minion.town PR #147 is done. I pushed one commit, `b93e5cc`, on top of `625d8b9`, and CI is green on it (`ci-wait-merge.sh` returned 0, with 3 of 3 checks passing and none failing). I did not re-run the panel; the driver posts panel-3.

**Must-fix items from the round-2 panel verdict, all fixed** (the only file changed is `designs/mcp-resources-getting-started.md`):
- **"guest" was never defined.** The § 1 glossary now defines it, and also "facet", which the pedant marked should-fix. The glossary goes from four terms to six.
- **Title used mixed case.** It is now all sentence case: "Design: MCP resources for a cold agent, …". The section headings were already consistent, so they are unchanged.
- **Unicode `→` arrows.** All are now ASCII `->`. I also removed the `∩` from the § 5 table.

**Should-fix items, also addressed:**
- **Size caps (critic):** the numbers didn't add up. The rule is now 4 KB for getting-started plus 6 KB for each of the other six, so at most 40 KB in total.
- **Why resources over prompts (critic, skeptic):** § 3.1 now limits the "agent can find them alone" claim to clients that expose resource reads as tools the model can call. It notes that the MCP spec makes resources *application-controlled* and prompts *user-controlled*.
- **Decomplector:**
  - Each session now resolves the resources symlink once at startup and serves every read from that copy. Old copies are kept, so a session never loses its files.
  - The symlink swap is now a compare-and-swap under `flock` on the box, so two deploys running at once cannot overwrite each other's newer version. § 5 updated to match.
- **Session lifetime (skeptic):** § 4 now says plainly that "ships in seconds" only reaches new sessions. A long-running session keeps the guide it read at start until it reconnects.
- **Ergonomist:**
  - `guide/troubleshooting` now ends with a pointer to `guide/clips`, shown only when the clip tools are present.
  - § 3.2 now explains why only clips get a worked-example resource.
- **Smaller wording fixes:**
  - § 4: rewrote the `requires of absent, …` phrasing.
  - § 1: the clip ocap synthesis is now named as the design document it is.
  - § 6.1: added a one-line description of "Flow B".
  - § 5: added an opening sentence.
  - § 6.3 vs § 6.4: resolved the conflict over whether the read-before-first-change metric is graded.

**Not changed (comment-only):**
- Renaming `guide/names` to `guide/pet-names`.
- Making PR-reference formats consistent.
- Moving the `instructions` text into `resources/`.
- One shared table linking `requires` mount groups to tool names.

**Follow-ups:** none from this stage.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr147-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (802021 cached reads)
- Output: 6826 tokens
- Cost: $0.8839642
- Wall-clock: 511s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
