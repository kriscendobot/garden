---
role: designer
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-12T16:49:05Z -->

---
role: designer
---

# Design: `@endo/inspect` package + `@endo/inspect/shim.js` (SES-base console inspector)

**Repo:** `endojs/endo-but-for-bots`, design PR against **`llm`** (endo-but-for-bots
designs land as PRs on `llm`). **This is the DESIGN step of a serial orchestration**
(`orch-endo-inspect`): design -> conduct-to-llm -> build.

**Provenance / authority:** maintainer directive (kriskowal) on
<https://github.com/endojs/endo-but-for-bots/pull/187#issuecomment-4951950042>
(PR #187, "render Error reasons in CapTP rejection diagnostics", now MERGED). This
design is the requested follow-up.

## What to design (the maintainer's spec, verbatim intent)

Produce an **`@endo/inspect`** package and **`@endo/inspect/shim.js`** such that:

1. **The shim can be incorporated in the base of SES** and **parameterized for the
   target environment via the `-C` condition** (package.json export *conditions*).
   Design the conditional-exports shape so SES's base pulls the right inspector.
2. **Per-environment behavior:**
   - **`browser`** — the console is rich; use it.
   - **`node`** — **VT-100** when the output is a **tty**, **bare text** otherwise.
   - **`xs`** — the console **does not exist**; degrade accordingly.
3. **The inspector must carefully avoid triggering behaviors of the logged objects**
   — inspecting a value must not invoke getters/proxies/side effects. This is the
   crux: **on SES as written this cannot be done faithfully, because there is no
   `Proxy` brand check** (you cannot reliably tell a Proxy from a non-Proxy without
   tripping its traps). The design must confront this head-on and propose how far
   faithful non-triggering inspection can go, and where it cannot.
4. **Research existing concerns about `Proxy` in SES** and **surface the existing
   issues regarding proxy stamping as an explicit dependency** of this design (cite
   the issue/PR numbers, fully-qualified `owner/repo#N`). The lack of a Proxy brand
   check is a hard dependency the maintainer wants tracked.

## Required on the design PR

- **Tag `@erights` and `@mhofman`** on the design PR for assistance — this is the ONE
  externally-visible mention, and it is **explicitly authorized by the maintainer's
  comment above** (external-repo etiquette: the per-action authorization is the
  maintainer directive; do no other upstream commenting/mentions beyond this design
  PR and its `@erights`/`@mhofman` tag).
- Follow the endo-but-for-bots design-doc conventions; fully-qualify every issue/PR
  reference; use ASCII in prose per the typist-friendly-code-points house style.

## Skills
- [design-to-pr-pipeline](../../skills/design-to-pr-pipeline/SKILL.md),
  [design-dependency-walk](../../skills/design-dependency-walk/SKILL.md),
  [library-lookup](../../skills/library-lookup/SKILL.md) (SES / Proxy / hardened-JS
  terms), [pr-formation](../../skills/pr-formation/SKILL.md),
  [em-dash-style](../../skills/em-dash-style/SKILL.md),
  [no-latin-shorthand](../../skills/no-latin-shorthand/SKILL.md),
  [self-improvement](../../skills/self-improvement/SKILL.md).

## Done
A design PR on `endojs/endo-but-for-bots` (base `llm`) specifying `@endo/inspect` +
`shim.js`: the SES-base incorporation and `-C` conditional-exports shape, the
browser/node(tty vs bare)/xs behavior matrix, the non-triggering-inspection approach
and its honest limits under SES's missing Proxy brand check, and the Proxy-stamping
issues surfaced as fully-qualified dependencies. `@erights` and `@mhofman` are tagged.
The `tada` report gives the design PR number and the key open questions for the build.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 9
  claimed_at: 2026-07-12T16:49:10Z
