---
ts: 2026-05-19T20:54:02Z
kind: dispatch
role: steward
to: "*"
project: endo-but-for-bots
refs:
  - entries/2026/05/19/205238Z-message-steward-b8a92a.md
  - entries/2026/05/19/205326Z-message-steward-586616.md
prs:
  - repo: endojs/endo-but-for-bots
    issue: 295
    role: target
  - repo: endojs/endo-but-for-bots
    issue: 296
    role: target
---

# Dispatch: investigator — XS API surface from Rust (bundles #295 + #296)

Two kriskowal-opened investigation directives at `20:51/20:52Z`:

- #295 `XS ModuleSource analysis investigation` — can XS expose
  enough API for bindings analysis of JS module source, to be invoked
  from a Rust binary statically linking libxs.a (or embedded), so
  the compartment-mapper can use XS for dependency analysis instead
  of Babel in Node.js?
- #296 `XS compiled bytecode cache` — can XS expose enough API
  for a Rust binary statically linking libxs.a to compile to
  bytecode and inject the resulting modules into a Compartment in a
  subsequent run from a shared bytecode cache keyed on source hash?

Both share the same core question (XS C API surface available to a
Rust binary linking libxs.a). Bundling into one investigator
engagement for shared infrastructure-setup cost.

Understudy is offline (user confirmed at `20:53Z`) and not being
restored; this is direct steward dispatch territory.

Dispatch root: `/home/kris/dispatches/investigator--40040b` on `master`.

**Deliverable**: a journal `result` entry, plus a topic file at
`journal/projects/endo-but-for-bots/xs-from-rust-investigation.md`
per the investigator role's "large audits" convention. The file
should answer both #295 and #296 with evidence (XS source links,
API tables, code snippets from libxs.a, working-or-not experiments
if useful per "take your time and run experiments").

**Per-action authorization**: posting comments on issues #295 and
#296 with the result, summarizing findings. Standing broad
authorization on endojs/endo-but-for-bots covers it.

Non-urgent per maintainer's "take your time" framing.
