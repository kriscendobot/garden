---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
kind: index
section_count: 19
---

Sections:

- [Six-layer XML-pass-through architecture with dormant-by-default debug and break-on-uncaught-via-firstJump-walk-before-fxJump](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--six-layer-xml-pass-through-architecture-with-dormant-by-default-debug-and-break.md)
- [§The-six-layer-stack](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--the-six-layer-stack.md)
- [§Three-option-architectural-decision (Option A chosen; B and C rejected)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--three-option-architectural-decision-option-a-chosen-b-and-c-rejected.md)
- [§Always-compiled-dormant-by-default (Design Decision 1)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--always-compiled-dormant-by-default-design-decision-1.md)
- [§Hot-attach via `"debug-attach"` envelope (Layer 6)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--hot-attach-via-debug-attach-envelope-layer-6.md)
- [§XML-pass-through Rust as opaque byte ferry (Layer 2)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--xml-pass-through-rust-as-opaque-byte-ferry-layer-2.md)
- [§C-platform-hooks → Rust callbacks (Layer 1)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--c-platform-hooks-rust-callbacks-layer-1.md)
- [§DebugSession SAX parser in SES (Layer 3)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--debugsession-sax-parser-in-ses-layer-3.md)
- [§Debugger exo as CapTP capability (Layer 4)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--debugger-exo-as-captp-capability-layer-4.md)
- [§followBreaks async iterator (Design Decision 6)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--followbreaks-async-iterator-design-decision-6.md)
- [§Break-on-uncaught-exceptions augmentation (the deepest move)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--break-on-uncaught-exceptions-augmentation-the-deepest-move.md)
- [§Four-edge-cases-named-and-defended](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--four-edge-cases-named-and-defended.md)
- [§Seven-Design-Decisions](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--seven-design-decisions.md)
- [§Six-phases (Phases 1-5 done; Phase 6 partial)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--six-phases-phases-1-5-done-phase-6-partial.md)
- [§File-inventory (the change footprint)](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--file-inventory-the-change-footprint.md)
- [§Two-design-dependencies](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--two-design-dependencies.md)
- [§Cohesion notes](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--cohesion-notes.md)
- [§Tier-1 borrowing](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--tier-1-borrowing.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk--synthesis-target.md)
