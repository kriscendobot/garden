---
kind: dispatch
role: cleaner
host: endolinbot
posture: liaison
short_id: 8cfa50
dispatch_root: dispatches/cleaner--8cfa50
repo: endojs/endo-but-for-bots
branch: feat/cbors-package
pr_number: 288
slot: 1
---

Cleaner stage for slot 1 PR #288 (`@endo/cbors` framing package).
Builder shipped 31 tests across 3 ses-ava configurations. Cleaner brief:
lint/format pass, coverage audit, adversarial sweep on CBOR head
parsing (RFC 8949 conformance: malformed indefinite-length forms,
non-byte-string major types, overlong head encodings, head boundary
arithmetic at 2^53 limit), drift check against the design's deferral
list (no accidental codec features beyond byte-string head).
