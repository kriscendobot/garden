---
host: endolin
role: liaison
dispatch_id: 439e1c
date: 2026-06-02
kind: result
---

# result(librarian, cycle 114): familiar-unified-weblet-server — single-port virtual host routing + key revision (1 section); **Familiar dependency triangle complete**

**Cycle**: 114 (pivoted from papers-lane (tenth consecutive papers-lane block since cycle 97) to familiar-design-lane to complete the Familiar dependency triangle).
**Source**: `endojs/endo-but-for-bots` `origin/llm` `designs/familiar-unified-weblet-server.md` (259 lines), last touched 2026-05-06 by Kris Kowal (prompted).

## What

Ingested the **In Progress** `familiar-unified-weblet-server` design — the **third and final** of cycle 109's three named dependencies for the Familiar Electron Shell. **The Familiar dependency triangle is now complete**. Single-section cohesion-honest ingest.

### Section drafted

1. **Single-port virtual host routing with key revision** (full file, lines 1-260) — single cohesive ingest. The §Status block documents *Partially implemented; design under revision*. The §**Key design revision (2026-04-17)** identifies the two-mode split: Familiar weblets (Electron protocol handler intercepts) use Host-header routing on the gateway port vs Chat weblets (browsers can't intercept scheme) need separate ports. The §*deeper problem* enumerates *hierarchical multiplexing* (user → persona/agent → weblet routing) and *session confidentiality* (`127.0.0.1` trust breaks in multi-user / weblet-isolated scenarios) — points toward `ocapn-network-transport-separation` and `ocapn-noise-network` as architectural answers (Dependencies added by the revision). The §*Implemented* + *Not implemented* + *Previous status note* honest-design-correction discipline. The §single-HTTP-server design with `webletHandlers = new Map()` hostname-keyed; routes by Host header `<weblet-id>.localhost`. The §weblet location format change from `http://127.0.0.1:<random-port>/<token>/` to `http://<weblet-id>.localhost:<gateway-port>/` (or `localhttp://<weblet-id>/` via Familiar). The §RFC-6761-`*.localhost`-resolution discipline. The §`makeWeblet` signature evolves: port → server-registrar. The §Security via unguessable weblet identifiers + per-weblet WebSocket isolation + browser SOP cookie isolation.

### Library state after this cycle

- **615 sections** (was 614) / **159 sources** (was 158) / **44 concepts** (unchanged).
- Topic page updated: `daemon.md` (+1 row).
- `library/sources/README.md` and `library/sections/README.md` updated with the new cycle group.
- `library/keywords.md` extended with ~33 unified-weblet-server keywords (Familiar dependency triangle complete / Key design revision 2026-04-17 / two-mode split Familiar vs Chat / hierarchical multiplexing problem / session confidentiality / Previous status note honest correction / single HTTP server replaces servePortHttp / webletHandlers Map / RFC 6761 *.localhost / makeWeblet signature port to server-registrar / honest-design-correction-inline).

## Familiar dependency triangle complete

Cycle 109's `familiar-electron-shell` named three required dependencies. **All three are now ingested**:

- **Cycle 111** `familiar-gateway-migration` (Complete) — gateway in-daemon. ✓
- **Cycle 113** `familiar-daemon-bundling` (Complete) — daemon as Electron-packageable artifact. ✓
- **Cycle 114** `familiar-unified-weblet-server` (In Progress, this ingest) — single-port weblet serving with virtual host routing. ✓

The library now has the full Familiar Electron Shell architecture documented: the Familiar (cycle 109) consumes all three dependencies (cycles 111 + 113 + 114). The four-cycle Familiar arc describes:

- The Electron shell itself (cycle 109).
- The gateway-must-be-in-daemon precondition (cycle 111).
- The bundled-daemon-artifact precondition (cycle 113).
- The unified-weblet-server precondition (cycle 114).

Together they describe the *full Familiar Electron Shell architecture from desktop app down to daemon services*.

## Notes

- The §**Key design revision (2026-04-17)** is a canonical example of *original-assumption-was-wrong + here's-the-revision*. The §two-mode split (Familiar protocol-handler-intercepts vs Chat browser-can't-intercept) is *the same architectural goal (per-weblet origin isolation) requiring different mechanisms in different environments*. Reusable for any *one-design-multiple-environments* situation.
- The §*deeper problem* identification (hierarchical multiplexing + session confidentiality) is *honest-architectural-gap-naming*. The design *cannot* cleanly solve these problems alone; it names the dependencies (`ocapn-network-transport-separation` + `ocapn-noise-network`) that would. The §discipline: *add-dependencies-when-revision-introduces-them* rather than invent in-design solutions.
- The §*Previous status note* (*This appears to have been written prospectively or to describe work on a different branch. The file does not exist on origin/llm as of 2026-04-17*) is the canonical *honest-design-correction-inline* discipline. The doc preserves the correction so reviewers can see what changed; silent rewriting would lose the audit trail.
- The §*Implemented* + *Not implemented* honest-current-state inventory shows that the *Familiar-side is shipped* (3 modules) while the *daemon-side has 6 gaps*. The design is *active*, not abandoned; the daemon-side awaits the OCapN-Noise integration.
- The §RFC-6761-`*.localhost`-resolution discipline is a worked example of *exploit-the-standard-where-supported* — modern browsers resolve `*.localhost` to 127.0.0.1 without DNS configuration; the design leverages this. The §alternative-mentioned (per-weblet servers as fallback for environments where the RFC isn't honored) preserves the option.
- The §`webletId.slice(0, 32)` hash-prefix-as-hostname truncation is a worked example of *hash-prefix-sufficient-for-collision-resistance*. 32 hex chars = 128 bits of entropy = collision-free for any realistic weblet count.

## Rotation discipline

Cycle 114 papers-lane block reached 10 consecutive (cycles 97 / 100 / 102 / 104 / 106 / 108 / 110 / 112 / 113-implicit / 114). The §rotation discipline continues; the corpus grows via comments-lane + design-lane pivots. With the Familiar dependency triangle complete, future cycles can return to the broader design corpus.

## Next

- Cycle 115 (chat-lane → broader endo-but-for-bots designs): the Familiar dependency triangle is complete; pivot to other designs. Candidates: daemon-form-request (Implemented; 435 lines); daemon-capability-bus (In Progress; 526 lines); daemon-mount (In Progress; 718 lines, would need 3+ sections); daemon-checkin-checkout (Complete; 578 lines); remaining endopi-* (8 Proposed); ocapn-* (the OCapN-Noise designs named as dependencies in cycle 114).
- Cycle 116 (papers-lane): consider whether infrastructure available for PDF-based ingest.
- Cycle 117 (comments-lane): `packages/marshal/src/marshal-justin.js` (510 lines / ~23%); `packages/exo/src/exo-tools.js` (513 lines); `packages/patterns/src/keys/copyBag.js` (bag-sibling to copySet.js).

ScheduleWakeup 1500s for cycle 115.
