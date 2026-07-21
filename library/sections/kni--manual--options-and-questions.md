---
title: Options, questions/answers, and keywords — the choice primitive
source: MANUAL.md
source_repo: kriskowal/kni
source_commit: 120fd885f15c2b0d9b2def4faa113b1a0a4e87ca
source_date: 2025-12-29
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The *option* is kni's fundamental branch-and-elicit primitive: the engine accumulates options until a prompt (`>`), presents them, and resumes down the chosen branch, gathering all loose ends after the prompt. This section covers option accumulation, the question/answer bracket notation (`[...]` splits the menu-facing "question" from the narrative-facing "answer", with nesting for common threads), non-options (an invisible fall-through when a prompt collects no visible option), and keyword-addressable options (`<term>`). For the agent-context lens this is the routing surface: a prompt is a decision point that presents a bounded, possibly-conditional menu and records which branch was taken.

kni accumulates options until it encounters a prompt, depicted as a right angle bracket `>` alone on a line. All loose ends from option branches resume after the prompt unless redirected elsewhere.

```
@blue2
- {door} The door is open.
  + [You w[W]alk through the open door. ] -> red
  + [You c[C]lose the door. ]
    {=0 door} -> blue2
- {not door} The door is closed.
  + [You o[O]pen the door. ]
    {=1 door} -> blue2
+ [Where am I again?] -> blue
>
```

**Questions and answers.** Options starting with `+` or `*` use the additional symbols `[` and `]` to split text that is part of the narrator's *answer*, the *question* (menu text), and a part *common* to both. `+ [You saunter[Walk] out of the saloon. ]` shows "Walk out of the saloon." in the menu and "You saunter out of the saloon." in the narrative. The bracket patterns thread question-only, answer-only, and common bits:

```
+ [Q] A          => Q: Q            A: A
+ C []           => Q: C            A: C
+ C [Q] A        => Q: C Q          A: Q A
+ [[] C] A       => Q: C            A: C A
+ [A1 [Q] C] A   => Q: Q C          A: A1 C A
```

**Non-options.** If an option has no question it is a "non-option." If the narrative reaches a prompt without accumulating any (visible) options, it falls through and automatically follows the first collected non-option — the mechanism behind an "invisible" default branch that fires once all show-once options are exhausted:

```
* [An option only to be taken once. ]
* [Another option that disappears. ]
* [] When all other options have been exhausted,
  the remaining option, however invisible, must be chosen.
  <-
>
->start
```

**Keywords.** Any term in angle brackets `<term>` names an option so the reader can choose it by keyword instead of number (the readline engine accepts either). Invisible options can also be reached by keyword:

```
+ <apple> [You chose[Choose] apple. ]
+ <orange> <lemon> [You chose[Choose] orange or lemon. ]
+ <grape> [] You chose a grape, which wasn't even on the menu.
```

Source: [MANUAL.md](https://github.com/kriskowal/kni/blob/120fd885f15c2b0d9b2def4faa113b1a0a4e87ca/MANUAL.md) at commit `120fd885`.
