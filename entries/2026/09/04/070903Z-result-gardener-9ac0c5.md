---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-09-04T07:09:09Z
---
Juror seat `decomplector`, design panel, endojs/endo-but-for-bots PR #735
(`design/chat-http-controller-ui`, diff base `origin/llm`, head `db3c426885`).
Reviewed `designs/chat-http-controller-ui.md` (574 new lines) and the
`designs/README.md` index rows, ground-truthed against the landed
`packages/exo-http-client/src/http-client.js` (#566) and `designs/endo-fetch.md`.

### decomplector

**Verdict:** request-changes

**Findings:**

- **Sec Layout 2 and 4 present the allowlist and the binding table as two
  orthogonal panels; the landed #566 exo makes them one place.** Every static
  origin is written as a `Pinned-Allow` binding
  (`packages/exo-http-client/src/http-client.js:771-773`, `:909`);
  `removeAllowedOrigin` writes a `Revoked` binding (`:916`); `unpin` and
  `revokeBinding` also delete the origin from `allowed` (`:942`, `:948`); and
  `inspect().allowedOrigins` is the effective set, static plus pinned
  (`:875-884`). So the Policy panel's mild "Remove" is the same permanent deny
  the Bindings panel labels "Block", and the Bindings "Reset" tooltip ("decided
  again on next request") is false for a controller-pinned origin. Two panels,
  two vocabularies, one mutable place. Model one origin table with per-row
  provenance (static / pinned / revoked) and actions derived from the exo's real
  effects. [proposed-rule: a design specifying per-row UI actions over a shipped
  exo must state each method's full effect, not the effect its name implies.]

- **"Hidden entirely in `strict` mode (no bindings accrue)" (Sec Layout 4) is
  wrong.** `pinAllowed` runs in the constructor and on every add regardless of
  mode, so `listBindings()` is non-empty in `strict`. Bindings are durable
  (`bindings.json`, Sec Durable policy), so switching to `strict` hides durable
  state and leaves `Revoked` rows unmanageable. Gate on `listBindings()` being
  non-empty, not on mode: visibility is complected with mode over a
  mode-independent place. [proposed-rule: UI visibility must key off the presence
  of the durable data, not off a mode that merely governs how new data accrues.]

- **Sec The persistence boundary calls `inspect()` the "live" authoritative view,
  but no refresh or subscription is specified.** It is a pull-once snapshot of a
  mutable place, re-read only after the viewer's own edits. Under `tofu-auto` a
  guest's request mutates the effective allowlist while the host's modal is open.
  `designs/endo-fetch.md` Sec Durable policy already defines
  `onPolicyChange(snapshot)`, fired after every durable mutation including a
  request-time pin, and this design consumes it only for persistence. Ask for it
  as a subscription, or specify refresh-on-expand plus an "as of" stamp, and stop
  calling a snapshot live. Value mislabelled as identity. [proposed-rule: a design
  claiming a "live" view of remote mutable state must name its refresh or
  subscription mechanism.]

- **Sec Layout 2 bakes the offerable mode set into the UI from a provisioning
  fact.** `fetch-policy-authority` is optional per service (endo-fetch Sec
  Confined plugin endowments), so a hardcoded `strict`/`tofu-auto` constant is
  wrong for exactly the services that wire one. The exo validates all four
  (`:245-250`) and cannot report enforceability, which is the gap to raise with
  endo-fetch. Open Question 2 asks the right question and answers it with the
  baked shape. Configuration complected with behavior.

- **Detection tiering inverts predicate strength (comment-only).** `client` +
  `control` is a far more generic name-shape than `fetch` + `allowedOrigins`, yet
  Sec Detection checks it first and lets it select the steering surface. Open
  Question 4's own recommendation (gate steering on a resolved `control()` whose
  `inspect()` returns a Policy-shaped record) is right; encode it in Sec Detection
  rather than leaving it in an open question.

**Notes (out of scope but worth flagging):**

- Design Decision 6's deferral of a schema-driven capability-control abstraction
  at two instances is the correct minimum-viable-abstraction call. No push.
  [rule: roles/jurors/decomplector/AGENT.md]
- The read-only tier's entire reactive-revocation path is accidental complexity
  inherited from #566 placing a non-authority-bearing fact (`isRevoked`) behind
  the control facet. An upstream nudge, not a change to this design.

Self-improvement: the decomplector brief tells the seat to read the design's
modeling decisions, and this round the three strongest findings only became
visible by reading the shipped exo the design models. A design that names a
landed capability is asserting a mapping onto real methods, and that mapping is
itself a modeling decision the seat can check. Worth adding to
`roles/jurors/decomplector/AGENT.md` Sec Operating norms: when a design's panels
map onto a shipped facet's methods, read the facet and verify that concerns the
design keeps in separate panels are actually separate in the implementation, and
that each per-row action's stated effect matches the method's real one.
