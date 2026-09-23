---
ts: 2026-06-15T20:55:00Z
kind: result
role: groom
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: "*"
short_id: f63ece
prs:
  - { repo: endojs/endo-but-for-bots, pr: 444, role: new }
refs:
  - entries/2026/06/15/203736Z-dispatch-groom-f63ece.md
  - entries/2026/06/15/204733Z-result-groom-f63ece.md
---

# result: groom — PR #444 M2 closure + maintainer-attention bulletin regen

## M2 verification

**Fully complete on llm.** Verified against HEAD 704c6f3da:
- `turbo.json` present + `turbo: ^2.9.10` pin.
- `.github/workflows/depcheck.yml` enforces
  `scripts/check-dependency-cycles.sh 0` (MAX_EDGES=0).
- All 5 break-dev-dependency-cycles cut packages present
  (`ses-test`, `hex-test`, `harden-test`,
  `eventual-send-test`) + the `@endo/zip` devDep cleanup.
- Tarjan SCC over 477 dep+devDep edges: 0 SCCs > 1 node;
  0 self-loops.
- M2's other six rows all Complete or Implemented.

The mirror PR #235 against master is M2-orthogonal (the
cycle is already broken on the project branch).

**No unfinished items — no head-of-bulletin follow-up row
needed.** Maintainer's hypothesis confirmed.

## New PR

**PR #444** DRAFT, base llm, head `groom/m2-and-bulletin-regen`.
One commit: `docs(designs): M2 (Project Hygiene) → Complete
on llm` (designs/README.md +34/-14).

## Bulletin maintainer-attention section

Eight-section regen (in PR #444 body):

1. **Gateway substrate (M3)** — 14 open gateway-package PRs
   (#343, #388-#397, #409, #410, #412, #413, #420). Phases
   2/7/8 are the canonical M6 P1 preconditions; #413 is the
   P0 HTTP-listener-wire-up gap (corrected: still DRAFT, not
   "already done" as my dispatch prompt mistakenly framed).
2. **Chat/UX (M9)** PRs: #405, #432, #440, #442, #403.
3. **11 recently-merged PRs** that clear prior bulletin
   items (#400, #376, #418, #131, #408, #423, #433, #439,
   #404, #106, #441).
4. **Design-gap roster (M5)**: gateway-oauth-bonding,
   gateway-key-recovery, gateway-stripe-adapter (+ likely
   fold-in of gateway-resource-classes).
5. **24 open questions** across four designer batches
   awaiting maintainer disposition (groom #400 = 5;
   chat-inventory-create-menu = 7;
   daemon-move-transfer-negotiation = 6;
   chat-value-modal-formula-view = 6).
6. Endo strategy workstreams A/B/C (carried forward from
   2026-06-11).
7. kriskowal/agoric-sdk#5 CI blocker (LogStore-Guarded;
   carried forward; resolution still pending maintainer
   choice between (a) widen / (b) authorize / (c) hybrid).
8. Two cross-fork drafts still parked (exo-import /
   exo-npm-registry; endo#1967 mirror).

## Out-of-scope honored

No ledger renumbering applied; no new design-gap files
authored; no upstream endojs/endo touch; bulletin
journal-side commit deferred to maintainer disposition per
the dispatch's PR-shaped-output rule.

## Self-improvement signal

Groom-side: "verify named PRs before placing them in bulletin
text" — re-polling caught #413 not-yet-merged (contrary to
my dispatch's framing) and PR #226 CLOSED (so dropped from
the proposed section). One-line addition to
`skills/groom-open-questions/SKILL.md` § Inputs proposed:
named PRs in proposed bulletin text must be re-polled within
the same dispatch.

Liaison-side: I shouldn't have asserted "already done in PR
#413" in the dispatch prompt without verifying. Loop again
through PR state before writing dispatch text containing PR
status claims.

Dispatch root torn down.
