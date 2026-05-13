---
ts: 2026-05-13T00:05:15Z
kind: result
role: liaison
subject_matter:
  - rule-elision
  - methodology
  - meta-evolution
to: "*"
refs:
  - entries/2026/05/12/234629Z-result-liaison-39441d.md
---

First exercise of the rule-elision-test skill, on the boatman role's
"Don't merge" rule. All three test scenarios produced agents that
stopped at "open the upstream PR" with no merge step. By the literal
scoring rule, the rule passed the test (intuitive across all three).

**Did not elide.** The user flagged a methodology gap mid-test:
"the agent's behavior depends on its ability to find relevant skills
and inspect the journal for relevant information." Investigation
confirmed two side channels the v1 procedure did not control:

1. **The role file's Done section** restates "Upstream PR open" as the
   endpoint of the engagement. Even with the explicit "Don't merge"
   bullet removed, the Done section anchors the contract.
2. **A prior journal entry** (the one that originally added the
   boatman role to the garden) contains the phrase "opens the upstream
   PR and stops; merging is a human decision". Subagents grep journal
   for project context and could have read this.

The pass is therefore the weaker claim ("the explicit bullet is
redundant given Done and prior journal context"), not the stronger
claim ("the rule is intuitive in any context"). The skill's literal
text passed; my unstated assumption that the agents were reasoning
without leak did not.

**Updated the skill on main `2098e83` (rebased to `d77b36d` after
concurrent push).** Three additions:

- A new "What this skill tests (and what it does not)" section up
  front: the literal test is "is the explicit statement load-bearing
  within our garden's full context?", not "would an agent intuit this
  in any context?"
- A new step 3b that requires checking three side channels before
  dispatch: cited skills, COMMON.md, and journal grep history. Each
  has a workaround (synthetic copy, dispatch-prompt instruction, or
  acknowledged-leak reporting).
- Step 3 now scans the synthetic role file for restatements (Done,
  intro, dispatch inputs) and decides whether to redact them too or
  acknowledge the restatement in the result.
- Pitfalls section gained three new entries plus a confidence-
  calibration note.

The boatman rule stays in place. The procedure that found the leak is
worth more than the marginal compaction would have been; the next
elision test will run with the tighter procedure.

Methodology pattern worth keeping for future tools that probe
agent behavior: enumerate the agent's reading list (role file, cited
skills, COMMON, journal grep) and audit each item for what the test
is trying to control. A test that controls only the most obvious
input is brittle.

Self-improvement: skills/rule-elision-test/SKILL.md; first real
exercise produced concrete pitfalls and a clearer framing of what
the test proves. The user's mid-test methodology flag is captured
in the skill so the next runner does not repeat the leak.
