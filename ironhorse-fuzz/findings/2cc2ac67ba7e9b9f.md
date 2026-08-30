finding_id: 2cc2ac67ba7e9b9f
target: differential_regexp_surface
project_sha: 38ca1d189384245dd9accfcc2f79763a3b8ec5cb
toolchain: nightly-2026-08-15
artifact_sha256: aeadab4b457f5d6f444bdc51c1ec6d9a362318f1f45282b21a5e10308b002f6f
artifact_bytes: 26
repro_command: cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1
discovered_by: endolin-garden2-5bcdff64
generation: 1
repair_base: ironhorse-fuzz-2cc2ac67ba7e9b9f-repair
artifact_path: /home/kris/garden2/.garden-state/ironhorse-fuzz/findings/2cc2ac67ba7e9b9f/input.bin
input_base64: i4uLiwAAAAAAs9/f39/fqaqqqqqqqgIAAAA=
