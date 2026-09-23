---
ts: 2026-05-14T05:12:41Z
kind: message
role: scholar
to: liaison
---

# Consolidation review — overlap clusters in the current library

The first 13 scholar cycles built a baseline library of 129 sections from 16 endo source documents. As cycles 8, 10, and 12 surfaced, several source documents cover overlapping material. The soft-flag pattern (keep both with `notes:` cross-references) has worked operationally, but the maintainer may want to make consolidation decisions before the library grows larger. Routing this review to liaison for triage.

## Overlap clusters identified

### Cluster A: lockdown options (the largest overlap)

- **Canonical detail**: `endo--docs-lockdown--*` (15 sections, one per option) — `docs/lockdown.md`, comprehensive.
- **Reference summary**: `endo--docs-reference--lockdown-options-summary` (1 section consolidating 6 options) — `docs/reference.md`.
- **Guide-shape**: `endo--docs-guide--what-lockdown-does-removes-adds` (consolidates 3 H2s on lockdown's effects) — `docs/guide.md`.

These three cover the same `lockdown()` option material at three abstraction levels (background-shaped, reference-shaped, exhaustive-detail). The current `notes:` fields cross-reference. Potential consolidation: drop the reference summary (already pointed at `docs/lockdown.md`) and keep guide-shape for context, lockdown for detail.

### Cluster B: API verbs (lockdown / repair / harden)

- **Reference**: 4 sections in `endo--docs-reference--*-api` for lockdown, repairIntrinsics, hardenIntrinsics, harden, lockdown-and-harden.
- **Guide**: `endo--docs-guide--api-overview` (1 section consolidating all 4 verbs).

The reference per-verb sections are short (each ~10 lines). The guide-overview is the synthesis. Potential consolidation: drop the four separate reference sections; keep the guide overview as canonical.

### Cluster C: HardenedJS removes/adds inventory

- **Reference**: `endo--docs-reference--removed-by-hardened-js` and `endo--docs-reference--added-changed-by-hardened-js` (2 sections).
- **Guide**: `endo--docs-guide--what-lockdown-does-removes-adds` (consolidated as part of Cluster A).

Same material; the reference is the one-screen summary, the guide is more discursive. Recommend: keep reference (the table-like form), point guide at reference.

### Cluster D: Onboarding / using SES

- **Reference**: `endo--docs-reference--using-ses-with-your-code` (~60 lines).
- **Guide**: `endo--docs-guide--using-hardenedjs-with-your-code` (~31 lines).
- **Tutorial**: `endo--docs-get-started--installing` (~8 lines) + `endo--docs-get-started--first-steps-hardened-js` (~94 lines).

Three different shapes serving three reader needs: reference (quick lookup), guide (background-paced), tutorial (hands-on). These are useful as-is; no consolidation recommended, but the topic-page (`getting-started`) should clearly distinguish them.

### Cluster E: Library compatibility / ecosystem

- **SES README**: `endo--pkg-ses-readme--ecosystem-compatibility` (~62 lines).
- **Guide**: `endo--docs-guide--library-compatibility` (~16 lines).

Smaller overlap. Both kept; the guide pointer is enough.

### Cluster F: Bug disclosure / security policy

- **docs/security.md**: 3 sections covering coordinated-vulnerability-disclosure in depth.
- **docs/bugs.md**: 1 short pointer section.
- **packages/ses/README.md**: `bug-disclosure` (a brief pointer).

All three point at the Agoric HackerOne process. Strong overlap, low consolidation value (the pointers are useful where they appear in their source context).

## Cross-reference opportunities

Beyond the overlap clusters, the library has several places where a small "See also" pointer between sections would help an agent navigating from one concept to a related one:

- `endo--pkg-pass-style-readme--far` should cross-reference `endo--pkg-exo-readme--makeexo-single-instance` (the two are alternatives for constructing remotables).
- `endo--pkg-marshal-readme--convert-val-slot` should cross-reference `endo--pkg-eventual-send-readme--handled-promise` (CapTP's handler implementations plug both in).
- `endo--docs-message-passing--digital-purse-example` should cross-reference each component package's overview (exo, patterns, marshal, eventual-send).
- The four `eventual-send` integration-with-X sections (with-Exo, with-Endo) overlap and could note each other.

## Recommended next steps

1. **Maintainer decision on Cluster A** (lockdown options): keep all three or trim to two?
2. **Cross-references**: a future scholar cycle (or a dedicated cross-reference pass) could add the bullets above to relevant section bodies. Cost is small; benefit is concrete navigation aids.
3. **Topic-page abstracts**: review whether each topic page's `See also` section is current; some predate later ingestions and may have stale abstracts.

Self-improvement: this review is the first concrete output of the "review for consolidation" task. Worth a one-line addition to `library/conventions.md` describing the soft-flag pattern as the default and naming consolidation review as an explicit cycle task.
