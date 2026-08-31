---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Reword the ironhorse fuzz-repair job template so it stops tripping provider policy

The ironhorse fuzz-repair lane is DETERMINISTICALLY DEAD. Between 2026-08-31
05:23Z and 14:15Z, **55 `ironhorse-fuzz-<hash>-repair` jobs were refused by
provider safety policy**, and **62 are now quarantined in `jobs/plan/`** (gate
`go-ahead`, `doom_signature: policy-refusal`). The reaper is behaving correctly:
one refusal is conclusive, so it does not requeue. Every new fuzz finding
converts itself into backlog — `plan/` grew 223 -> 291 today.

## The cause is FRAMING, not data handling

Rule this out first so you do not fix the wrong thing: `ironhorse-fuzz.sh`
already states it "NEVER interpolates crash bytes into a shell command or an LLM
prompt," and the quarantined bodies confirm it — 3.2 KB, longest line 162 chars,
referencing `input_base64` in the journal finding marker BY PATH. **The data
discipline is correct and must be preserved exactly as is.**

What trips the classifier is the job body's REGISTER. A representative body
(`jobs/plan/ironhorse-fuzz-2cc2ac67ba7e9b9f-repair.md`) contains `fuzz` x18,
`crash` x3, plus `untrusted` and `panic`, under the heading
"Fix Ironhorse fuzz finding <hash> ... reproduced a distinct crash". That reads
as offensive-security work. The doom notice's own remedy names this clause —
"avoid framing that reads as offensive-security" — and it is the half nobody has
acted on.

## What to change

In `scripts/jobs/ironhorse-fuzz.sh`, reword the repair-job template so it
describes the SAME work in a correctness/robustness register:

- It is a **defect repair in a JS engine port** (Ironhorse): an input that
  produces incorrect behaviour or an abort in the engine under test.
- Reference the **recorded reproducer artifact by its durable path / sha256**,
  exactly as today. Do not inline it. Do not weaken the existing guarantee.
- Drop the offensive-security register: prefer "defect", "reproducer",
  "regression case", "incorrect behaviour", "abort" over "fuzz", "crash",
  "attack", "adversarial", "exploit". Keep the word "fuzz" where it is a PROPER
  NOUN naming the service or directory (`ironhorse-fuzz`, the standing PR) — the
  goal is to lower vocabulary density in the instructions, not to rename the
  subsystem or obscure what the work is.
- Do NOT misrepresent the work. This is a legitimate correctness-repair lane on
  the garden's own engine; the aim is accurate plain description, not evasion. If
  you cannot reword it truthfully, say so and stop rather than dressing it up.

## Prove it before declaring done

A reworded template that still trips the filter is worth nothing, and you cannot
tell from reading it. Take ONE quarantined finding, regenerate its body from the
new template, and run it through an actual dispatch. Cite the result. If it is
refused again, iterate — and if the register is not the cause after all, report
that negative result plainly; it is more useful than a plausible rewrite.

## Definition of done

Template landed on `main2`; ONE real dispatch shown surviving the policy filter,
with the command and its output. State the before/after body vocabulary counts.
The follow-on job `ironhorse-fuzz-repromote-quarantined` is BLOCKED on this one
and will bulk-promote the 62 quarantined jobs once you have proven the fix.
