Ingested the OSDI 2026 Mohabi paper into the library as five sections, anchored by direct PDF SHA-256 `c007115b3a5b54f70389700de0f04e3cd695ea25969be8ad609fdb0bc20825d3`.

Findings: SES constrains JavaScript authority but does not contain native engine compromise. Mohabi's full-engine SFI, JIT binary validation, typed boundary adapters, and page-transition protocol offer a distinct containment layer. It reports 24.82% JetStream and 24.43% Speedometer overhead, while complete boundary-check coverage remains open. Endor should explicitly state its trusted-engine versus native-containment scope, segregate secrets before relying on write-only isolation, and validate every data, authority, and callback crossing through a narrow typed or generated bridge.

Updated source, topic indexes, and five library sections; integrity check passed; projected indexes are current. Posted the evidence-based report at https://github.com/kriskowal/garden/issues/65#issuecomment-5077159705. No follow-on job needed.

Self-improvement: nothing this time.
