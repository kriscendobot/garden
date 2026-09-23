---
ts: 2026-05-19T23:13:49Z
kind: result
role: groom
project: endo-but-for-bots
worktree: dispatches/groom--b7603b/project
refs:
  - entries/2026/05/18/062941Z-message-general-contractor-statussync.md
---

# Design-status sweep — PR #304 (draft)

Authorized 2026-05-18 by the maintainer after the general-contractor's
escalation. Sub-mode: a one-off status reconciliation pass (broader than
the targeted-post-event sub-mode in `roles/groom/AGENT.md` but narrower
than a full grooming pass; no velocity recalibration, no roadmap
re-projection, no dependency-graph edits beyond annotating three nodes
COMPLETE).

## Outcome

- **PR**: https://github.com/endojs/endo-but-for-bots/pull/304 (draft).
- **Branch**: `chore/designs-status-sweep-202605`.
- **Base**: `llm`.
- **CI at open time**: no checks reported yet (status-rollup empty;
  expected for a docs-only diff that the paths-filter skips most jobs
  for).
- **Files touched**: 13 (one README, twelve per-design files).
- **One commit**: `chore(designs): sweep Status fields to reflect
  actual implementation state (per maintainer directive 2026-05-19)`.

## Per-design classification

**Shipped, status-only update needed (10 designs)**:

| Design | Was | Evidence |
|---|---|---|
| `base64-native-fallthrough` | Not Started | commit `7325bbe15` (via `actual/master` merge from `endojs/endo#3216`) |
| `ci-no-npm-lifecycle` | Not Started | PR #126 merged 2026-05-15; `.yarnrc.yml` pins `enableScripts: false` |
| `chat-view-edit-commands` | Not Started | direct commit `ae2b074ac` "Blob view and edit" + refinements |
| `daemon-checkin-checkout` | Not Started | `endo ci`/`co` aliases in `packages/cli/src/endo.js` |
| `daemon-content-store-gc` | Not Started | PR #99 merged 2026-05-07 (README already said Complete) |
| `chat-rename-dismiss-to-clear` | "PR #93" | PR #93 merged 2026-05-04 |
| `chat-playwright-smoke` | "PR #94" | PR #94 + #95 + #104 all merged |
| `unhandled-rejection-display` | Proposed | PR #187 merged 2026-05-12 |
| `ocapn-noise-network` | Not Started | PR #137 merged 2026-05-08 |
| `hex-package` | Not Started | `@endo/hex` at `packages/hex/`; `@endo/hex-test` PR #211 |

**Partially shipped (1 design)**:

- `break-dev-dependency-cycles`: Proposed → In Progress. Cuts 2-5
  merged (PRs #211, #209, #210, #247); Cut 1 (ses-test) open as PR
  #261; upstream mirror tracking PR #235.

**Per-file Status caught up to README (1 design)**:

- `daemon-os-sandbox-plugin`: per-file Status was "Not Started"; the
  README and milestone tables already showed Superseded by
  `endo-posix-sandbox`. The file now matches.

**Still unshipped, no change**: every other Not Started / Proposed /
In Progress / Active row was audited and left as-is. The substrate
audit confirmed accurate state for `endo-posix-sandbox` (Phase 3),
`daemon-mount` (Phases 1,2,3,5; Phase 4 in PR #135/#127),
`platform-fs`, `daemon-make-archive` (Phases 1-5 done; 6-8 in flight),
`daemon-xs-worker-snapshot`, `daemon-cas-management`,
`endor-run-expanded`, `endor-npm-registry-proxy`,
`ocapn-network-transport-separation`, `familiar-unified-weblet-server`,
`familiar-localhttp-protocol` (partially implemented; no metadata table
— a small per-file gap, not a status gap), `daemon-locator-terminology`,
`daemon-xs-worker-debugger`, `daemon-agent-network-identity`, and
others.

## README math (mechanical)

Items remaining per milestone, mechanically decremented for the six
milestone-bound designs that flipped to Complete:

- M1: 12 → 9 (`base64-native-fallthrough`, `ci-no-npm-lifecycle`,
  `hex-package`)
- M2: 7 → 6 (`ocapn-noise-network`)
- M3: 9 → 8 (`daemon-checkin-checkout`)
- M4: 12 → 11 (`chat-view-edit-commands`)
- Total remaining: 50 → 42

A seventh shipped design (`unhandled-rejection-display`) is not in any
milestone table. Effort estimates and review-queue projections are not
re-projected.

Summary totals refreshed: 36 Complete/Implemented, 16 In Progress, 37
Not Started, 8 Proposed, 3 Active, 3 Reference, 2 Deprecated, 1 Draft,
1 Superseded (107 designs; up from the prior 104 because the README's
trailing "*See also*" block has accumulated several additions since
the prior groom pass — those rows already existed in the summary table
and were not modified by this sweep).

Three Mermaid graph nodes annotated COMPLETE in line with the new
status: `dci` (`daemon-checkin-checkout`), `onoise`
(`ocapn-noise-network`), `cvedit` (`chat-view-edit-commands`).

## Notes flagged for maintainer (no edits)

- The escalation message named `chat-edit-message-ui` as already-shipped,
  but the implementation PR #125 (`feat(daemon): add editMessage and
  messageHistory`) is still open and no `editMessage` / `messageHistory`
  symbol exists in `packages/chat` or `packages/daemon` on `llm`. The
  design PR #88 merged 2026-05-06 was design-only. Left as Not Started.
- The body of `chat-edit-message-ui.md` claims "The daemon now exposes
  `editMessage` and `messageHistory`" — that prose is incorrect against
  llm HEAD. Design body is out of scope for this sweep; flagged for a
  future correction.
- Several design files lack any frontmatter Status field at all
  (`outliner-design-doc-2.md`, `outliner_drag_and_drop.md`,
  `OUTLINER_INTERACTION_PATTERNS.md`, `worker-rust-xs.md`,
  `hardened-text-codecs-shim.md`, `hardened-url-shim.md`,
  `familiar-localhttp-protocol.md`). None except
  `familiar-localhttp-protocol` are listed in `designs/README.md`, so
  this sweep did not touch them. A follow-up curation pass could either
  add metadata tables or relocate them.
- The original README total (104) does not equal the actual row count
  (107); three rows have been added without updating the totals line.
  The new totals line in this PR reflects the actual row count.

## Process notes

- The substrate audit relied on three signals per design: (a) grep
  `packages/` for named symbols and file paths from the design, (b)
  `git log llm --oneline -- <path>` for relevant commits, (c)
  `gh pr list --state all --search "<slug>"` to find related PRs.
  Slug-only PR search was unreliable for several designs (e.g.,
  `base64-native-fallthrough` ships via upstream squash without the
  slug in the message); the verb / symbol names in the design body
  were the more reliable join key, as the slot-1 #129 impasse already
  taught the contractor.
- One design (`break-dev-dependency-cycles`) needed a partial-shipped
  classification rather than binary shipped / unshipped. Recording
  per-cut state in the file gave the substrate the right granularity
  without forcing the design into either Complete or Proposed.

Self-improvement: when reading an escalation message that names
specific designs as "already shipped", treat each claim as a
hypothesis to verify against substrate rather than as a confirmed
fact; the `chat-edit-message-ui` case in this sweep would have been
mis-classified Complete if the escalation had been trusted blindly,
because the design PR merged but the implementation PR did not.
