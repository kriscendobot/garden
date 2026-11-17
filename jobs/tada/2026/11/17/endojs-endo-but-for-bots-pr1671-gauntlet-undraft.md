I un-drafted endojs/endo-but-for-bots#1671 ("design(endopi): concrete prompt-template format and Pi argument grammar"). It is now ready for review at the head the panel passed, `4afda8675c68cb95414d2571ac9e4dd2b4ca48c7`.

**Pre-mutation check:** fresh metadata showed the PR OPEN, still a draft, and on that exact head, so I ran `gh pr ready`.

**Post-mutation check:** isDraft is now false and the head is unchanged.

**Advisory appellate pass:** I ran a light `claude -p` review of the diff. It is advisory only and did not gate the un-draft. These are possible gaps the panel may have missed, for the maintainer's review:
- **Argument splitting:** rules 3 and 5 conflict on escaped quotes. The listed test `"a\"b"` would come out as `a\` with `b"` left over, and text right after a closing quote has no defined meaning.
- **`argument-hint` grammar:** a hint like `<focus area>` (which contains a space), forms like `[files...]` and a required token after an optional one are all undefined. `${@:3}` has no label. A template with no placeholders would open an empty form.
- **Frontmatter reader:** it may not match Pi's real YAML parser on quoted values, colons in values, multi-line values or a missing closing `---`.
- **Prompt-source precedence:** it relies on sorting by entry name, which is not specified (lexicographic sorting puts `10` before `2`).
- **Security:** the design does not say whether read-only mounts follow symlinks or who enforces the 1 MiB cap. The walk from repository root to cwd can mount directories the user never inspected.
- **"Open questions" section:** both items already state a decision, which matters because that section is what made this a review PR.
- **Bookkeeping:**
  - Status still says "Proposed" although build #1640 is in flight.
  - The body links several designs that are missing from the Dependencies table.
  - A delta item pins a head SHA that will go stale.
- **Pi grammar claims:** the cited syntax (`${1:-default}`, `$ARGUMENTS`, the five splitting rules) should be checked against Pi's source.

I made no garden changes and have no follow-ups beyond these advisory notes.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1671-gauntlet-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (185886 cached reads)
- Output: 1536 tokens
- Cost: $0.43796919999999995
- Wall-clock: 92s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
