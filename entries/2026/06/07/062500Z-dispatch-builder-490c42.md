---
ts: 2026-06-07T06:25:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--490c42
refs:
  - entries/2026/06/07/061800Z-dispatch-researcher-a14165.md
  - entries/2026/06/07/062046Z-result-researcher-a14165.md
  - https://github.com/endojs/endo-but-for-bots/pull/417
  - https://github.com/endojs/endo-but-for-bots/pull/417#pullrequestreview-4424101026
  - https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4628329171
---

# dispatch: builder — open no-spackle PR experiment per erights's premises (authorized by kriskowal RSVP)

User directive (2026-06-07): *"RSVP
https://github.com/endojs/endo-but-for-bots/pull/417#issuecomment-4628329171"*.

The cited maintainer comment closes the authorization loop on
erights's directive in review `4424101026`: open a separate PR
experiment with six premises (verbatim below). erights is the
senior contributor on pass-style + hardened-JS per the endo project
README; kriskowal's RSVP is the authorization to act.

## erights's six premises (verbatim)

> Building on my same original commits, please start a separate PR
> experiment with the following premises:
>
> - **No spackle.**
> - Neither the immutable ArrayBuffer ponyfill nor the freezable
>   ArrayBuffer ponyfill visible outside the immutable-arraybuffer
>   package. The immutable-arraybuffer package **exports only the
>   shim**.
> - We extend the shim so it also builds on the freezable
>   TypedArray pony to replace each of the concrete global
>   constructors with the pseudo constructors built using maker
>   from the pony's exports.
> - Do not export *anything* from the immutable-arraybuffer
>   package that should remain encapsulated.
> - The shim should race to install only so that a prior apparent
>   native implementation causes the shim to not install anything.
> - Since there's no spackle and the only race is this simple, we
>   don't need new symbols.
>
> For each improvement you did in this PR, if it does not conflict
> with the above premises, apply the improvement to the new PR as
> well. Use a review comment to ask about anything you're unsure
> of.
>
> Within the immutable-arraybuffer package, keep the pony tests
> you've done in this PR. But each pony test should have a
> corresponding shim test if it makes sense.
>
> Please break the new PR experiment into separate commits as
> you've done in this PR, so it is easily reviewable
> commit-by-commit. But do not include anything in early commits
> that will be overwritten by later commits.

## Library and project references

(Inlined verbatim from researcher `a14165`'s section.)

### Library concepts and sections

- [`journal/library/sources/endo--packages-immutable-arraybuffer.md`](../../library/sources/endo--packages-immutable-arraybuffer.md): cycle 201 source page. Ponyfill+Shim architecture, six (named "seven") Caveats, WeakMap-brand-check, three-tier fallback, by-copy network + ROM-vs-RAM motivations. **Read first.**
- [`journal/library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md`](../../library/sections/endo--packages-immutable-arraybuffer--ponyfill-plus-shim-with-purposeful-violation-and-six-caveats-and-weakmap-emulated-private-field-and-intermediate-prototype-inheriting-from-arraybuffer-prototype.md): the *Ponyfill+Shim pattern* sub-section is load-bearing. erights's premise that *the immutable-arraybuffer package exports only the shim* is a refinement of the pattern, not a contradiction.
- [`journal/library/sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install.md`](../../library/sections/endo--packages-harden-make-selector-js--race-to-install-harden-at-Object-at-harden-with-three-tier-lookup-and-pin-on-first-install.md): the canonical prior race-to-install precedent. **Asymmetric with erights's premise**: harden races among several implementations and pins via non-configurable `Object[Symbol.for('harden')]`; erights wants the simpler *detect-then-skip* shape (no pin, no shared symbol, no new symbol). The harden section clarifies what's retained vs dropped.

### Project context

- [`journal/projects/endo/README.md`](../../projects/endo/README.md) § Authority structure: erights = senior on `pass-style`, `ses`, `hardened-JS`, `marshal`, `eventual-send`, `captp`, `patterns`, OCapN-family. immutable-arraybuffer sits in `pass-style` ∩ `hardened-JS`. erights's premises carry kriskowal-equivalent technical weight; kriskowal's RSVP is the authorization to act. **Treat as directive, not suggestion.**
- [`journal/projects/endo-but-for-bots/README.md`](../../projects/endo-but-for-bots/README.md): bot fork is the natural home; standing broad-comment authorization; implementations land on `master` (the experiment's base).
- [`journal/projects/endo-but-for-bots/followups/endo-but-for-bots--417.md`](../../projects/endo-but-for-bots/followups/endo-but-for-bots--417.md): names the live surfaces the experiment must exercise at shim-level: `virtualTypedArrayBufferGetter` brand-check, `PseudoTypedArrayPrototype.constructor` cycle on `new`, `setPrototypeOf(PseudoTypedArray, TypedArray)` chain.
- [`journal/entries/2026/06/04/053926Z-result-liaison-931744.md`](../../entries/2026/06/04/053926Z-result-liaison-931744.md): the second-round scope-trim verdict on #417. The current minimum spackle surface is recorded there; erights's experiment trims further (drops the remaining `@endo/bytes` ses-intrinsic installs + the eslint-plugin rule forbidding direct TextEncoder/TypedArray construction).
- [`garden/skills/frozen-base-branch/SKILL.md`](../../../garden/skills/frozen-base-branch/SKILL.md): fork-side PR base shape `<base>-<short-sha>`. The experiment opens against `master-<short-sha>`.
- [`garden/skills/gap-revealing-build/SKILL.md`](../../../garden/skills/gap-revealing-build/SKILL.md): DRAFT-stays-DRAFT discipline. The experiment does **not** trigger the cleaner / judge / fixer / un-draft chain. Body shape: name what was retained from #417, what was dropped.

### Original commits boundary on #417

| sha | author | message |
|---|---|---|
| `96e4fd4a` | Mark S. Miller | feat(immutable-arraybuffer): freezable virtual typedarrays |
| `24ac8faa` | Mark S. Miller | fixup: everything after the simple move |
| `59dfbc6d` | Mark S. Miller | fixup: partial progress |

`984b5d4d` (cleaner typo sweep) is kriscendobot's; first spackle
commit is `d334dcc0` (`feat(bytes): install spackle on intrinsics
via registered Symbol.for keys`). The experiment branches from
`59dfbc6d` (last erights commit) **or** `984b5d4d` (if the
typo-sweep is treated as a non-conflicting improvement to retain
per erights's "For each improvement" clause). Likely retain
`984b5d4d`.

The four post-cleaner fixups (`08b6bcd4`, `f6d919e3`, `0bf3dc8e`,
`2071b71e`) are candidates to cherry-pick IFF non-conflicting;
`0bf3dc8e` (`%FreezableTypedArrayPrototype%` permits annotation)
is spackle-adjacent and may need re-evaluation.

### Recommended branch name

`experiment/no-spackle-immutable-arraybuffer-417` (parallel to
`mirror/3164-freezable-typedarrays` for #417 itself).

### Open questions for the maintainer (record in PR body)

- Spackle pattern is being retired for this package per the
  experiment's premise. The eslint-plugin rule forbidding direct
  `TextEncoder`/`TextDecoder`/`TypedArray`-ctor/`ArrayBuffer`
  construction (added in #417's `7e98bef` etc.) — does the maintainer
  want that rule retained workspace-wide or only inside the
  package?
- Race-to-install is the simpler *detect-then-skip* form, not the
  harden three-tier-with-pin form. Confirm with the maintainer
  on the PR if the shape needs adjustment.
- Experiment-PR naming convention on the bot fork is not codified;
  the proposed `experiment/no-spackle-immutable-arraybuffer-417`
  branch name + analogous title is open to maintainer revision.

## State at dispatch time

- **Bot master**: `4a04d078` (in sync with upstream master).
- **PR #417 head**: `e1f4541` on branch
  `mirror/3164-freezable-typedarrays`, base `master`.
- **Last erights commit** on #417: `59dfbc6d`. **Last commit
  before spackle**: `984b5d4d` (cleaner typo sweep).
- **First spackle commit**: `d334dcc0`.

## Task

In your `project/` worktree on bot master:

1. **Add the upstream `endo-but-for-bots` source branch reference**
   (the PR #417 branch lives on the bot fork itself; just
   `git fetch origin mirror/3164-freezable-typedarrays`).
2. **Create the frozen base** off bot master:
   `git checkout -b master-<short-sha-of-4a04d07> origin/master`
   (use `git rev-parse --short=7 origin/master` to compute the
   suffix exactly). Push:
   `git push origin HEAD:master-<short-sha>`.
3. **Create the experiment head branch** from the frozen base:
   `git checkout -b experiment/no-spackle-immutable-arraybuffer-417`.
4. **Cherry-pick the original erights commits + retained
   improvements**:
   - `git cherry-pick 96e4fd4a 24ac8faa 59dfbc6d` (the three
     erights-authored commits).
   - `git cherry-pick 984b5d4d` (cleaner typo sweep, likely
     non-conflicting).
   - For each of `08b6bcd4`, `f6d919e3`, `0bf3dc8e`, `2071b71e`:
     read the commit content, decide whether it conflicts with
     the no-spackle premise, cherry-pick if not. `0bf3dc8e` is
     the riskiest — the `%FreezableTypedArrayPrototype%` permits
     annotation may be spackle-adjacent and need re-evaluation.
5. **Restructure for erights's premises** (this is where the
   experiment diverges from #417):
   - **Package exports**: edit
     `packages/immutable-arraybuffer/package.json` so the package
     exports ONLY the shim (no ponyfill exports, no freezable
     ponyfill exports). The pony stays inside the package as a
     pure implementation detail of the shim.
   - **Shim builds on pony**: edit
     `packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`
     (and/or related shim files) to extend the shim to replace
     each concrete global TypedArray constructor with pseudo
     constructors built using `maker` from the freezable
     TypedArray pony's exports.
   - **Race-to-install**: the shim's install step detects whether
     a prior native implementation is present (e.g., via a
     property-existence check on the host prototype) and no-ops
     if so. **No new symbol** for the rendezvous; just the
     property-existence detect.
   - **Drop encapsulated exports**: remove any export from the
     immutable-arraybuffer package that should remain
     encapsulated (the panel's findings on #417 may name some;
     read the followups ledger).
   - **No `@endo/bytes` spackle installs**: do NOT carry forward
     the `d334dcc0` `feat(bytes): install spackle on intrinsics
     via registered Symbol.for keys` commit or any of its
     follow-ups. The package no longer depends on the spackle
     pattern.
   - **Drop the eslint-plugin rule** that forbids direct
     `TextEncoder`/`TextDecoder`/`TypedArray`/`ArrayBuffer`
     construction (added in `7e98bef`). Surface in the PR body
     that the rule was specific to the spackle pattern and is
     dropped with the experiment; ask the maintainer whether the
     rule should be retained or workspace-wide.
6. **Tests**: keep the pony tests from #417 (within the
   immutable-arraybuffer package). For each pony test, add a
   corresponding shim test where it makes sense. The shim tests
   exercise the live-prototype behaviors named in the followups
   ledger: `virtualTypedArrayBufferGetter` brand-check on genuine
   vs emulated, `PseudoTypedArrayPrototype.constructor` cycle on
   `new`, `setPrototypeOf(PseudoTypedArray, TypedArray)` chain.
7. **Commit-by-commit reviewability**: split the work so each
   commit is reviewable in isolation, with NO commit's content
   overwritten by a later commit. Suggested sequencing:
   - First: cherry-pick the four erights+cleaner commits (no
     restructure yet).
   - Second: package-exports restructure (drop ponyfill from
     `exports`).
   - Third: shim extension to build on pony pseudo constructors.
   - Fourth: race-to-install shape.
   - Fifth: tests (pony + corresponding shim).
   - Sixth: any deferred fixups.
8. **Pre-push gates**: run `corepack yarn pre-push --summary` and
   record findings.
9. **Push** the experiment head:
   `git push origin HEAD:experiment/no-spackle-immutable-arraybuffer-417`.
10. **Open the PR DRAFT**:
    ```
    gh pr create -R endojs/endo-but-for-bots \
      --base master-<short-sha> \
      --head experiment/no-spackle-immutable-arraybuffer-417 \
      --draft \
      --title "feat(immutable-arraybuffer): no-spackle experiment (from #417's freezable-virtual-typedarrays)" \
      --body <body>
    ```
    Body should:
    - State this is the no-spackle PR experiment authorized by
      kriskowal's RSVP
      (`issuecomment-4628329171`) on erights's
      review (`4424101026`).
    - Quote the six premises verbatim.
    - Enumerate what was retained from #417 (the four
      erights+cleaner commits, plus any non-conflicting fixups
      that were cherry-picked).
    - Enumerate what was dropped to satisfy the no-spackle
      premise (the `@endo/bytes` ses-intrinsic spackle, the
      registered-symbol rendezvous, the eslint-plugin rule, etc.).
    - List the open questions for the maintainer (see Library
      and project references above).
    - Cite #417 as the source PR and `endojs/endo#3164` as the
      upstream original.

## Authorizations (per-action, forwarded by steward)

- **Push** the frozen-base branch + the experiment head branch.
- **Open the DRAFT PR**.
- **Post the draft-PR body** (`endo-but-for-bots` standing broad-
  comment authorization).
- **Post review comments** on the PR if you want maintainer input
  on the open questions during the experiment build (per erights's
  directive: *"Use a review comment to ask about anything you're
  unsure of."*).

## Out of scope

- Do NOT shepherd CI to green.
- Do NOT trigger the cleaner/judge/fixer/un-draft chain (this PR
  stays DRAFT).
- Do NOT touch any package outside `packages/immutable-arraybuffer/`
  except for the eslint-plugin rule removal and a possible
  yarn.lock regen.

## Deliverable

A `result` entry under `journal/entries/2026/06/07/` naming:

- Frozen-base branch + experiment head branch names + SHAs.
- Opened PR number + URL.
- Per-commit SHA + one-line description of each commit landed.
- The cherry-pick decisions on the four candidate fixups
  (`08b6bcd4`, `f6d919e3`, `0bf3dc8e`, `2071b71e`): kept or
  dropped, with one-line rationale.
- The restructure decisions (package exports diff, shim
  extension diff, race-to-install diff).
- Pre-push gate findings (surface, do not chase).
- A `Self-improvement: ...` line.

If you reach a question that genuinely requires maintainer input
mid-build, post the review comment per erights's directive and
record in your result.

End your turn with a concise summary back to the orchestrator. The
orchestrator tears down your dispatch root on return.
