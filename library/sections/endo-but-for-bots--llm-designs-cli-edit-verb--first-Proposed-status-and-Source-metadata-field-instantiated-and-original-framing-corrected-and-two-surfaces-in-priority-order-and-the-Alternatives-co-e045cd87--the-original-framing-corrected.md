---
title: §The original framing corrected discipline
source-slug: endo-but-for-bots--llm-designs-cli-edit-verb
section-slug: first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections
source-url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-edit-verb.md
source-repo: endojs/endo-but-for-bots
source-path: designs/cli-edit-verb.md
source-author: Kris Kowal (prompted)
total-lines: 1394
ingest-cycle: 279
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: endo-but-for-bots--llm-designs-cli-edit-verb--first-Proposed-status-and-Source-metadata-field-instantiated-and-original-framing-corrected-and-two-surfaces-in-priority-order-and-the-Alternatives-considered-section-and-two-named-Open-Questions-sections
---

Lines 33-43 carry §a-design-acknowledging-its-original-framing-was-wrong-and-corrected:

> *The original framing of this design positioned `endo edit` (a CLI verb human or scripted callers invoke) as the primary surface. Maintainer review on PR #162 corrected that framing. AI agents do not type CLI commands. They invoke tools, and those tool calls drive the daemon's `EndoGuest` API directly. The CLI is a thin convenience wrapper around that API for human operators and shell scripts; the daemon-side capability is the load-bearing surface that needs the design care.*

§First-explicit-observation in library: **§the-design-acknowledges-a-prior-framing-was-wrong-and-IS-corrected — §the-correction-IS-named-explicitly + §the-correction-cites-the-PR-that-caused-it (PR #162) + §the-correction-IS-prose-not-removed-content**.

§Sibling-pattern to cycle 269's §the-named-evolution-of-a-system's-purpose-as-design-rationale (Chat-becoming-the-debugger-of-last-resort) — but here the evolution IS within the design's own lifecycle.

§Two-cycles-with-named-evolution-of-rationale-within-a-design-document (269 + 279); §the-discipline-IS-honest-record-keeping-of-design-iteration.
