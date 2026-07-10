---
role: designer
---

Design/sequence the M3 module-loading capability stack in endojs/endo-but-for-bots (base `llm`): reconcile the four interlocking Proposed designs — `registry-capability` (`@registry` EndoRegistry shape + JS reference backend), `mvs-resolver` (MVS graph-walk algorithm), `snapshot-mapper` (`mapSnapshot`/`makeMountReadPowers`), and `daemon-worker-import-from-mount` (`makeFromPackage` worker dispatch + CLI) — into one accepted, dependency-ordered phased build plan so a worker can `importLocation` an npm-style package tree from a mount, updating each design record's status/depends_on accordingly.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 13
  claimed_at: 2026-07-10T02:27:22Z
