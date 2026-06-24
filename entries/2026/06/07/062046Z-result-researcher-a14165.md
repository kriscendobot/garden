---
ts: 2026-06-07T06:20:46Z
kind: result
role: researcher
host: endolinbot
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/07/061800Z-dispatch-researcher-a14165.md
prs:
  - repo: endojs/endo-but-for-bots
    pr: 417
    role: source
---

# result: researcher refinement for the no-spackle experiment builder on #417

The proposed builder dispatch will open a separate bot-fork experiment
PR per erights's six premises in review `4424101026`, building on the
three original-erights commits (`96e4fd4a`, `24ac8faa`, `59dfbc6d` on
PR #417) and authorized by kriskowal's `@kriscendobot rsvp` reply on
`issuecomment-4628329171`. The premises are: no spackle, the ponyfills
stay encapsulated inside the immutable-arraybuffer package, the shim
also installs freezable-typedarray-pseudo-constructors via the
freezable pony's makers, nothing should-be-encapsulated is exported,
the shim races only to detect a prior native install and then does
nothing, and no new symbols (because no spackle and the race is
trivial). The refinement below grounds the builder's prompt in the
existing library coverage of the package (cycle 201's ingest) and in
the project's frozen-base / experiment-PR conventions.

```markdown
## Library and project references

### Library concepts and sections

- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../../library/sources/endo--packages-immutable-arraybuffer.md):
  cycle 201 source page for the package. The package's architecture
  in one paragraph (ponyfill + shim + README), the seven (named "six")
  Caveats, the WeakMap-as-emulated-private-field-AND-brand-check, the
  three-tier fallback, and the by-copy network protocol + ROM-vs-RAM
  motivations. Read this first to recover the package's existing
  shape before changing it.

- [`journal/library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md`](../../../library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md):
  the long-form section file. The *Ponyfill+Shim pattern* sub-section
  is load-bearing: it states the ponyfill exports brand-new functions
  (because by definition a ponyfill cannot add to `ArrayBuffer.prototype`)
  and the shim modifies the existing primordials. Erights's premise that
  *the immutable-arraybuffer package exports only the shim* is a
  refinement of this shape, not a contradiction; the pony stays inside
  the package and becomes purely an implementation detail of the shim.

- [`journal/library/sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install.md`](../../../library/sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install.md):
  the canonical prior precedent for *race-to-install at a well-known
  slot*. Note the asymmetry with erights's premise: harden races
  *among several implementations* and pins the first arrival via a
  non-configurable `Object[Symbol.for('harden')]` defineProperty;
  erights's premise is the simpler shape — *the shim races only so
  that a prior apparent native implementation causes the shim to not
  install anything*. No pin, no shared registered symbol, no new
  symbol: just detect-then-skip. The harden section is worth reading
  to see *which parts of the race-to-install discipline are being
  retained* (capture-before-scuttled module-load discipline; detect
  via property-existence check on the host prototype) and *which are
  being dropped* (no rendezvous symbol because there is no second
  rendezvous participant).

- [`journal/library/keywords.md`](../../../library/keywords.md):
  the keyword index. Confirmed entries relevant to this experiment:
  `` `transferToImmutable` ``, `` `sliceToImmutable` ``,
  `Ponyfill+Shim-full-version`, `ponyfill-vs-shim distinction with
  two-stage-rollout-discipline`, `race-to-install-harden-at-well-known-slot`,
  `encapsulated-genuine-ArrayBuffer-with-exclusive-access`,
  `zero-length-slice-as-genuine-ArrayBuffer-enforcement`. No keyword
  for *spackle*, *pseudo-constructor*, *maker from the pony's exports*,
  or *experiment-PR naming*; the absences are flagged as open
  questions below.

### Project context

- [`journal/projects/endo/README.md`](../../../projects/endo/README.md)
  § Authority structure: erights is the senior contributor on
  `pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`,
  `captp`, `patterns`, the OCapN-family protocol, and capability
  security generally. The immutable-arraybuffer package sits in the
  intersection of `pass-style` (the by-copy network protocol
  rationale) and `hardened-JS` (the not-by-itself-hardened
  disclaimer), so erights's six premises carry kriskowal-equivalent
  weight on the technical question. The authorization chain to act
  on them still flows through kriskowal — which is what
  `issuecomment-4628329171` (`@kriscendobot rsvp`) provides. The
  builder treats the six premises as directives, not suggestions.

- [`journal/projects/endo-but-for-bots/README.md`](../../../projects/endo-but-for-bots/README.md)
  § Rules of engagement: the bot fork is the natural home for a
  bot-driven experiment PR; the standing authorization on this repo
  ("you are generally authorized to post freely on
  endo-but-for-bots. It is yours.") covers commenting and PR-open
  without per-action authorization. Implementations land on
  `master`; designs land on `llm`. This experiment touches both
  source (the ponyfill, the shim) and possibly DESIGN.md, so the
  default base is `master`.

- [`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--417.md`](../../../projects/endo-but-for-bots/followups/endo-but-for-bots--417.md):
  the parked follow-ups for #417's two code-panel rounds. The
  *Post-shim-wiring second-round re-panel* item names the exact
  surfaces the experiment will need to exercise:
  `virtualTypedArrayBufferGetter`'s brand-check semantics across
  genuine vs emulated TypedArrays, `PseudoTypedArrayPrototype.constructor`
  cycle on `new`, `setPrototypeOf(PseudoTypedArray, TypedArray)`
  chain. These are the live behaviors of the freezable-virtual-
  typedarrays that the static-plumbing panel could not exercise on
  #417 and that the experiment will need shim-level tests for.

- [`journal/entries/2026/06/04/053926Z-result-liaison-931744.md`](../../931744.md-result-or-near-equivalent):
  the second-round scope-trim verdict on #417. Records what already
  came out of the spackle pattern via review `4424846301` (the
  text-codec spackle dropped to module-local capture; concatImmutables
  spackle dropped to pure JS; the brand-check spackle not needed;
  string-key rendezvous for `sliceToImmutable` / `transferToImmutable`).
  The experiment goes further: erights's premise is "no spackle"
  full stop, which means dropping the remaining `@endo/bytes` ses-
  intrinsic installs and the eslint-plugin rule that forbids direct
  TextEncoder/TextDecoder/TypedArray-ctor/ArrayBuffer construction.
  The boundary between *what `931744` already trimmed* and *what
  erights's experiment trims further* is the smallest the spackle
  has been on #417 and is therefore the right starting context to
  diff against.

- [`garden/skills/frozen-base-branch/SKILL.md`](../../../../skills/frozen-base-branch/SKILL.md):
  every fork-side PR uses a frozen base `<base>-<short-sha>`. The
  experiment branches off `master` on `endojs/endo-but-for-bots`
  (which mirrors `endojs/endo:master`) and opens against
  `master-<short-sha>`. The PR opens DRAFT and stays DRAFT pending
  maintainer review; the gamut chain does *not* follow on this
  experiment.

- [`garden/skills/gap-revealing-build/SKILL.md`](../../../../skills/gap-revealing-build/SKILL.md):
  the *probe* discipline. This experiment is not a probe (the design
  is fully specified by the six premises and erights's original
  commits), but the discipline shares one shape with this dispatch:
  the PR opens DRAFT and *no judge / cleaner / fixer / un-draft
  chain follows*. Read § *The PR stays DRAFT* and § *Open the DRAFT
  PR with the four-section body* for the body-shape discipline; this
  experiment will need an analogous body that names *what was
  retained from #417's improvements* (per erights's directive: "For
  each the improvement you did in this PR, if it does not conflict
  with the above premises, apply the improvement to the new PR as
  well") and *what was dropped to satisfy the no-spackle premise*.

### Original commits boundary on #417

Erights's directive *"building on my same original commits"* refers
to the three Mark-Miller-authored commits on PR #417:

| sha | author | message |
|---|---|---|
| `96e4fd4a` | Mark S. Miller | feat(immutable-arraybuffer): freezable virtual typedarrays |
| `24ac8faa` | Mark S. Miller | fixup: everything after the simple move |
| `59dfbc6d` | Mark S. Miller | fixup: partial progress |

`984b5d4d` (cleaner typo sweep) and onward are kriscendobot's work;
the first spackle-install commit is `d334dcc0` ("feat(bytes): install
spackle on intrinsics via registered Symbol.for keys"). The
experiment branches from `59dfbc6d` (the last erights-authored
commit) or from `984b5d4d` (if the cleaner's typo sweep is considered
a non-conflicting improvement to retain — likely yes, per erights's
"For each the improvement you did in this PR" clause). The four
post-cleaner panel-round fixups (`08b6bcd4`, `f6d919e3`, `0bf3dc8e`,
`2071b71e`) are candidates to cherry-pick *iff* they do not conflict
with the no-spackle premise; `0bf3dc8e` annotates the
`%FreezableTypedArrayPrototype%` permits slot which is spackle-
adjacent and may need re-evaluation.

### Why each reference is relevant

- The cycle-201 source and section pages: ground the package's
  existing architecture so the experiment does not accidentally
  re-invent the WeakMap-brand-check, the three-tier fallback, or
  the Purposeful-Violation toStringTag.
- harden-make-selector race-to-install section: the closest prior
  precedent for the *race* part of premise 5. The experiment will
  use a *simpler* form (no shared symbol, no pin), and reading the
  harden source clarifies which parts are being deliberately not
  carried over.
- keywords.md: confirms what is and is not already indexed; the
  absences feed the open questions below.
- endo project README authority section: justifies treating
  erights's six premises as a directive rather than a suggestion.
- endo-but-for-bots project README: confirms `master` as the right
  base and the standing authorization to open the experiment PR
  without further authorization.
- The #417 followups file: names the exact freezable-TypedArray
  surfaces the experiment must exercise at the shim level.
- The `931744` scope-trim result: pins the current minimum spackle
  surface so the diff to "no spackle" is small and reviewable.
- frozen-base-branch skill: prescribes the PR's `--base
  master-<sha>` shape.
- gap-revealing-build skill: prescribes the DRAFT-stays-DRAFT
  discipline and a body-shape analog for naming retained vs dropped
  improvements.

### Open questions (library gaps)

The following terms are load-bearing for the experiment but absent
from the library; they are noted here for the librarian / scholar to
grow the corpus on a later cycle rather than fabricated as
citations:

- **Spackle pattern.** The garden's transcript uses *spackle* as a
  term of art for the ses-side install of registered-symbol
  rendezvous keys that let downstream packages (e.g., `@endo/bytes`)
  patch intrinsics post-lockdown. No concept page, no section file,
  no keyword index entry. The `931744` result entry and the prior
  `6e66fe` result entry have the working usage; a future librarian
  cycle could mine these into a concept page once a second package
  uses the same pattern (or once erights's no-spackle experiment
  retires the pattern for this package).
- **Pseudo constructor / maker-from-pony's-exports.** Erights's
  premise 3 names a *pseudo constructor* shape built from the
  freezable-typedarray pony's exports, used to replace each
  concrete-global TypedArray constructor. The pattern echoes
  cycle-201's `ImmutableArrayBufferInternal` factory (must-not-
  escape, belt-and-suspenders-freeze) but the shim-installation
  surface is broader (all the TypedArray ctors). No prior library
  coverage; the experiment is the first instance.
- **Race-to-install-iff-not-already-installed.** Erights's premise
  5 is the *simpler* form of the race-to-install pattern (detect a
  prior native install, then no-op). The harden-make-selector
  source covers the *complex* form (three-tier lookup with pin); a
  follow-up library entry could distinguish the two shapes.
- **Experiment-PR naming convention on the bot fork.** The
  proposed dispatch will open a new PR on
  `endojs/endo-but-for-bots`; no convention exists in the library
  for how experiment PRs are titled or how their head branch is
  named. Suggest the builder use a head branch like
  `experiment/no-spackle-immutable-arraybuffer-417` (parallel to
  `mirror/3164-freezable-typedarrays` for #417 itself) and a title
  that names both the experiment-nature and the source PR (e.g.,
  `feat(immutable-arraybuffer): no-spackle experiment from #417's
  freezable-virtual-typedarrays`). The builder should ask the
  liaison on a dispatch follow-up if a stronger convention is
  preferred.
```

## Library writeback

Three writebacks applied during this engagement:

- Added one keyword shortcut to `journal/library/keywords.md`:
  `no-spackle ponyfill+shim with race-to-install-detect-only | (see source: endo--packages-immutable-arraybuffer)`.
  This is the term-of-art erights uses in the premises that future
  searchers will grep for.
- No new concept page drafted. The four terms surfaced as gaps
  (*spackle pattern*, *pseudo constructor / maker-from-pony*,
  *race-to-install-iff-not-already-installed*, *experiment-PR
  naming*) each merit a concept page eventually, but none of them
  has enough body-text material in the existing library to draft
  honestly. Each is queued in *Open questions* above for a future
  librarian or scholar cycle to grow.
- No distraction pruned on a concept page. Flat-grep for
  *ponyfill*, *spackle*, *pseudo* did not produce a misleading
  concept-page reference that needed disambiguating.

## Open questions

See the *Open questions (library gaps)* sub-section inside the
fenced refinement block above. Surfacing them twice would double-
count; the in-block list is the canonical place because the
orchestrator's inline lands there in the downstream prompt.

Self-improvement: nothing this time. The `## Library and project
references` shape held up; the absence of concept pages for
*spackle*, *pseudo-constructor*, and *experiment-PR naming* is a
library gap (caught by the in-block *Open questions* list per the
researcher role file's *Do not invent references* norm) rather than
a researcher procedural gap.
