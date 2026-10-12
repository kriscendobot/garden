I un-drafted kriscendobot/garden-book PR #8 (https://github.com/kriscendobot/garden-book/pull/8). It is now ready for review at the head the panel passed.

**Head check:** Just before the change, the PR was `OPEN`, still a draft, and its head was exactly `04a5b7e847f9458bdcb85b268526f2b8b45b3303`. I ran `gh pr ready`, then fetched the metadata again: `isDraft=false` and the head is unchanged.

**Advisory appellate pass:** I ran a light `claude -p` (Sonnet 5.5) review of the 1022-line diff. It did not block the un-draft. Its findings are worth the maintainer's attention before merge:
1. **Chapter 8 § 8.7** changes the accountant from "queued design" to "built and shipped". It cites `designs/accountant-arc-apportionment.md`, `set-apportionment.sh`, `accountant-statement.sh`, the `accountant-weekly` schedule and `--arc` flags. None of these appears in the diff, so each should be checked against `main2`. The section also says presses are retired, but § 3.3 and chapter 10 still treat presses as live.
2. **Renamed headings** (§ 8.7, § 7.2.2, § 4.6) may break in-book anchor links. Only chapter 8's table of contents was updated.
3. **Base branches disagree:** chapter 7 says implementation PRs target a frozen `master-<sha>`, while the build example in § 3.5 targets `llm-<sha7>`.
4. **Chapter 1 § 1.1** uses "ferry" and "frozen `master-<sha>` snapshot" before the book defines them. That breaks this PR's own rule of introducing terms once, before use.
5. **"Arc" is used inconsistently:** chapters 8 and 10 drop "arc marker" in favor of "line of work", while § 8.7 makes "arc" the live budget unit.
6. **Possible changes of meaning:**
   - § 10.4 now calls a dated delegation "standing".
   - § 4.4 gives the wrong reason after "For the same reason".
   - § 8.4 adds an unsupported "leaf-first" gloss.
   - The chapter 8 introduction drops the warning that the design docs are partly out of date.
7. **Claims to check in § 7.2.2 and chapter 3:** § 7.2.2 says every restriction "exists because a broader version once did damage", which not every listed rule supports. Chapter 3's TypeSafe claims have no source.

**Follow-ups:** None were posted. The appellate findings are advisory only; they could go into a fixer job (or a reply on the PR) if the maintainer wants them handled.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-garden-book-pr8-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (197891 cached reads)
- Output: 2169 tokens
- Cost: $0.37695019999999996
- Wall-clock: 338s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
