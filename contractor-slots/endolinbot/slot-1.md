---
slot: 1
status: in-flight
design_path: designs/cbors.md
pr_number: 288
current_stage: cleaner
in_flight_dispatch: 8cfa50
last_update: 2026-05-18T13:57:00Z
started_at: 2026-05-18T13:43:00Z
host: endolinbot
---

Builder shipped PR #288 (`@endo/cbors` framing package, llm base): new
package with head.js (CBOR major-type-2 byte-string head encoder/decoder
across all 5 width tiers), encode.js (writer), decode.js (async-iterable
reader), 31 tests covering boundary widths, streaming, diagnostic
surface, edge cases. Mutation regression-evidence: changing head encoder
breaks 14/31 tests. Separate `chore: Update yarn.lock` commit. Wiring
into daemon's envelope.js / bus-xs-core.js explicitly deferred. Now in
cleaner stage.

Dispatch root: `dispatches/cleaner--8cfa50`.
