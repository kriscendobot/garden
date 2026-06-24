---
ts: 2026-06-03T17:42:10Z
kind: result
role: liaison
host: endolinbot
to: "*"
refs:
  - entries/2026/06/03/173144Z-dispatch-liaison-8f3bda.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 394
    role: target
---

# result: #394 spike #369 discoveries applied; new head a57332f69

Maintainer @-mention "Please take a look at the spike for
git-backed CAS and apply discoveries here" closed cleanly via
fixer `8f3bda`.

## Outcome

- **New head**: `a57332f69` on `design/gateway-package-phase-6`
  (regular append on `119d21f45`).
- **Top-level comment**: `4615146728`.
- **Inline reply** on thread `3350596749`: `3350655684`.

### Per-axis verdict

| Axis | Status | Reason |
|---|---|---|
| 1 (objects = git objects) | deferred | daemon-internal (rust/endo/src/cas.rs); dispatch excluded rust/ |
| 2 (trees = git trees) | deferred | same daemon-internal scope |
| 3 (bulk transport off CapTP) | applied | design cross-ref: gateway's smart-HTTP is the carrier |
| 4 (retention = refs + git gc) | applied | design corrections + new paragraph |

### Cross-cutting corrections (folded into same section)

- **Library**: `git2` (libgit2) ratified per spike Status;
  `gix` alternative recorded with ruling explained (libgit2
  vendored; `endor` crate already links bundled C).
- **Content key**: REVERSED the prior incorrect "SHA-256 Git
  variant" framing that contradicted the spike. Endo sha256
  stays content key; git's internal object DB runs in default
  SHA-1 format behind a `sha256 → git-oid` index.

### Files

- `designs/gateway-package.md` (+56/-4): Feature 3 daemon-side
  scope section rewritten with spike discoveries.
- `designs/README.md` (+1/-1): gateway-package row Updated
  date sync per project convention.

No code changes (gateway wire shape at `119d21f45` already
matched the spike's framing).

### Local gates

- `yarn lint`: 0 (170 carry-warnings, none introduced).
- `yarn lint:types`: 0.
- `yarn ava`: 279/279 passing including live
  git-http-integration.

## Teardown

`dispatches/fixer--8f3bda` torn down.

## Steward queue post-engagement

- **#394** spike discoveries applied; awaits reassessment.
- **#414** 0xpatrickbot CI repair for master→llm merge red
  spots; not steward scope.
- **#387, #351, #379, #411, #343** unchanged from prior
  entries.
- **garden #3** MERGED; maintainer extending main directly.
