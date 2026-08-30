finding_id: 2276f4edebdcb3bb
target: differential_regexp_surface
project_sha: 38ca1d189384245dd9accfcc2f79763a3b8ec5cb
toolchain: nightly-2026-08-15
artifact_sha256: 4f0d6ca037b3a7536fa8e0595f92fd251fbd6aa459d916652f87a3e9f7ad111e
artifact_bytes: 5
repro_command: cargo +nightly-2026-08-15 fuzz run differential_regexp_surface <input> -- -runs=1
discovered_by: endolin-garden2-5bcdff64
generation: 1
repair_base: ironhorse-fuzz-2276f4edebdcb3bb-repair
artifact_path: /home/kris/garden2/.garden-state/ironhorse-fuzz/findings/2276f4edebdcb3bb/input.bin
input_base64: pKSkpKA=
