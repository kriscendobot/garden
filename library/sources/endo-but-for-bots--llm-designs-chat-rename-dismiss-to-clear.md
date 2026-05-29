---
source: designs/chat-rename-dismiss-to-clear.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 8e5058304b08a4ec590a8bdcc799f78b321d5726
source_date: 2026-05-20
source_authors: [Kris Kowal]
ingested: 2026-05-29
ingested_by: scholar
section_count: 1
status: current
notes: |
  **Status: Complete** (PR #93, merged 2026-05-06). A bounded
  PR-merge decision record + post-implementation retrospective.
  Single-section ingest reflects the document's small size (75 lines)
  and unified subject — *rename dismiss-all to clear with
  deprecation-period CLI alias*. Three structurally interesting
  features beyond the rename itself: (1) deprecation-period CLI alias
  with regression-test enforcement; (2) chat-vs-CLI alias asymmetry
  (chat had not shipped the command pre-rename so no alias needed);
  (3) roadmap calibration via git-blame on `llm` showing 65-day
  calendar with three implementation bursts. Twentieth chat-cluster
  source.
---

> Abstract: PR #93 (merged 2026-05-06) renamed the user-facing
> command `dismiss-all` to `clear` across both the CLI and the Chat
> command bar. Motivated by (a) the verbose-and-unfamiliar `dismiss-all`
> name vs `clear` as the conventional term for clearing inboxes, and
> (b) the tab-completion prefix collision between `dismiss` and
> `dismiss-all` in the chat command bar. The CLI retains
> `dismiss-all` as a hidden alias during a deprecation period; the
> chat side does not retain an alias because it had not shipped the
> command pre-rename. The underlying daemon power `dismissAll()` is
> unchanged — internal-vs-external naming separation. The
> `clear-command.test.js` regression asserts the `clear|dismiss-all`
> pairing in `endo --help`. Roadmap calibration via git-blame:
> active-development 2026-03-03 → 2026-05-06 (65 calendar days,
> three brief implementation bursts separated by long unattended
> gaps).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [rename-decision-record](../sections/endo-but-for-bots--llm-designs-chat-rename-dismiss-to-clear--rename-decision-record.md) | chat-ui, repository-governance | current |

The document's four subsections (Status with four bullet points; Roadmap calibration; Motivation; Changes) collapse to one argument-cluster section — the entire document is a unified PR-decision-record-plus-retrospective. Forcing it into multiple sections would pad each without adding substance. Single-section ingest is the cohesion-honest choice for this 75-line bounded source.

## Provenance

- Fetched 2026-05-29 from `endojs/endo-but-for-bots@8e5058304b08a4ec590a8bdcc799f78b321d5726` (the file's last-modifying commit on `origin/llm`).
- File last modified 2026-05-20 by endolinbot.
- Verified via bare-clone listing before drafting; cycle-92's chat-branch-discovery surfaced this candidate.
- **Twentieth chat-cluster source**.
- **Second single-section ingest in the chat cluster** (after a long history of 3-section ingests; the bounded source warrants the smaller treatment).

## Cycle 95 chat-lane note: bounded-source single-section ingest

This is the **second single-section ingest** to land in the library (after very early-cycle short README sources). The single-section discipline reflects the cycle-88 / cycle-92 standing pattern: **section count should be cohesion-honest**. A 75-line PR-decision-record document has *one* coherent argument cluster (the rename and its consequences); forcing three sections would pad each without adding substance.

Future chat-lane cycles should continue to apply this discipline — match the section count to the source's argument-cluster count, not to a 3-section default. Single-section, two-section, and three-section ingests are all valid depending on source cohesion.

Remaining chat-lane candidates per cycle 92 discovery:
- `chat-reply-chain-visualization` (502 lines, Status: Deprecated — superseded by chat-focus-message; design-rationale-history candidate).
- Watch `origin/design/chat-*` and `origin/llm/designs/chat-*` for new merges.
