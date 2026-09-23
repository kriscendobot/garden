---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-07-21T18:19:23Z
---
Ingested a durable AI-writing style reference into `journal/library/`.

Sources and sections:

- Herbold et al., *Scientific Reports* comparative essay study: rigid template realization and corpus/model limits.
- Liang et al., *Patterns* detector-bias study: false positives for non-native English writers.
- GPTZero's published perplexity/burstiness explanation: documented vendor heuristic, not independent evidence.
- Turnitin's AI Writing Report guide: documented vendor limit that its report is not a standalone adverse-action basis.

Added topic `ai-writing-and-authorship` and concept `ai-writing-tells-and-avoidance`, with an actionable checklist covering lexical, structural, rhetorical, and punctuation/format habits. The concept explicitly separates evidence from online folklore and rejects detector-evasion cargo culting.

Updated source, topic, concept, and keyword indexes. `library-link-check.sh` passed for all four source clusters; `regenerate-topics-counts.sh --check` passed; `regenerate-sections-index.sh` landed the regenerated flat index.

Follow-up sent to liaison: consider a fleet-wide house-style integration near `roles/COMMON.md` and `skills/em-dash-style`, preserving the evidence and non-evasion limits.

Self-improvement: liaison recommendation routed through the journal message channel; this is a prospective cross-cutting house-style change, so no skill was edited directly.
