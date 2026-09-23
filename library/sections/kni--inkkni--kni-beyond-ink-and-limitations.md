---
title: What kni adds beyond Ink, and what it still lacks
source: INKKNI.md
source_repo: kriskowal/kni
source_commit: 3a62b89ee1cedf495d841c351d6149857a919665
source_date: 2026-01-02
source_authors: [Kris Kowal]
ingested: 2026-07-21
ingested_by: scholar
topics: [decision-graph-authoring, automatic-agentic-loop]
status: current
---

Abstract: The capability boundary of the language, useful for the agent-context lens's "fit and gaps" question. kni is *missing* things Ink has — no enumerations or typed variable declarations (only 32-bit integers and very limited strings), labels are not first-class values (you cannot store a label in a variable and divert to it), no modules yet, and no user-defined functions in expressions. But kni *adds* over Ink: second-person option bracket notation, option collection through nested conditional threads, subroutines (`{->label}` goes-and-returns), a `<-` terminate/return operator, and biased-random / Hilbert-curve / hash operators suited to gambling games and deterministic procedural generation. Notably it can trigger arbitrary game-specific hooks with `<hook>` notation. All subject to change across major versions.

kni is missing many things available to Ink:

- No enumerations or other typed variable declarations. It only supports 32-bit integers and very limited support for strings.
- Labels are not variables. You can't write a label to a variable and divert to it by that variable name.
- No modules yet.
- No defining functions for use in expressions.
- kni can trigger arbitrary game-specific hooks with `<hook>` notation.

Yet kni has features Ink leaves out. Ink's smallness keeps it easy for non-programmers; the author made kni "selfishly as a hybrid writer and coder":

- **Second-person options** using a special case of Ink's bracket notation (`+ [You b[B]uy an arrow. ]`).
- kni can **collect options through nested conditional threads**.
- kni has **subroutines**: `{->label}` instructs the engine both to go to the label *and* to return here after exhausting that narrative.
- kni uses a `<-` operator to **terminate** a narrative (and return to the calling narrative if there is one) instead of a goto to a special label like Ink's `-> END`.
- kni has operators for **biased random numbers, Hilbert curves, and hashing** that suit it for gambling games and deterministic procedurally-generated narrative.

All of this is subject to change from major version to major version — the author is rapidly leaving major versions behind, so stories written for earlier versions keep working while the language evolves.

Source: [INKKNI.md](https://github.com/kriskowal/kni/blob/3a62b89ee1cedf495d841c351d6149857a919665/INKKNI.md) at commit `3a62b89e`.
