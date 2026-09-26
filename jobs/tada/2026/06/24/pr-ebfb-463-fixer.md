Addressed endo-but-for-bots#463 as a fixer carrying the maintainer's CHANGES_REQUESTED feedback.

**Feedback carried:** kriskowal's review (2026-06-18) left one inline note on the design — *"Paraphrase. Nix the reference throughout. This is original."* A prior bot round (commits 8c8f0c1f, a5a1f6ef) had paraphrased only the `v11 §X.Y` strategy citations and left the rest, which is why CHANGES_REQUESTED still stood.

**What I did:** Completed the sweep so the design reads as a self-contained original document. New commit `3741a137` on `design/gateway-aws-marketplace-publishing-path`, pushed (`a5a1f6ef..3741a137`). Removed:
- the originating-directive blockquote in the problem statement (the `## Prompt` footer still records it as metadata);
- all PR-number provenance (`PR #343/#356/#400/#410/#412/#413`, `#388-#397`) across the substrate prose, AWS-stack section, phase plan, mermaid diagram, file-composition table, and Dependencies table — replaced with substantive descriptions;
- the `journal/projects/endo/README.md` citation in Decision 4;
- the "the strategy" / "resequenced O1 critical path" / "grooming pass" cited-source framings, restated as the document's own claims;
- tidied the "Background" framing line and the "Built (named PRs…)" heading that no longer listed PRs.

**Deliberately kept:** sibling-design cross-links (`[design](design.md)` in the Dependencies/Affected Designs tables and inline) — those are the design dependency graph, not provenance attributions, and are standard structure in this corpus.

**Verification:** Final grep for provenance tokens (`PR #`, `#3xx/#4xx`, `the strategy`, `resequenc`, `scout`, `scholar`, `journal/`, `v11`, `grooming`) is empty; only legitimate `*.md` sibling links remain. Net diff: 36 insertions / 41 deletions, one file. This is a design doc — no code paths; CI is the design-check set.

**Communication:** Posted a threaded reply on kriskowal's review comment (https://github.com/endojs/endo-but-for-bots/pull/463#discussion_r3466090980) summarizing the round and flagging it ready for re-review.

**Follow-ups:** PR remains DRAFT (per its body, "DRAFT for maintainer review") and `reviewDecision` stays CHANGES_REQUESTED until kriskowal re-reviews — no further action available on the bot side. Temp clone torn down.
