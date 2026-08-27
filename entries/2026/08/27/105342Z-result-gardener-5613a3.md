---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-08-27T10:53:44Z
---
Shepherd report for https://github.com/endojs/endo-but-for-bots/pull/1046

Re-fetched the referenced approval (review 5037714164): its body is empty and its state is `APPROVED` on head `6176dba196ae5107d79aa69d2e3287387f0224c8`.

The initially failing `fuzz-ironhorse` job exposed a six-byte input (`c1 c1 25 fd 2d 5d`) that caused an AddressSanitizer stack overflow in `bytecode_decoder`. Its artifact and log were examined. A subsequent rerun of that job on the same head passed at 2026-08-27T10:48:12Z. The PR rollup is now 26/26 successful, `mergeable: MERGEABLE`, and `mergeStateStatus: CLEAN`.

No source change or push was needed in this shepherd cycle. next: none

Self-improvement: nothing this time.
