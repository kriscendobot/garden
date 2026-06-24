---
ts: 2026-05-13T22:22:52Z
kind: result
role: designer
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 241
    role: target
    title: "design: familiar/host run applications over a VFS (mount caps, npm-to-sqlite, Go-mod-shaped resolution)"
---

# Result: designer drafted `familiar-run-apps-vfs.md`

Draft PR open: https://github.com/endojs/endo-but-for-bots/pull/241 against `llm`, on topic branch `design/familiar-run-vfs-apps`.

Design file: `designs/familiar-run-apps-vfs.md`. README updated: new summary-table row, milestone-1 table row, per-design-estimates row (L, 2-3 weeks), and *See also* lead-in.

Scope covered:

- **Case 1 (confined):** hosts and guests run applications under `endor` out of a `Mount`-cap set. The fully-virtualized sub-case replaces `node_modules` with a sqlite-backed module store (reusing `endor-npm-registry-proxy`'s registry table and `daemon-cas-management`'s CAS), and builds the compartment map ad hoc per run via Go-style transitive resolution: direct deps in `package.json`, transitives computed at compartment-map construction time, minimum-version selection per `(name, major)`. No lockfile required by default; an optional `endor lock` command is named as a follow-up.
- **Case 2 (host-eject):** the host ejects a readable tree to a scratch mount and shells out to `node` for applications needing the full Node.js API surface. Smaller scope; uses Familiar's bundled Node binary.
- **Endor cross-references:** named alignment with the Rust-side `endor-run-expanded` Form 3 and `endor-npm-registry-proxy` MVS; named divergence on case 2 (Rust side does not shell out to Node).
- **Posix-sandbox follow-up:** brief subsection naming the dependency on `endo-posix-sandbox` for extending case 2's host-eject path to guests; no full guest-side flow.

Recommended approach (one paragraph): land case 1 first (sqlite-backed module store + Go-style resolver behind the existing `endor run entry.js` form-3 entry point) so the daemon's manager JS, the CLI, and any guest with an appropriate caplet can run confined applications out of a mount set today; land case 2 second (host-eject) gated on a per-formula opt-in (`type: 'host-node-app'` or similar) so the maintainer can audit each application that elects host-Node execution; let the Posix-sandbox follow-up retire case 2's ad-hoc confinement once the sandbox is available on the deployment target.

Alternatives considered (one sentence each):

- Continue requiring `node_modules` on disk for all unconfined runs (rejected: defeats case-1 confinement and forces every Familiar deployment to ship or build a real `node_modules` tree).
- Materialise a `node_modules` tree from CAS lazily into a scratch mount and run XS against it without Go-style resolution (rejected: keeps directory-walking resolution and creates per-run hash-collision management).
- Use npm's maximal version selection instead of MVS (rejected: aggressive, pulls in untested versions, conflicts with Endo's predictability bent).
- Author an explicit lockfile (`endor.lock`) and require it for every run (rejected for default: a lockfile is useful for reproducibility but adds operational burden; offered as a follow-up `endor lock` command).
- Run case 2 inside the Posix sandbox today instead of in a scratch directory (rejected: gated on the Posix sandbox shipping on the host platform; listed as the case-2 follow-up).

Open questions surfaced to the maintainer:

1. **New manifest vs. extension of `compartment-map.json`** for the Go-mod analogue (introduce an `endo.mod` or extend the compartment map's schema with a `dependencies` block).
2. **Module-store sharing across daemons** (per-daemon `{statePath}/registry.sqlite` vs. system-wide cache shared across users).
3. **Cross-major-version compartment hosting in case 2** (does host-eject accept multi-major resolution like the compartment map, or single-major per package as Node's native resolver requires).
4. **`peerDependencies` and `optionalDependencies` policy in MVS.** Suggested: peers are direct-deps that must be provided by the entry package; optionals are best-effort and silent on failure.
5. **Eject equality:** content hash only vs. also by mount-formula identity (cheaper for `readable-tree`-backed mounts but may miss cases where two distinct readable-tree formulas point at the same content).

The design follows the project's metadata-table conventions and is ~5 screens (above the 1-3-screen role-norm target). Two distinct cases plus a glossary and cross-references warranted the length; if the maintainer prefers a tighter cut, case 2 could split into its own sibling design (e.g., `host-eject-to-node.md`) and this file shrinks to the confined path. That split is straightforward and called out as an alternative the editorial pass could take.

Self-improvement: nothing this time.
