The design is delivered as an open PR against `main`. Inbox is empty, PR is OPEN and correctly targeted.

## Completion report

**Job:** `minion-town-vitals-weblet-design` — design the concrete first weblet on the git-content substrate: a vitals/telemetry frontend for the garden fleet.

**What I did**
- Read both prerequisite documents: the garden-side `fleet-telemetry-and-anomaly-response.md` (data source; the nine vitals, `fleet.json` snapshot, privacy posture) as amended by the just-landed `main2` commit `f6b453695e` that names the minion.town weblet the primary surface; and the sibling `minion-town-git-content-substrate-design`, which landed as PR #39 / branch `design/git-content-substrate` on kriscendobot/minion.town (not yet merged to `main`).
- Grounded the design in the **live gateway code** (`src/endo/gateway/isolation-headers.ts`, `content-server.ts`, `content-store.ts`) so the rendering constraints (frozen `script-src/connect-src 'self'` CSP, `safeContentType`, `index.html` resolution) are accurate rather than assumed.
- Wrote `designs/vitals-weblet.md` in the repo's own conventions (`# Design:` + bold Status/Mandate/Grounded-against/Companion block, 11 numbered sections, one validated mermaid diagram) and opened **PR #40** against `main`.

**Key design decisions**
- Content root = the bounded `journal2:vitals/` subdir holding **both** the static renderer and the fleet-written `fleet.json`/heartbeats, same-origin by construction so the renderer fetches `./fleet.json` — the only call the isolation floor permits.
- **Privacy-critical resolution of the cost/yield ask:** raw `usage/*.jsonl` / `reputation/` are deliberately **kept out of the public content root** (they carry absolute dollars / finer identity a public origin would leak irrecoverably); cost/yield surface only as the already-scrubbed derived fields in `fleet.json`. Richer views become a garden-side reducer change, never a client reach into raw ledgers. This upholds the carried-over privacy posture verbatim while honoring the mandate.
- Frontend-only (no threshold/derivation), base32 origin + cheap apex link, interim Pages-panel fallback, full-bulletin-migration explicitly out of scope but not foreclosed.

**Stated plainly (as the job required):** both prerequisites are **spec-only today** — `fleet.json` (garden telemetry Phase 1) is not built, and the substrate (G1–G3) is not built — so the weblet's implementation is a follow-on build job, gated on both. The one concrete demand on substrate G2 (extension→MIME map covering `.html/.js/.css/.json/.svg`) and open questions (exact cost/yield schema in `fleet.json`, renderer residency, alias, sync-failure visibility) are recorded rather than guessed past.

**Follow-ups:** PR #40 awaits review; a follow-on build job registers the source, authors the branch-side renderer, and edge-verifies — but only after both prerequisite builds land.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-vitals-weblet-design.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1903501 cached reads)
- Output: 30260 tokens
- Cost: $2.6650614999999993
- Wall-clock: 600s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
