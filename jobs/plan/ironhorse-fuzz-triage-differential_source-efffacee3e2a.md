---
gate: blocked
blocked_on: https://github.com/kriscendobot/garden/issues/91
priority: normal
posted_by: proxy
posted_at: 2026-09-17T02:04:44Z
---

---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

<!-- ironhorse-fuzz-target: differential_source -->
<!-- ironhorse-fuzz-kind: triage -->

# Triage 7 Ironhorse fuzz finding(s) for target `differential_source`

The `ironhorse-fuzz` service captured reproducers for the Ironhorse JS engine port.
Classify each into a bounded, durable triage record so only clusters of PROBABLE
port defects buy repair work; known oracle/harness artifacts and duplicates end here.

## Members (bounded metadata — never paste input bytes into a prompt or a shell command)

- Finding `2135159d233fe4aa`: sha256 `d3b77bfae9b0dfc392c0c00a1a0083f3ee0ce84e3e0ce24da9e6b75875ebf247` (18 bytes), project `e84a4c83c049f1b113436c0fcceddfb5be9be9a4`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/2135159d233fe4aa/input.bin`, journal `ironhorse-fuzz/findings/2135159d233fe4aa.md`
- Finding `4487277f5808bdac`: sha256 `dd589bf70f4b6d04dba29a0d225cf9788d9040b334faefbda079ff8ca455d2a9` (7 bytes), project `f109e8f42281556439434b71c9717811185b9155`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/4487277f5808bdac/input.bin`, journal `ironhorse-fuzz/findings/4487277f5808bdac.md`
- Finding `61316f6430876285`: sha256 `a99594c3bfb000bcb8de02e6efa60bba20839ebf5b9d7f0695fbc44a3a6418d3` (32 bytes), project `e84a4c83c049f1b113436c0fcceddfb5be9be9a4`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/61316f6430876285/input.bin`, journal `ironhorse-fuzz/findings/61316f6430876285.md`
- Finding `803c1d4e40fc8ea7`: sha256 `9782285f82fbdf81ec7c2e64e12dc9f2d80fe70ccdf84233ad668609f5c54176` (28 bytes), project `f109e8f42281556439434b71c9717811185b9155`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/803c1d4e40fc8ea7/input.bin`, journal `ironhorse-fuzz/findings/803c1d4e40fc8ea7.md`
- Finding `e2fb620d09eb83f5`: sha256 `9dfe2a8b3e582b3abe4c7255a4348011f0393a574bf6001b99e78898e0b65bb5` (12 bytes), project `f109e8f42281556439434b71c9717811185b9155`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/e2fb620d09eb83f5/input.bin`, journal `ironhorse-fuzz/findings/e2fb620d09eb83f5.md`
- Finding `e30beb6cbf8d33e4`: sha256 `56919fb3401efb4a38283225fdbfda1ff4cea53de2075b528d0f8c4728388cc1` (4 bytes), project `f109e8f42281556439434b71c9717811185b9155`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/e30beb6cbf8d33e4/input.bin`, journal `ironhorse-fuzz/findings/e30beb6cbf8d33e4.md`
- Finding `eb71f6175d4ed5c0`: sha256 `a5561983ae1a13e07514d625ac960cf6468819b412ea5791f55f2da74f71e1ec` (35 bytes), project `f109e8f42281556439434b71c9717811185b9155`, artifact `/home/kris/garden/.garden-state/ironhorse-fuzz/findings/eb71f6175d4ed5c0/input.bin`, journal `ironhorse-fuzz/findings/eb71f6175d4ed5c0.md`

## Procedure (per member, per designs/ironhorse-fuzz-triage-and-batch.md)

1. Recover the minimized input to a FILE (decode `input_base64` from the finding marker
   with `base64 -d`, or copy the durable artifact path). Verify its `sha256`.
2. Reproduce by path at the recorded project SHA, and re-run at the current standing head
   (`ironhorse-fuzz-findings-2` branch of `endojs/endo-but-for-bots`).
3. Run the target-specific diagnostic adapter and write `ironhorse-fuzz/triage/<finding-id>.md`
   (schema 1) with bounded fields only — `status` (genuine|artifact|duplicate|pending),
   `failure_kind`, `failure_site`, `semantic_relation`, `input_shape`, `root_signature`,
   `evidence_sha256`, `evidence_path`, `classified_at_project_sha`, and for a terminal
   disposition a named `reason` (artifact) or `canonical_finding` (duplicate). Never put raw
   input text in any field.
4. A known-artifact relation becomes an automatic suppression ONLY once a versioned
   deterministic matcher exists under `ironhorse-fuzz/suppressions/`; a new relation stays
   `pending` until then. When uncertain, leave `status: pending` — an inconclusive triage
   never becomes repair work.
5. Land every triage record with journal CAS discipline. Post NO repair job — the producer
   batches genuine findings into one cluster repair on a later tick.
