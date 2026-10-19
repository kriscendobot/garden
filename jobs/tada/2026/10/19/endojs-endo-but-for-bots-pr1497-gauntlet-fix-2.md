## Gauntlet FIX round 2: endojs/endo-but-for-bots PR #1497

I applied the round-2 panel findings, pushed them to the PR head, and trimmed the PR body. CI is green: `ci-wait-merge.sh --no-merge` returned rc 0, with 30 of 30 checks and 0 failed.

**Source of the findings.** There was no pre-pass block, so I worked from the latest panel verdict: comment review 5571451518, which came from durable record `e5f0ec19c207`. Its 20 items are cut short in both the review and the record. I worked out each one by reading the PR diff against base `ca5aaefb23`.

**Commit e18af8019c**, "fix(designs): address panel style notes on daemon-agent-tools", in `designs/daemon-agent-tools.md`. I pushed it with `safe-push-pr-head.sh`, which moved the head from a24d46b25f to e18af8019c.
- **Pedant must-fix items (em dashes):** removed the em dashes from the 2a, 2b and 2c checklist markers (now `2c:`). I also replaced them in every Phase heading, from "— landed (#707)" to "(landed, #707)", so the headings stay consistent.
- **Copyeditor:**
  - Rewrote the "make-unconfined product" sentence.
  - Turned round the attestation sentence so it says plainly that the shell does not require one, and why.
  - Open Question 6 now says the background process can outlive "that call" instead of the unclear "it".
  - The ownership-answers sentence, which packed several answers after one colon, is now a four-item list.
- **Pedant should-fix items:**
  - `## Next Slice: The Sandbox Shell Engine` now capitalizes the word after the colon.
  - Open Question 1 now leads with its question, then "Resolved: …".
  - Rewrapped the overlong Status line and one short line.
- **Comment-only items:** the third status-list item is now a noun phrase like the others, and I removed the stray blank line before Open Question 4.

**PR body.** Cut from 494 to 235 words, under the pruner's 300-word limit:
- Removed the section-by-section tour.
- "Design only. No build is started." now appears once instead of three times.
- Each Considerations section is now one sentence, and Upgrade is just "None.".
- The `garden-job` marker is kept.

**Not changed:**
- **"Why this slice first" heading:** the pedant wanted it in title case. I left it in sentence case because every other `###` heading in the document uses sentence case, and changing only this one would make the headings inconsistent. The next panel may raise it again.
- **Pre-existing text:** the en-dash ranges ("Phases 1–3") and the old em dashes in lines this PR didn't touch are as they were.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1497-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1692982 cached reads)
- Output: 11360 tokens
- Cost: $1.2866284000000001
- Wall-clock: 846s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
