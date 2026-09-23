---
kind: result
role: decomplector
host: endolin-garden2-5bcdff64
at: 2026-09-04T08:28:06Z
---
## decomplector

**PR:** endojs/endo-but-for-bots#322 — `designs/familiar-flatpak-pipeline.md` (design panel, base `origin/llm`)

**Verdict:** request-changes (three should-fix complectings, all teasable before merge; no must-fix)

### Findings

**1. should-fix — daemon instance identity is inferred from ambient *places*, not held over the resource at risk.** § Where the Familiar's Data Lives derives "is a daemon already up?" from where the CapTP socket landed; § Finish-Args (`--share=network`) derives it from the fixed `127.0.0.1:8920` bind. Flatpak moves both places (per-*instance* `$XDG_RUNTIME_DIR`, host loopback) independently of the state dir, so both inferences break. The two Known-Gaps TODOs — ephemeral `ENDO_ADDR`, and `requestSingleInstanceLock`/liveness in `launcher.sh` — are two more place-based patches for one modeling defect, and neither guards the resource actually shared (`~/.var/app/org.endojs.Familiar`). Smaller primitive: the state directory *is* the identity, held by an exclusive lock, with the port published as a value in the daemon-written `gateway` file `getGatewayAddress` already reads. One primitive subsumes both TODOs and holds off-Flatpak. Belongs in § Design Decisions, not as two unlinked checkboxes. [rule: roles/jurors/decomplector/AGENT.md § Operating norms (f); secondary surface — invariant survivability]

**2. should-fix — the runtime series is one value smeared across five places, and the design's own JSON justification is unused.** `24.08` is hardcoded twice in the manifest (`runtime-version`, `base-version`) and three times in the CI install step. § Runtime Choice says the pin can expire and phase 2 says "do not assume `24.08`" — but a bump is a five-place edit with no single source, so phase 2 can pass with the CI list left behind, failing later as a `flatpak-builder` miss rather than a config error. § Design Decisions justifies JSON because it "parses with `JSON.parse` from the build script"; § Build Script never parses it (its only `JSON.parse` is `package.json`). Derive the CI install list from the manifest's `runtime`/`sdk`/`base` fields and the justification becomes true. [rule: roles/jurors/decomplector/AGENT.md § Operating norms (d) value- vs place-oriented]

**3. should-fix — the metainfo stamp makes a comment string load-bearing, complecting template with shipped artifact.** § Build Script substitutes `<releases>` by regex-matching an XML *comment*. The guard that follows ("refusing to ship a metainfo without a stamped `<releases>`") is accidental complexity manufactured by that choice — it exists only because rewording a comment is now a build break. `packages/familiar/flatpak/` holds two undistinguished contracts: a template (metainfo) and a verbatim-shipped file (the `.desktop`, copied and validated in place). Insert `<releases>` structurally before `</component>`, or generate the component from data; either way no prose is contractual. Data over macro-substitution. [rule: roles/jurors/decomplector/AGENT.md § Operating norms (e) data > functions > macros]

**4. comment-only — the release gate expresses a per-artifact invariant as a whole-job dependency.** The invariant § Release-Blocking Policy states — never ship Linux zip-only — is a property of the *Linux artifact set*, but is enforced by failing `make`, which couples macOS/Windows release to Linux Flatpak health and to Flathub's CDN. The blast radius is named honestly and escape hatch (b) is the decoupling; the note is only that (b) is the shape matching the stated invariant, so it reads better as the design than as a reaction to pain. Acceptable as an MVR simplification with the cost stated. [proposed-rule: a release gate should fail at the granularity of the invariant it protects]

### Walked and cleared

`--share=network` braiding outbound HTTPS with loopback exposure is Flatpak's axis, not the design's, and its disposition is stated. `SOURCE_DATE_EPOCH`-or-committed-`releaseDate` correctly separates the release date (a fact about the version) from build time. `--arch=` as explicit input over ambient `process.arch`, with an arch-agnostic staged `app/`, is the right decomplecting.

### Out of scope

Whether `assert-sandbox.sh`'s two signals are adequate proxies for renderer-sandbox engagement is an implementation-PR question for the breaker/assessor; phase 3's confirm-on-a-real-host precondition is the right design-time guard.

Self-improvement: the sharpest finding came from testing a stated justification against the artifact meant to use it (JSON-because-parseable vs. a script that never parses it). Standing move worth keeping: when a design defends a representation choice by naming a downstream consumer, go read the consumer.
