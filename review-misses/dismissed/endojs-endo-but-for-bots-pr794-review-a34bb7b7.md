---
kind: review-miss-dismissed
primary_job: endojs-endo-but-for-bots-pr794-review-a34bb7b7
verdict: not-a-miss
category: new-direction
pr: 794
repo: endojs/endo-but-for-bots
comment_url: https://github.com/endojs/endo-but-for-bots/pull/794#pullrequestreview-4729356746
identity: endojs/endo-but-for-bots#794:review:4729356746:retro
producing_role: designer-then-review-follow-up
severity: minor
grounds: >
  PR #794 is a DESIGN-DOCUMENT PR (title "design(ocapn-noise): key-only session
  boundary"; the only touched artifact is designs/ocapn-noise-key-only-session-boundary.md
  plus its designs/README.md summary rows; base llm, now MERGED). kriskowal (the
  repo owner and maintainer) submitted review 4729356746 in state COMMENTED. Its
  body and two inline comments are pure ARCHITECTURAL DIRECTION on his own novel
  design: (1) prototype the system in Node but prepare to replace the data plane
  with Rust plus a bespoke CBOR controller protocol later adapted to Exo
  interfaces on the JS facade, structured as a parallel Rust-crate / JS-package
  pair; and (2) the relay/mux should be "dumb" — it sniffs only the plaintext
  responder public key and routes the untouched ciphertext toward the true OCapN
  listener (e.g. over a unix domain socket), never terminating Noise nor
  depending on it. This retro judges whether the garden REVIEW PROCESS should
  have anticipated this feedback and concludes it could not have, for a
  dispositive structural reason. These are first-stated requirements — the
  maintainer's own design taste and scope for a not-yet-built protocol boundary
  (dumb ciphertext relay vs Noise-terminating gateway; Rust data plane; CBOR
  controller schema; the JS/Rust seam placement). No garden review surface
  encodes an opinion on the correct session-boundary topology of OCapN-over-Noise,
  the choice of Rust for a future data plane, or a bespoke CBOR controller
  protocol; no seat brief, panel-hints probe, pre-push gate, or COMMON.md norm
  governs the architecture of an unimplemented design. There was correctly NO
  code panel/gauntlet on this PR — the panel is a code-review surface and #794
  ships a document, not code, so no "panel should have run" process miss applies
  either. This is the same class as prior maintainer design-direction dismissals:
  a maintainer refining the direction of his own design, unanticipatable by
  definition. The PR history confirms the garden acted correctly: the primary
  job (pr794-review-a34bb7b7) reframed the design to a dumb Noise-free relay plus
  a terminating listener, added the "Prototype in Node, Replace the Data Plane in
  Rust" section citing the existing rust/ocapn_noise <-> @endo/ocapn-noise
  precedent, resolved both Open Questions, and replied inline with SHA citations —
  exactly the requested direction, and the PR subsequently merged. Recorded as a
  durable dismissal so the same review is never re-litigated. No cluster minted;
  no improvement dispatched.
---

# Dismissal: endo-but-for-bots #794 review 4729356746 (retro)

PR #794 is a design-document PR (design(ocapn-noise): key-only session boundary).
kriskowal, the repo owner, left a COMMENTED review giving architectural direction
on his own design: prototype in Node but plan a Rust data plane with a bespoke
CBOR controller protocol later adapted to Exo (a parallel Rust-crate / JS-package
pair), and make the relay/mux "dumb" — sniff only the plaintext responder public
key and route the untouched ciphertext to the true OCapN listener rather than
terminate Noise.

Not a garden review-process miss. This is new direction: first-stated
requirements expressing the maintainer's taste and scope for an unbuilt protocol
boundary. No seat brief, probe, gate, or standing norm encodes the correct
OCapN-over-Noise session-boundary topology, the choice of Rust for a future data
plane, or a CBOR controller schema — nothing a review surface could have caught
ahead of the maintainer. Correctly no code panel ran (a design document is not
code). The primary job (pr794-review-a34bb7b7) adopted the dumb Noise-free relay,
added the Node-prototype/Rust-data-plane section, resolved both Open Questions,
and the PR merged. Same class as prior maintainer design-direction dismissals.
See comment_url for the verbatim review.
