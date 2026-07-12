---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr138-review-86c2eb0e
verdict: not-a-miss
category: new-direction
pr: 138
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/138#pullrequestreview-4680309727
identity: endojs/endo-but-for-bots#138:review:4680309727:retro
producing_role: designer
severity: minor
grounds: >
  kriskowal's CHANGES_REQUESTED review on PR #138 is an empty review body plus 15
  inline comments, every one attached to a single DESIGN DOCUMENT
  (designs/ocapn-daemon-integration.md), not to application code. Paraphrased, the
  directives are architectural decisions answering the design's own open questions:
  make Transports a formula; use a per-transport listen port with one shared
  transport instance that routes each session to the owning agent by Ed25519 public
  key; keep gateway and Transports flush on Ed25519 identity; have connect() take a
  public key + connection hint from the locator; throw on an unregistered scheme;
  do not expose netlayer versions; keep Transports and daemon-mount independent for
  now; per-agent CLI with delegable subagent transports; retire @nets; enable
  Node.js-worker transports for endor parity testing; on transport-formula
  collection close all sessions so presences/promises partition; plan a follow-up
  design on completion; treat the capability bank as an abstract-only requirement.
  This retro judges whether the garden REVIEW PROCESS should have anticipated these,
  and concludes it could not, on two dispositive facts drawn from the PR's actual
  history (not the comment text).
  First, PR #138 is a DESIGNER output — a design proposal on branch
  design/ocapn-daemon-integration whose own body carried a "10 Open Questions"
  section explicitly soliciting the maintainer's architectural direction. No
  gauntlet, panel, build, fix, or clean job exists for #138 anywhere on the board —
  only this review job and its retro. The code gauntlet/panel does not run on a pure
  design-doc PR, and correctly so: its seats (breaker, prover, typist, spec-keeper,
  stylist, packager, ...) lens over CODE correctness, style, spec, packaging and
  types, none of which can pre-decide how the maintainer wants the transport port
  model, identity routing, or CLI surface to work. There is no review surface that
  knew a convention and failed to bind.
  Second — and dispositive even had a panel run — every directive is a FIRST-STATED
  design decision resolving a question the design itself flagged as open. The
  designer's job is to surface the decision space and its trade-offs; choosing among
  them (per-transport vs shared port, route-on-identity, throw-vs-expose, retire
  @nets) is the maintainer's design authority, exercised in this review. Nobody — no
  juror seat brief, skill, or standing instruction — encodes the maintainer's
  intended answers to open architectural questions, because encoding them would BE
  the design work this PR exists to elicit. The primary loop handled it exactly
  right: it folded each of the 15 directives into resolved "Design Decisions,"
  reworked the layer-cake/capability-surface body to the shared identity-routed
  transport model, and recorded the two requested forward follow-up designs — a
  correct new-direction absorption, not a corrective fix of an overlooked defect.
  Structurally and substantively of a piece with the prior #135 (review-63a86be1)
  and #124 (review-a736154b) dismissals: a pre-gauntlet, maintainer-directed PR
  whose feedback is forward architectural direction resting on the maintainer's own
  design intent. New direction, not a garden review-process miss. Recorded as a
  durable dismissal so the same review is never re-litigated. No cluster minted; no
  improvement dispatched.
---

# Dismissal: endo-but-for-bots #138 review 4680309727 (retro)

kriskowal's CHANGES_REQUESTED review on PR #138 is an empty body plus 15 inline
comments, all on a single DESIGN DOCUMENT (`designs/ocapn-daemon-integration.md`).
Paraphrased, each is an architectural directive answering the design's own open
questions — make Transports a formula; per-transport listen port with one shared,
Ed25519-identity-routed transport instance; gateway/Transports flush on Ed25519;
`connect()` takes a public key + hint from the locator; throw on unregistered
scheme; do not expose netlayer versions; keep Transports/daemon-mount independent
for now; per-agent CLI with delegable subagent transports; retire `@nets`;
Node.js-worker transports for `endor` parity; close all sessions on
transport-formula collection so presences/promises partition; plan a follow-up
design on completion; capability bank is abstract-only.

Not a garden review-process miss. PR #138 is a **designer** output whose body
carried an explicit "10 Open Questions" section soliciting exactly this direction;
its whole purpose is to surface the decision space for the maintainer to resolve.
No gauntlet/panel/build/fix job ran on it — the code panel does not (and should
not) run on a pure design doc, since its seats lens over code correctness, style,
spec, packaging and types, none of which can pre-decide the maintainer's transport
port model, identity routing, throw-vs-expose choices, or CLI surface. Every
directive is a first-stated design decision — the maintainer's design authority
exercised in review, not a convention a seat knew and failed to bind. The primary
loop handled it correctly as new direction: it folded all 15 directives into
resolved "Design Decisions" and recorded the two requested follow-up designs, an
absorption of forward direction rather than a corrective fix. Directly parallels
the #135 (review-63a86be1) and #124 (review-a736154b) dismissals. First-stated
forward direction, not a miss. See comment_url for the verbatim review.
