---
ts: 2026-06-09T04:17:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: researcher
dispatch_root: /home/kris/dispatches/researcher--3ab7bd
prs:
  - repo: endojs/endo-but-for-bots
    pr: 430
    role: predecessor
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4655451705
  - https://github.com/endojs/endo-but-for-bots/pull/430#issuecomment-4656037929
---

# dispatch: researcher — references for the SES pony-layer redesign (erights premise-2 / drop-the-pony)

Precedence dispatch ahead of the designer that pursues erights's
redesign, per the researcher-precedence rule (2026-06-03): every
designer and builder dispatch is preceded by a researcher whose
`## Library and project references` section the orchestrator
inlines into the downstream brief.

Maintainer authorization (kriskowal at 2026-06-09T04:15:35Z on
PR #430, issue comment `4656037929`):

> @kriscendobot Please establish a fresh PR that pursues this new
> design. Please dispatch the designer and builder serially,
> without waiting for a review or landing on the design. Instead
> of using the designs workspace, because this is based on master,
> integrate the design into a `DESIGN.md` in the affected packages.
> Run the gamut until done. Please report the PR link here.

erights's design framing (issue comment `4655451705` on PR #430,
abbreviated):

> Good observations. This suggests a further simplification. With
> the @endo/bytes change I suggest above, the pony layer is
> completely invisible. So we no longer need the pony layer that
> is coherent as a standalone pony. So instead,
> - Rename all occurrences of "pony", including in the filenames,
>   to "lib".
> - The simplification you did for freezable TypedArrays, where the
>   amplifier just returns the normal one if there is no amplified
>   one, is great. It results in the freezable TypedArray
>   pseudo-prototype methods being drop-in replacements for the
>   original TypedArray prototype methods. I would like the
>   immutable ArrayBuffer pseudo-prototype methods to have the same
>   drop-in replacement character. To achieve this, the "other"
>   methods would need to switch on whether the "this" is an
>   emulated vs genuine ArrayBuffer, and delegate to the original
>   methods if so.
> - Still have the lib layer export the pseudo-prototypes. But these
>   are no longer pseudo-prototypes. Rather, they are a record of
>   properties for the shim to copy onto the actual prototypes.
>   Therefore, no constructors or pseudo-constructors should refer
>   to these pseudo prototypes.
> - Have the shim copy these properties onto the actual prototypes.
> - Remove the pseudo-prototype from `permits.js`.

## Scope of the research

The downstream **designer** dispatch needs to author a `DESIGN.md`
that goes inside the affected package(s) (master-based, NOT under
`designs/`). The designer needs to know precisely what code today
implements the pony layer, the amplifier pattern, the
pseudo-prototypes, and the shim's prototype-installation. Your
research surfaces those pointers.

In your `project/` worktree at `endojs/endo-but-for-bots master`
(currently `4a04d078b`):

1. **Locate the pony-layer code surface.** Grep the tree for
   files and identifiers containing "pony" (case-insensitive):
   ```sh
   git grep -lI -i 'pony'
   git grep -nI -i 'pony' packages/ses/
   ```
   Enumerate filenames, key identifier names, and which directories
   they live in. The redesign renames every "pony" occurrence to
   "lib", so the rename surface is the same set.
2. **Map the amplifier pattern** for freezable TypedArrays and
   immutable ArrayBuffers. Look for:
   - `amplifyTypedArray` / `getHiddenTypedArray`
   - `virtualTypedArrayBufferGetter`
   - `hiddenTypedArrays` (the WeakMap)
   - any analogous `amplifyArrayBuffer` / `hiddenArrayBuffers` if
     they exist; if not, note the asymmetry (the redesign extends
     the pattern to ArrayBuffer).
3. **Identify pseudo-prototype shapes.** Find the pseudo-prototype
   objects (likely in files named like `freezable-typedarray.js`,
   `immutable-array-buffer.js`, or similar) and identify how they
   are currently consumed: (a) by pseudo-constructors via
   `Object.setPrototypeOf` or in `new.target` plumbing, and (b)
   by `permits.js` as intrinsic shapes the lockdown allows.
4. **Find the shim's install procedure.** The shim is the code that
   wires the pseudo-prototypes / amplifier into the live realm at
   `lockdown()` time. Locate it (likely `packages/ses/src/` —
   `lockdown.js`, `enforce-pony-permits.js` or similar). The
   redesign moves from "pseudo-prototype is the prototype" to
   "shim copies properties onto the genuine prototypes". Identify
   the function(s) that would do the copy-onto-genuine-prototype.
5. **Map `permits.js` entries** for the pony intrinsics. The
   redesign removes them. List the entry names and their nesting
   path under the `permits` tree so the designer can specify the
   deletions surgically.
6. **Check `@endo/bytes` integration touchpoints** — erights
   references a parallel `@endo/bytes` change that makes the pony
   layer "completely invisible". Check whether endo-but-for-bots
   mirrors `@endo/bytes` (probably `packages/bytes/`) and what
   surface it exposes today. The designer needs to know whether
   the `@endo/bytes` change is a prerequisite (already merged in
   master?), in flight (PR open?), or assumed-future.
7. **Check PR #430's parent context** — the no-spackle experiment
   branch (`llm`-based) implements the "amplifier returns this on
   fallthrough" simplification erights praises. Read PR #430's
   relevant commits to understand the working pattern the designer
   will translate to master. Use
   `gh pr view 430 --repo endojs/endo-but-for-bots --json
   commits` and inspect the patches that matter.
8. **Check `packages/ses/`'s existing DESIGN.md** (if any) so the
   downstream designer knows whether to author a new file or
   extend the existing one. If the package has no DESIGN.md, the
   designer creates one; if there is one, the designer extends it
   with a new section.

## Output shape

Produce a `result` entry under `journal/entries/2026/06/09/` with
the standard researcher `## Library and project references` section
the orchestrator inlines into the downstream designer brief. The
section should:

- List concrete file paths (with line numbers where helpful) for
  each of the seven points above.
- List the rename surface (every file + identifier touched by the
  pony→lib rename).
- Enumerate the `permits.js` pony entries by their permit-tree
  path.
- Name the shim-install function(s) that will gain the
  copy-properties-onto-genuine-prototypes logic.
- Note any blockers / asymmetries the designer needs to surface
  (e.g., missing `amplifyArrayBuffer`, `@endo/bytes` integration
  state, PR #430 commits to translate).

## Out of scope

- Do NOT propose the design itself; that's the next dispatch.
- Do NOT touch the tree or push anything.
- Do NOT write a DESIGN.md; the designer does.
- Do NOT speculate beyond what the code shows; flag unknowns as
  open questions for the designer.

## Authorizations

Read-only. No commits, no pushes, no comments.

## Deliverable

A `result` entry under `journal/entries/2026/06/09/` containing
the `## Library and project references` section ready for inlining,
plus the standard self-improvement footer.

End your turn with a concise summary back to the orchestrator. The
orchestrator inlines your section into the designer dispatch and
tears down your dispatch root on return.
