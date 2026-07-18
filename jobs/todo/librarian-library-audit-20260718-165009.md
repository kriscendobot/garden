# Librarian library audit

Dispatch a librarian (garden/roles/librarian/AGENT.md) to perform its proactive
library context-efficiency audit so future research stays context-cheap:

1. Audit `library/sections/`, `library/concepts/`, and `library/topics/` for
   documents that violate the context-library abstract-at-the-top exit criterion
   (too long to skim against their abstract, or mixing several distinct
   concepts under one file).
2. Audit for index gaps: concepts/keywords missing from `library/keywords.md`,
   topics missing from `topics/README.md`, sources missing from
   `sources/README.md`.
3. Post a finer-grain **split** job for each oversize document and an **index**
   job for each gap (per `skills/context-library/SKILL.md`).
4. Post nothing if the library is already within budget and fully indexed.

Deliverable: the set of posted split/index jobs, or a `tada` report stating the
library is within budget and fully indexed.
