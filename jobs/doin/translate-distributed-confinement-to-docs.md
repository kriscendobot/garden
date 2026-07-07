role: builder

Translate Mark Miller's article "Distributed Confinement" into documentation for docs.endojs.org.
This is a DOCUMENTATION translation (author the translated page + open a PR), not a
code feature — no changeset/test scaffolding beyond what the docs site build requires.

## Source
Locate the AUTHORITATIVE version of Mark Miller's "Distributed Confinement" (Mark Miller's Distributed Confinement writeup, most likely on erights.org). Fetch it with
scripts/jobs/fetch-source.sh <url> (do NOT hand-roll the fetch — it handles the
erights.org connection refusals via the erights.github.io mirror and the Internet
Archive fallback, and records provenance). If you cannot confidently identify the
authoritative source, STOP and surface it to the maintainer rather than translating the
wrong text.

## Venue & mechanism
- Land the translated doc in Endo's `docs/` directory (routing to docs.endojs.org),
  respecting Endo's existing docs tooling / site generator and navigation.
- Propose it as a PR on the `endojs/endo-but-for-bots` fork, based on `master`. Do
  NOT ferry upstream to endojs/endo; the fork PR is the deliverable.

## Translation conventions (consistent with design-endo-thesis-translation)
- Swap the **E language** for the **Jessie subset of Hardened JavaScript**: translate E
  code examples and E-specific constructs (eventual sends, when-catch, makers, facets,
  sealer/unsealer pairs, …) into Jessie / Hardened JavaScript idioms.
- Swap **CapTP** for **OCapN**.
- Keep Miller's prose and argument FAITHFUL; modernize only code, protocol names, and
  dead links, and visibly flag each substitution to the reader.
- If design-endo-thesis-translation has landed a conventions/structure decision, align
  with it; otherwise proceed and note where you made a judgment call.

## Provenance, attribution, licensing
Attribute to Mark Miller and cite the source. The thesis/articles are his copyrighted
work — do NOT assume a license; surface attribution/permission as a maintainer decision
in the PR description and, if warranted, to the maintainer inbox.

Open the PR (draft is fine) and report its URL. Work on the endo-but-for-bots fork only.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 16
  claimed_at: 2026-07-07T22:30:42Z
