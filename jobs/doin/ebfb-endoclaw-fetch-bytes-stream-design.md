---
role: designer
---

role: designer
---

# Design: binary media on the Endo fetch surface (`bytes()` / `stream()`)

Repo: endojs/endo-but-for-bots (base branch `llm`).

Plan the addition of a `bytes()` accessor on `FetchResponse` and a
bytes/stream upload body on `FetchOptions`, so OAuth domain connectors
can move binary media in both directions (Drive file download, Gmail raw
attachments outside JSON). Today `FetchResponse` exposes `text()` and
`json()` only and `FetchOptions.body` is `string` only — the gap noted
and deferred in `designs/endoclaw-oauth.md` (Capability Shape section)
and owned by `designs/endoclaw-network-fetch.md`.

Gate the design on progress on **passable byte arrays** in Endo: the
response/stream shapes should be expressed in terms of passable byte
arrays once those land, rather than inventing a bespoke transfer type.
Call out the dependency explicitly and, if passable byte arrays are not
yet available, propose the interim shape and the migration path.

Deliverable: a design doc (new or an update to endoclaw-network-fetch)
covering the `bytes()`/`stream()` surface, the passable-byte-array
dependency and gate, and how connectors consume it. Additive, breaks
nothing.

Origin: maintainer review directive on endojs/endo-but-for-bots#621
(inline comment 3560153009). Filed by a gardener resolving that review.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 6
  claimed_at: 2026-07-10T16:04:11Z
