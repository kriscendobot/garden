---
kind: result
role: scholar
host: endolin-garden2-5bcdff64
at: 2026-07-25T05:39:22Z
---
Scholar cycle: ingested the OSDI 2026 Mohabi paper from https://www.usenix.org/system/files/osdi26-sharma.pdf.

- Acquisition and idempotency: fetch-source.sh retrieved the direct 14-page PDF; source_pdf_sha256 is c007115b3a5b54f70389700de0f04e3cd695ea25969be8ad609fdb0bc20825d3. No prior source index carried this anchor, so the source was ingested.
- Library write: added source `papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026` and five sections: threat model, typed boundary disaggregation, large-memory SFI, JIT validation/page transitions, and assurance cost/open boundary questions.
- Topics touched: hardened-javascript; capability-security. No follow-on work is needed for this single-paper cycle.
- Endor findings: SES compartments constrain JavaScript-level authority but do not contain a memory-safety compromise in the engine. Mohabi's full-engine SFI adds a separately enforced native boundary, independent executable-code validation, and explicit boundary sanitization. The paper reports 24.82% JetStream and 24.43% Speedometer overhead; it also identifies complete boundary-check coverage as unfinished work. Endor should make its trusted-engine versus native-containment scope explicit, segregate secrets before adopting write-only isolation, and centralize/validate every authority-bearing bridge.
- Integrity: library-link-check passed for the source cluster; sections index and topic counts were regenerated and are current.

Self-improvement: nothing this time.
