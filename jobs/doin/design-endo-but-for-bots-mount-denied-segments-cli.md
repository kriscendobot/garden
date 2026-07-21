# design: Mount CLI plumbing for the deniedSegments creation option

Repo: **endojs/endo-but-for-bots** — roadmap branch `llm` (open a draft
`design/<slug>` PR against `llm` per the designer default).

Origin: issue **#651** (https://github.com/endojs/endo-but-for-bots/issues/651),
promoted to design by kriskowal
(https://github.com/endojs/endo-but-for-bots/issues/651#issuecomment-5029609203).
Cite both in the design PR body.

## What to design

Expand issue #651 into a self-contained design under
`designs/<slug>.md` (suggested slug `mount-denied-segments-cli`, matching the
`design/<slug>` branch). It designs the **CLI surface** for the already-plumbed
`deniedSegments` mount creation option.

Context (from #651): PR #650 (PR A of the #127 mount-extensions reconstruction,
design `designs/mount-extensions-reconstruction.md` § "PR A — revocation and
deny patterns") added an overridable `deniedSegments` creation option that
replaces the mount's `defaultDeniedSegments` set. It is already wired through
the daemon path — `makeMount` / `makeRevocableMount`
(`packages/daemon/src/mount.js`), the `MountFormula` / `ScratchMountFormula`
records (`packages/daemon/src/types.d.ts`, included only when overridden so
default mounts keep their historical formula shape), the `mount` /
`scratch-mount` formula handlers (`packages/daemon/src/daemon.js`), and
`provideMount` / `provideScratchMount` (`packages/daemon/src/host.js`).

What is **not** yet plumbed is the CLI. This design covers adding it.

## Scope to cover in the design

- A `--denied-segments <name>` (repeatable) or comma-separated flag on the
  `endo mount` / `endo mount --scratch` CLI commands, forwarded as
  `options.deniedSegments` to `provideMount` / `provideScratchMount`.
- A way to express the **empty set** (denial disabled) distinctly from
  "omitted" (use the default) — e.g. an explicit `--no-deny` /
  `--denied-segments=` form. Design the disambiguation deliberately; note that
  the formula records deliberately omit the field when not overridden, so the
  CLI must map "omitted" → do not pass the option, and "explicit empty" → pass
  an empty set.
- CLI help text.
- A test that a mount created with a custom or empty set through the CLI
  actually enforces it.

The reconstruction design deliberately deferred this so PR A stayed scoped to
the revocation caretaker, the deny set, and the daemon-side option; this design
is the deferred follow-up.

## Notes for the designer

- Read `designs/mount-extensions-reconstruction.md` and the shipped PR #650
  first so the CLI names and semantics match the daemon-side option exactly.
- Surface any ambiguity (flag spelling, repeatable vs comma-separated, the
  empty-set form) under `## Open questions` rather than silently choosing.
- Match the project's `designs/CLAUDE.md` conventions and metadata table.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  claimed_at: 2026-07-21T02:48:32Z
