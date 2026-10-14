---
handed-off: garden-book-illuminations-finish-after-gauntlet-20261014
deliverable-complete: false
---
Root cause: all 25 procedural SVGs rendered correctly in every supplied edition; the defect was their primitive, repetitive artwork and poor phone-width legibility—not fallback, CSP, CSS, or an outdated edition.

Created garden-book PR #15 with 25 independently generated OpenAI manuscript-style WebPs, accessible raster integration, prompt/contact-sheet evidence, browser checks, and removal of superseded procedural and legacy SVGs. Verification passed: 59 tests, 27-file build, and phone/desktop light/dark Chromium checks.

Also fixed the unsafe stale clip-publishing example on garden `main2` (`320cfbed282`).

The staged gauntlet is waiting at viability because its Anthropic review pool reached its quota high-water mark. No edition was published prematurely. Durable successor `garden-book-illuminations-finish-after-gauntlet-20261014` owns gauntlet completion, guarded merge, immutable publication, byte/browser verification, edition-history PR, and maintainer notification.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/garden-book-illuminations-republish-20261014.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s) (1 unmetered)
- Input: 0 tokens (0 cached reads)
- Output: 0 tokens
- Cost: $0 (1 engagement(s) unpriced)
- Wall-clock: 3094s

<!-- garden-usage-end -->
