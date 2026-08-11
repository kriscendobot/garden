---
role: designer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: kriscendobot/minion.town (branch: main)
role: designer

Follow this repo's own design conventions (`# Design: <title>`, bold
Status/Mandate/Grounded against/Companion header block, numbered sections,
mermaid diagrams). Design docs land as a **pull request against `main`**
(journal `projects/minion-town/README.md` § Rules of engagement).

## Context (maintainer's own framing, 2026-08-11 — treat as ground truth)

Minion Town is an interface for an **Endo daemon** operating as a
service provider with metered billing. The Endo daemon has a **data plane**
and a **control plane**. Today both are limited to a single instance. The
daemon holds a small **sqlite** database and a **content-addressed store**
(CAS) — the CAS could be backed by git, or by CASK, "in the fullness of
time," but is not git-backed today. The control plane is exposed via
**CapTP/OCapN** dialects and **MCP**, mostly carried over HTTP as transport.

## What this design must propose

1. **Minion Town HTTP as a git remote, per guest, addressed by a
   capability-URL.** A capability-URL is an unforgeable URL that itself
   carries the right to read, write, or read+write **references** (git refs)
   into a **partition** of the daemon's content-addressed store. Holding the
   URL *is* holding the authority — no separate credential exchange.
   **Git is the protocol, not necessarily the storage format**: design
   however much of git's wire protocol (smart HTTP / protocol v2, whatever
   is the right scope) is needed to satisfy a real `git` client doing
   `clone`/`fetch`/`push` against this remote, translating to and from the
   CAS's own representation — the CAS need not itself store git objects.
   Research and cite real prior art before inventing a wire-protocol
   implementation from scratch (see § Research, below).
2. **Weblets serve content from the daemon's CAS, which is the source of
   truth.** Caching in front of it (edge cache, CDN, whatever) is fine and
   expected; the CAS is where correctness lives, not the cache.
3. **The right to change a weblet's content is an ocap, visible in the
   guest's inventory, with a petname.** "Write access to the CAS partition
   backing weblet X" should be a first-class capability object a guest
   holds and can name via Endo's existing petname system — not a bearer
   token or config-file entry outside the ocap model. Ground this against
   Endo's actual guest-inventory/petname implementation (library-lookup +
   `endojs/endo-but-for-bots`), don't invent a parallel authorization
   concept.

## § Research — existing work on Git (do this before drafting)

The maintainer explicitly asked for this research to ground the design, not
be skipped. Investigate and cite real prior art on:

- **Implementing git's wire protocol independent of git's native object
  storage.** git-remote-helpers (the `git-remote-<transport>` executable
  protocol — arguably the most directly relevant primitive, since it lets an
  arbitrary URL scheme and arbitrary backend satisfy `git` without touching
  git's on-disk format at all); the smart HTTP protocol and protocol v2
  spec; existing implementations worth studying for their transport/storage
  separation — JGit, libgit2 (and its pluggable transport/odb backends),
  gitoxide/`gix` (Rust, explicitly layered), isomorphic-git (pure JS,
  relevant given minion.town's stack).
- **Capability-URL / bearer-URL patterns for git remotes.** How existing
  systems authorize a git-over-HTTPS remote today (GitHub App installation
  tokens as HTTP basic-auth passwords, signed/expiring URLs elsewhere in the
  ecosystem) — as a baseline to contrast against a true unforgeable
  capability-URL, which is a stronger primitive than a bearer token but
  should be evaluated against how those systems handle refresh/revocation.
- **Existing content-addressed-store-as-git-backend prior art**, if any is
  findable (git itself is content-addressed; the interesting question is
  systems that expose a *different* CAS through git's protocol, or map
  git's object model onto a non-git store).

Cite what's actually found; if a corner of this has no good prior art,
say so explicitly rather than papering over it with an invented citation
(same discipline the researcher role uses for internal citations, applied
here to external ones).

## Reconcile explicitly with the two sibling designs already landed

Two related PRs landed just before this direction was corrected — **read
both in full**, then make and justify an explicit call (supersede, narrow,
or partially reuse) rather than silently ignoring or blindly overwriting
them:

- **`kriscendobot/minion.town#39`** (`designs/git-content-substrate.md`,
  still **draft**): designed a one-way, read-only projector pulling a
  *public GitHub branch* (e.g. the garden's `journal2`) into the CAS via
  polling, with no write path and no capability/ocap authorization model —
  a materially narrower framing than this design's git-remote-as-protocol
  direction. If this design supersedes it, mark #39 **"Superseded by"** per
  this repo's own convention (a note, not a deletion) and say why. If any
  part of #39 is still reusable — its report claims the `*.ocap.site`
  wildcard-vhost / DNS-01 mechanism resolves the prior namespace/TLS
  blocker and gives any mutable-content weblet a cheap stable origin — say
  explicitly which part survives and which doesn't.
- **`kriscendobot/minion.town#40`** (`designs/vitals-weblet.md`, **open**):
  built its content-sourcing plan directly on #39's mechanism (reading
  `journal2:vitals/` via that projector). Note plainly, in this design's own
  text, that #40 will likely need a follow-up reconciliation once this
  design lands — do not silently leave a dangling assumption, but do not
  rewrite #40 yourself either; that is a separate job.

## Explicitly out of scope for this job — record, do not act

The maintainer expects this design will likely motivate **consequent
proposals for work in `endojs/endo-but-for-bots`** — creating or
reprioritizing daemon/CAS/ocap-inventory work there to support the git
remote and the weblet-write-capability model. **Name what that follow-on
work would plausibly need to be**, as a closing section of the design, but
do **not** open, file, or propose any endo-but-for-bots job yourself — that
is the maintainer's call once this design has been reviewed.

## Deliverable

A design PR against `main` on `kriscendobot/minion.town`, following the
repo's own design-doc format, with the Research section's citations, the
explicit reconciliation with #39/#40, and the endo-but-for-bots follow-on
section named above. Any open question this job cannot resolve goes in the
document's own "Open questions" section rather than being guessed past.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-11T21:03:05Z
