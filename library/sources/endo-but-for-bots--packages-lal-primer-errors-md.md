---
source_kind: source
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_path: packages/lal/primer/errors.md
source_commit: 10594d09fa6efff9f7d4271adc2f2f19214fd756
source_date: 2026-03-26
source_authors: [Kris Kowal]
ingested: 2026-06-22
ingested_by: librarian
section_count: 1
status: current
notes: |
  Cycle 453 designs-lane ingest. 31-line
  primer/errors.md from @endo/lal's agent-facing
  primer. Seventeenth lal-package artifact in the
  cluster (co-ingested with formatting.md). One
  hundred and first AUTHORED conformant section doc
  in post-refactor era.

  Single most structurally interesting move for
  this companion section: §the-named-verify-before-
  act-as-universal-pet-name-precondition — the
  "Verify Before You Act" section elevates cycle
  407's locate-defensive-prerequisite from tool-
  specific to a UNIVERSAL cross-tool invariant:
  "Before using a name in ANY tool call (lookup,
  locate, adopt, etc.), make sure it exists... Do
  NOT guess or assume pet names exist." §the-named-
  no-same-argument-retry-as-strategy-change-
  discipline (step 2: do NOT retry with same args,
  try a different approach). §the-named-unknown-
  pet-name-as-canonical-LLM-error. §the-named-
  dismiss-required-regardless-of-handling-success
  (step 4: still dismiss() even if handling failed;
  extends cycle 413's mandatory-dismiss to the
  failure path).

  Two citation arcs closed: cycle 407 (3, locate-
  defensive-prerequisite generalized to verify-
  before-act), cycle 413 (3, dismiss-even-on-
  failure extends always-dismiss-after-handling).
---

31-line primer/errors.md from @endo/lal's agent-facing primer. Documents the four-step error response protocol (examine, change strategy, inform via reply, still dismiss) and the "Verify Before You Act" invariant (call list() before any pet-name operation; never guess or assume names exist). **Single most structurally interesting move**: §the-named-verify-before-act-as-universal-pet-name-precondition — *the document elevates cycle 407's locate-defensive-prerequisite from tool-specific to a universal cross-tool invariant spanning lookup, locate, adopt, and all other pet-name operations.* §the-named-no-same-argument-retry-as-strategy-change-discipline. §the-named-unknown-pet-name-as-canonical-LLM-error. §the-named-dismiss-required-regardless-of-handling-success (extends cycle 413's mandatory-dismiss to the failure path).

| Section | Topics | Status |
|---------|--------|--------|
| [verify-before-act-and-error-handling-discipline](../sections/endo-but-for-bots--packages-lal-primer-errors-md--verify-before-act-and-error-handling-discipline.md) | agent-conventions, errors | current |
