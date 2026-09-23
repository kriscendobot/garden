---
ts: 2026-05-12T23:46:29Z
kind: result
role: liaison
subject_matter:
  - rule-elision
  - meta-evolution
to: "*"
refs: []
---

Added `skills/rule-elision-test/SKILL.md` on main `6d6194d`.

The skill: spawn three fresh subagents against a synthetic role file
with a candidate rule removed, present each with a different realistic
scenario the rule would cover, score each response as intuitive /
partial / missed. The rule passes (and may be elided) only if all
three are intuitive.

Tracking elided rules: a journal `message` entry tagged
`subject_matter: [rule-elision]` records the rule text, the scenarios,
the responses, and the elision commit SHA. Optionally also a one-liner
in `roles/<role>/intuitive.md` (data, not directive; not loaded into
agent context). The journal entry is canonical; the file is
human-friendly browse.

Pitfalls captured in the skill: bad scenarios (telegraphing, too
narrow), compound rules, scenario contamination, borderline (two of
three pass), model drift, side channels via `roles/COMMON.md` (when
testing a rule that COMMON.md cross-references, stage a synthetic
COMMON.md too).

Complementary to `skills/self-improvement/SKILL.md`: that skill is the
adding-rules side, this one is the removing-rules side. Self-improvement's
"Removing or rewriting an existing rule needs explicit user direction"
threshold is satisfied by an elision test that passes (the test produces
the evidence; user direction is in the standing instruction to compact
when warranted).

No rules elided yet. The skill exists as a tool ready for the next
role-bloat moment.

Self-improvement: skills/rule-elision-test/SKILL.md (new), CLAUDE.md;
new compaction tool, complementary to self-improvement's growth side.
