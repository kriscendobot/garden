---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §single most structurally interesting move — §namer-procedure-applied-with-citations
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

The design applies a *named procedure* (the namer's Laws) to
each rename candidate. The §applying-named-procedure-with-
citations discipline:

> *The candidate set is run through the namer procedure
> ([`../roles/namer.md`](../roles/namer.md)).*

For each candidate name, the design enumerates:

- **Law 0**: *describes the thing* — what the name's referent is.
- **Law 1**: *describes no other thing* — grep across `packages/`
  for false positives.
- **Law 2**: *shortest concise form* — no abbreviation if a
  single word works.
- **Antonym/dual**: pairs naturally with the existing partner.
- **Precedent**: the choice the Rust supervisor or sibling code
  already uses.

The §verdict-line discipline: each candidate concludes with
**Verdict: `<chosen-name>`**. A reader can scan only the verdicts
to see the renames; the bodies justify each.

The §methodology-not-just-decision observation: the design
*shows its work*. Future renames apply the same procedure;
future readers can audit the choices.
