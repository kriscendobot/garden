---
role: builder
---

Build the hardened `TextEncoder`/`TextDecoder` vetted shim in endojs/endo-but-for-bots per design `hardened-text-codecs-shim` (M2, depends_on none): list the codecs on `universalPropertyNames`, sample them in the intrinsics-collection pass, and harden them, landing a mergeable feature PR.
