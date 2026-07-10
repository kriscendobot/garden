# Design: Endo content locators (magnet URNs) for readable blobs and trees

Project: **endojs/endo-but-for-bots**, roadmap branch **`llm`** (design-stage draft
PR against `llm` per `roles/designer/AGENT.md` § Operating norms).

Originating maintainer directive (kriskowal) on kriskowal/garden#34 — treat the
quoted directive as the design prompt to expand:

> Propose an extension to the Endo agent interface and implementations that would
> introduce support for obtaining a **magnet URL** for the named, identified, or
> located **readable-blob or readable-tree**. In the way the presentation of an
> Endo *locator* may have connection hints that depend on the configuration of the
> agent, an Endo **content locator (magnet URN)** may have connection hints that
> depend on configuration. Consider the analogue of `@nets` for an agent's content
> locators. We already support in-band transfer mechanisms for copying or
> snapshotting blobs and trees over CapTP. **Content locators** would be for
> transferring content on one or more **data planes** including HTTP, Git over
> HTTP, BitTorrent, or others; approach each of these back-planes as individual,
> incremental designs, extending the supported resource-location hints. It would,
> for example, be the responsibility of a **Gateway** to present a capability to
> share data over a Git or HTTP back-plane, as the Gateway would be the online
> service that can vend a reachable socket.

## Scope for this design

- Expand the directive into a single self-contained `designs/<slug>.md` in the
  project, implementable by a later builder. Suggested slug:
  `endo-content-locators-magnet-urn` (match the anticipated branch/PR slug).
- **Design the interface layer, not every back-plane at once.** Define the agent
  interface extension for obtaining a content locator (magnet URN) for a named /
  identified / located readable blob or readable tree, and the shape of the
  configuration-dependent **connection/resource-location hints** carried in that
  URN — explicitly modelled as the content analogue of how an Endo *locator*
  carries connection hints, and the `@nets` analogue for content (call it out by
  name; look up how `@nets` supplies connection hints today before drafting).
- Treat each **data plane** (HTTP, Git-over-HTTP, BitTorrent, …) as an
  **incremental, individually-designed back-plane** extending the hint vocabulary.
  This design establishes the extensible hint framework and works ONE back-plane
  through as the worked example (recommend which, and say why); leave the others as
  named follow-up designs ("to be filed"), not inline full specs.
- Situate the **Gateway** as the online service that vends a reachable socket and
  presents the capability to share data over a Git or HTTP back-plane — i.e. where
  the configuration-dependent hints come from.
- Relate to the **existing in-band CapTP** copy/snapshot transfer for blobs/trees:
  content locators are the *out-of-band* / cross-data-plane complement, not a
  replacement. Make the boundary explicit.

Use the [library-lookup] skill first: look up `@nets`, "locator", "connection
hints", readable-blob / readable-tree, Gateway, and magnet/URN prior art in the
Endo corpus so the design names things the way the existing corpus already names
them. Put every design question you cannot resolve into `## Open questions` for the
maintainer rather than picking.

Per the designer default for this project: commit the design file on a
`design/<slug>` branch in the bot fork and open a **DRAFT** PR against `llm`, with
the PR body citing the originating issue comment below. This repo carries the
standing comment/cross-link authorization (`journal/projects/endo-but-for-bots/README.md`
§ Standing authorizations), so cross-linking the issue is permitted.

After the draft PR is open, **reply on the originating issue thread** (comment on
the issue URL below) linking the draft PR so kriskowal can review. Do **not** close
the issue — the submitter does that.

----- ISSUE NOTE (copy this block VERBATIM into every follow-on job) -----
issue_spine: issue-kriskowal-garden-34
issue_url: https://github.com/kriskowal/garden/issues/34#issuecomment-4932224277
submitter: kriskowal
----- END ISSUE NOTE -----
