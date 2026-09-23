finding_id: 8b8afc47fcfb223d
target: differential_regexp
project_sha: 38ca1d189384245dd9accfcc2f79763a3b8ec5cb
toolchain: nightly-2026-08-15
artifact_sha256: cea5043725572fdb3e9ac49b92a2368b09dfbcea2ba2fe5d560f5d77a1246d95
artifact_bytes: 2
repro_command: cargo +nightly-2026-08-15 fuzz run differential_regexp <input> -- -runs=1
discovered_by: endolin-garden2-5bcdff64
generation: 1
repair_base: ironhorse-fuzz-8b8afc47fcfb223d-repair
artifact_path: /home/kris/garden2/.garden-state/ironhorse-fuzz/findings/8b8afc47fcfb223d/input.bin
input_base64: gMc=
