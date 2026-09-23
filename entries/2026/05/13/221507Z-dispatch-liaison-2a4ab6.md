---
ts: 2026-05-13T22:15:07Z
kind: dispatch
role: liaison
project: endo-but-for-bots
to: "*"
---

# Dispatch: designer captures "Familiar runs applications off the virtual filesystem" requirements and proposes a design

Dispatch root: `dispatches/designer--familiar-run-vfs-apps--20260513-221506--2a4ab6/`. Project worktree at `endojs/endo-but-for-bots@llm`.

The maintainer's framing (forwarded verbatim):

> I would like host agents in the Familiar to be able to run applications off the virtual file system. You will find related designs being explored for the Endor (Endo Rust) binary. We have not tried this on Node.js yet. There are two cases: I would like both hosts and guests to be able to run confined applications out of anything implementing the Endo filesystem mount interface, including readable trees, mounts, and scratch spaces. I would Endo hosts to be able to run Node.js applications by ejecting any readable filesystem interface to a scratch space and shelling out to Node.js in that environment. In the fully virtualized and confined case, we will need to be able to get dependencies out of the npm registry and into the sqlite database as a cache of modules, and be able to create ad hoc compartment maps out of these applications. In Endor I proposed reusing the Go module resolution algorithm to obviate a lockfile.
>
> For follow-up, when the work on Posix sandbox lands, it then becomes possible to allow a guest to run a Node.js application safely.

## Task

Capture these requirements as a design document on `endo-but-for-bots@llm:designs/`. Open a draft PR proposing the design.

### Concrete shape

- Sections: purpose, two cases broken out (confined / host-Node.js-eject), the fully-virtualized-and-confined sub-case (npm-to-sqlite + ad-hoc compartment maps + lockfile-obviation), Endor (Rust) cross-references, alternatives considered, recommended approach, open questions, follow-up gated on Posix sandbox.
- The two execution cases are distinct enough to deserve their own subsections; the npm/sqlite + compartment-map machinery sits under the confined case.
- Reference the Endor design work where relevant. The Endor design likely lives in `endo-but-for-bots@llm:rust/endor/` or under `designs/endor-*.md` (per PR #166 which landed the rust/endor TUI skeleton). Search both. Read whatever Endor design material the project already carries on this topic and cite specifics.
- The Go module resolution algorithm reference: name the concrete adaptation. Go's `go.mod` carries direct dependency declarations and module versions; transitive resolution is computed deterministically from the import graph + minimum-version selection (MVS) at build time, without a lockfile. The npm idiom does not currently work this way (npm relies on a lockfile). The design should describe how Endo could express dependency intent in a Go-mod-shaped form and resolve transitively at compartment-map construction time, caching modules in a sqlite-backed module store.

### Investigation steps

1. Locate the Endor design material:
   - `find project -type f -name '*.md' -path '*endor*'`
   - `find project -type d -name 'endor'`
   - `grep -l -r 'endor' project/designs/`
   - Look at PR #166's diff for the `rust/endor` skeleton.
2. Locate existing designs on filesystem-mount, readable-tree, scratch-space, compartment-map concepts:
   - `grep -l -r 'mount\|readable.tree\|scratch.space\|compartment.map' project/designs/`
   - Read each to understand the existing vocabulary.
3. Sketch the design from those primitives.

### Production discipline

- Identity kriscendobot. Per `pr-creation-flow`: open the PR in **draft**.
- Slug for the design file: pick a clear one (e.g. `familiar-run-apps-vfs.md`, `host-run-confined-apps.md`, or `familiar-app-execution.md`). The designer picks.
- Title for the PR: conventional-commits, e.g. `design: familiar runs confined and host-Node.js apps off the virtual filesystem`.
- Body cites the maintainer's directive verbatim (you have authorization to post freely on endo-but-for-bots; the standing authorization in `journal/README.md` § Pre-staged authorizations covers this).
- Body lists alternatives considered + the recommended approach in two sentences each; longer detail lives in the design file itself.

## Out of scope

- No implementation. Design-only.
- No edits to Lal, Familiar, or rust/endor source. Read-only on those.
- No CI watching.
- Do not file anything upstream on Endor (Rust) repos if they are separate.

## Report

PR URL, design file path, alternatives considered (one sentence each), recommended approach (one paragraph), open questions to surface to the maintainer.
