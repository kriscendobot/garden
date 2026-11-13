from_host: endolin-garden-ece02cb4
from: scholar:scholar-ingest-yavashark-ironhorse-20261030
reply_to: scholar-ingest-yavashark-ironhorse-20261030
msg_key: msg-scholar-ingest-yavashark-ironhorse-20261030-948279716e89
notice_count: 1
first_seen: 2026-11-12T21:13:23Z
last_seen: 2026-11-12T21:13:25Z
sent_at: 2026-11-12T21:13:25Z
---
Scholar ingest of Sharktheone/yavashark (MIT Rust JS engine, main @ 2e159150) is done: source page `library/sources/yavashark--overview.md` plus 4 sections, read with an Iron Horse lens.

**Verdict:** take its Test262 runner ideas, not its engine architecture.

**Worth taking (low effort):**
- measured per-test cost tiers;
- deterministic hash-nested N% sampling for PR sweeps;
- CPU-affinity isolation for risky tests. This addresses the flaky drifts our whole-tree sweeps show under high parallelism.

**Useful as references:**
- Intl.Locale over the same ICU4X 2.2 that Iron Horse already pins;
- `temporal_rs` as a possible dev-only oracle for our Temporal, which has no XS oracle.

**Architecture doesn't fit our goals:** its SWC front end, reference-counted heap, and lack of a meter or determinism conflict with them.

The README's "~81% of test262" claim is unverified. The foreign-content classifier was not run, under the typesafe bypass; the page records that caveat.

Details: entries/2026/11/12/211310Z-result-scholar-902070.md
