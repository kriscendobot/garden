---
ts: 2026-06-13T06:09:00Z
kind: result
role: investigator
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
worktree: dispatches/investigator--1d8bb6/project
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/438
refs:
  - entries/2026/06/12/052621Z-result-builder-4ef77c.md
---

Isolated the tsgo Go-runtime panic on `yarn typecheck-all` from PR #438. Root cause is an unbounded slice access in `getParameterNameAtPosition` (relater.go:1935) when comparing two signatures, one of which spreads a non-trivial tuple as its rest parameter. The bug is present in every published `@typescript/native-preview` build from the earliest available (`7.0.0-dev.20250522.2`) through today's `7.0.0-dev.20260612.1`. No prior version of tsgo escapes it. JavaScript-runtime `tsc` (the 6.0.3 catalog pin) handles the same input cleanly.

## Minimal reproduction

Two lines. No imports, no @endo packages, no third-party type machinery.

```ts
declare const fn: (...args: [bigint, ...string[]]) => boolean;
const a: (n: bigint, x: string, y: boolean) => boolean = fn;
```

Run with any tsgo since 2025-05-22 and any tsconfig that includes the file. The compiler panics during diagnostic emission rather than emitting `TS2322`.

Reproduction shell:

```sh
mkdir -p /tmp/tsgo-repro && cd /tmp/tsgo-repro
cat > tsconfig.json << 'EOF'
{ "compilerOptions": { "target": "esnext", "module": "NodeNext",
    "moduleResolution": "NodeNext", "noEmit": true, "types": [] },
  "include": ["./*.ts"] }
EOF
cat > repro.ts << 'EOF'
declare const fn: (...args: [bigint, ...string[]]) => boolean;
const a: (n: bigint, x: string, y: boolean) => boolean = fn;
EOF
npm init -y >/dev/null
npm install --no-save @typescript/native-preview@7.0.0-dev.20260611.2
./node_modules/.bin/tsgo -p tsconfig.json
```

## Panic stack (verbatim, line numbers from `7.0.0-dev.20260611.2`)

```
panic: runtime error: index out of range [2] with length 2 [recovered, repanicked]

goroutine 9502 [running]:
sync.(*WaitGroup).Go.func1.1()
	sync/waitgroup.go:251 +0x45
panic({0xe9b1e0?, 0x26068c749080?})
	runtime/panic.go:860 +0x13a
github.com/microsoft/typescript-go/internal/checker.(*Checker).getParameterNameAtPosition(0x26069b8e8c08, 0x2606a4e78300?, 0x2)
	github.com/microsoft/typescript-go/internal/checker/relater.go:1935 +0x11c
github.com/microsoft/typescript-go/internal/checker.(*Checker).compareSignaturesRelated(0x26069b8e8c08, 0x2606a49bed80, 0x2606a4e78300, 0x0, 0x1, 0x26069a9fead8, 0x2606a2ba0768, 0x260691542048)
	github.com/microsoft/typescript-go/internal/checker/relater.go:1580 +0xd49
github.com/microsoft/typescript-go/internal/checker.(*Relater).signatureRelatedTo(...)
github.com/microsoft/typescript-go/internal/checker.(*Relater).signaturesRelatedTo(...)
github.com/microsoft/typescript-go/internal/checker.(*Relater).structuredTypeRelatedToWorker(...)
github.com/microsoft/typescript-go/internal/checker.(*Relater).recursiveTypeRelatedTo(...)
github.com/microsoft/typescript-go/internal/checker.(*Relater).isRelatedToEx(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).checkTypeRelatedToEx(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).checkTypeRelatedToAndOptionallyElaborate(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).isSignatureApplicable(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).reportCallResolutionErrors(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).resolveCall(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).resolveCallExpression(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).resolveSignature(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).getResolvedSignature(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).checkCallExpression(...)
github.com/microsoft/typescript-go/internal/checker.(*Checker).checkExpressionWorker(...)
[...] checkExpressionStatement -> checkSourceFile -> getDiagnostics
sync.(*WaitGroup).Go.func1()
	sync/waitgroup.go:258 +0x4a
```

Full stack saved at `/tmp/panic.log` in the dispatch root (not committed).

## Bisect path: from `typecheck-all` to two lines

The brief's pre-condition was a panic on `yarn typecheck-all` (the unified compilation over `tsconfig.json`). Narrowing steps, each verified by running the candidate input through tsgo:

1. **Package-level isolation.** `yarn typecheck-packages` (per-workspace `lint:types`) revealed `@endo/exo` as the sole panicking package; every other workspace either passes or emits ordinary diagnostics. The 39-package error cascade documented in the builder's result (`harden`-cascade root) is a separate strict-mode JSDoc story and is unrelated to the panic.
2. **File-level isolation inside `@endo/exo`.** Running tsgo against each file in `packages/exo/{,src/,test/}` with `--ignoreConfig` and a synthetic command-line config narrows the panic to `test/types-advanced.test-d.ts`. Every other file in the package (including the 513-line `src/exo-tools.js`) compiles without panicking even when its full transitive import graph is loaded.
3. **Section-level isolation inside `test/types-advanced.test-d.ts`.** Truncating the file at 10-line increments narrows the trigger to the block on lines 64-72: the `.rest()` negative test that asserts `expectType<(n: bigint, goodRest: string, badRest: boolean) => boolean>(null as unknown as Fn)` where `Fn = TypeFromMethodGuard<typeof mg>` and `mg = M.call(M.nat()).rest(M.string()).returns(M.boolean())`.
4. **Strip the @endo dependency.** Replacing `TypeFromMethodGuard<typeof mg>` with a synthetic generic type that reproduces the same shape (variadic spread of a tuple containing a rest element) still panics. The @endo type machinery is irrelevant; only the resulting function-type shape matters.
5. **Strip the generic.** Inlining the result of the type-level computation as a literal type annotation still panics. Generics are irrelevant; only the literal function shape matters.
6. **Strip everything around the assignment.** Two declarations, no imports, no surrounding context, panic preserved. This is the canonical minimal repro shown above.

## Trigger condition

The panic fires when the structural-comparison path inside `compareSignaturesRelated` walks parameters by index and the source signature satisfies all of:

- It has a rest parameter whose type is a **tuple** type (not a plain array type),
- That tuple has **at least one fixed leading element followed by a spread** (shape `[T, ...U[]]` or `[T0, T1, ..., ...Un[]]`),
- The comparison **walks past the tuple's fixed leading elements** (the target signature has higher arity than the leading-element count plus one for the rest spread itself),
- The walk reaches a position whose **types are incompatible** so the error-reporting branch runs.

Confirmed via the following variants on the minimal repro:

| Source signature                                  | Target signature                                                      | Result          |
| ------------------------------------------------- | --------------------------------------------------------------------- | --------------- |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, x: string, y: boolean) => boolean`                       | PANIC           |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, x: boolean, y: string) => boolean`                       | clean `TS2322`  |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, x: string, y: string, z: boolean) => boolean`            | PANIC (index 3) |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, x: string, y: string) => boolean`                        | clean (no err)  |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, x: boolean) => boolean`                                  | clean `TS2322`  |
| `(...args: [bigint, ...string[]]) => boolean`     | `(n: bigint, goodRest: string) => boolean`                            | clean (no err)  |
| `(n: bigint, ...args: string[]) => boolean`       | `(n: bigint, x: string, y: boolean) => boolean`                       | clean `TS2322`  |
| `(...args: [...string[]]) => boolean`             | `(x: string, y: boolean) => boolean`                                  | clean `TS2322`  |

The panic message is `index out of range [N] with length L`, where `L = (count of fixed leading elements) + 1` (the +1 is the trailing spread element of the tuple) and `N = target_arity - (signature.parameters.length - 1)`. This is consistent with the bug being at `restType.TargetTupleType().elementInfos[index]` where `index` is allowed to exceed the tuple's own element count.

## Hypothesis: root cause

Source code link (current HEAD `c78d39e7075b4fc641b12b1f35d905c54cdc13ef`):
https://github.com/microsoft/typescript-go/blob/c78d39e7075b4fc641b12b1f35d905c54cdc13ef/internal/checker/relater.go#L1926-L1938

```go
func (c *Checker) getParameterNameAtPosition(signature *Signature, pos int) string {
    paramCount := len(signature.parameters) - core.IfElse(signatureHasRestParameter(signature), 1, 0)
    if pos < paramCount {
        return signature.parameters[pos].Name
    }
    restParameter := signature.parameters[paramCount]
    restType := c.getTypeOfSymbol(restParameter)
    if isTupleType(restType) {
        index := pos - paramCount
        return c.getTupleElementLabel(restType.TargetTupleType().elementInfos[index], restParameter, index)
    }
    return restParameter.Name
}
```

When the rest parameter's type is a tuple like `[bigint, ...string[]]`, `restType.TargetTupleType().elementInfos` has length 2 (one entry per syntactic element: the fixed `bigint`, and one for the rest spread `...string[]`). The function is called from `compareSignaturesRelated` (relater.go:1580) at a loop index `i` that ranges over the **target**'s parameter list. When the target has arity 3, `i = 2` arrives, `paramCount = 0`, `index = 2`, and the slice access `elementInfos[2]` panics.

The JavaScript reference implementation in `microsoft/TypeScript/src/compiler/checker.ts` (function `getParameterNameAtPosition`, around line 38418 of `main`) has the same logic structure:

```ts
const tupleType = (restType as TypeReference).target as TupleType;
const index = pos - paramCount;
const associatedName = tupleType.labeledElementDeclarations?.[index];
const elementFlags = tupleType.elementFlags[index];
return getTupleElementLabel(associatedName, index, elementFlags, restParameter);
```

JavaScript array out-of-bounds access returns `undefined` rather than panicking. `getTupleElementLabel` is then called with `associatedName = undefined` and `elementFlags = undefined`, and the function's `undefined`-guard branch produces a synthesized name like `${restSymbol.escapedName}_${index}`. The JS-runtime result is a degraded-but-correct parameter name in the error diagnostic; the Go-runtime result is a process panic that takes down the compilation.

The fix surface in the Go code, in order of increasing invasiveness:

1. **Minimal fix.** Clamp `index` to `min(index, len(elementInfos) - 1)` before the slice access, so positions past the tuple's spread element re-use the spread element's `elementInfo`. This mirrors the semantic JS produces (the spread element's flags carry through).
2. **Faithful port.** Use a bounds-checking helper that returns a zero `TupleElementInfo` when out of bounds, then push the `nil`-handling into `getTupleElementLabel` so the labeledDeclaration / elementFlags story matches the JS reference's `undefined`-tolerant path.
3. **Structural fix.** Audit `compareSignaturesRelated` and `signaturesRelatedTo` for other places where a target-arity-driven loop indexes into source-side per-parameter structures; the same shape probably exists in nearby code (`getParameterIdentifierInfoAtPosition` at relater.go:38435 in the JS version has the same pattern and is a strong candidate).

The minimal fix is sufficient to clear the user-visible panic on the endo workload. The structural audit is recommended for a follow-up because tuple-rest signatures are common in variadic-tuple-typed code (parameter pack utilities, builder patterns, currying libraries).

## Severity

**Bug, high.** Severity rationale:

- Tsgo aborts the whole compilation instead of emitting one diagnostic, which is a regression in CI behavior: `tsc` emits `TS2322` and exits non-zero with a parseable diagnostic; `tsgo` emits an unparseable Go runtime stack and exits with a different non-zero code (2 vs. 1). CI pipelines that grep for `error TS` to summarize will report success when they should report a single TS2322.
- The trigger is small and natural. Variadic-tuple types (`[T, ...U[]]`) are the standard tool for typing parameter packs in TypeScript 4.0+. Any library that wraps a function signature through a tuple manipulation will eventually surface this when a consumer mistypes an argument.
- The bug is present in every published tsgo. There is no "stay on the prior version" workaround; downgrading does not help.

## Workarounds for endo PR #438

Three options for the maintainer, in increasing order of disruption:

1. **Leave the bug to upstream and live with the panic.** Keep the PR draft, file the upstream issue, hold the un-draft pending a tsgo release that includes the fix. The PR's other material gap (the harden-cascade JSDoc errors) is independent and can land first.
2. **Avoid the trigger shape in the assertion site.** Replace `expectType<(n: bigint, goodRest: string, badRest: boolean) => boolean>(...)` in `packages/exo/test/types-advanced.test-d.ts` (lines 64-72) with a version that hits the rest element by index rather than by structural assignment, e.g. `type Arg2 = Parameters<Fn>[2]; expectType<string>(null as unknown as Arg2)`. This removes the panic at the cost of weakening the `@ts-expect-error` invariant the test was asserting (the test was asserting the entire signature shape, not just one positional type).
3. **Exclude `test/types-advanced.test-d.ts` from `typecheck-all` via the root `tsconfig.json` exclude list.** Documented as a TODO. Loses the unified type-check coverage on that file, but preserves the per-package `lint:types` coverage (which also panics; option 3 is therefore weaker than option 2 in practice and not really viable on its own).

Option 1 is the cleanest. The PR is already DRAFT and was opened as a `probe #438` deliverable; the unified-compilation panic was one of the two surfaced material gaps. The investigator's deliverable (this entry plus the upstream issue draft below) is the maintainer-actionable narrowing of that gap.

## Concrete fix candidates surfaced for orchestrator

The investigator surfaces; someone else lands. Two candidate work items the maintainer can route as needed:

- **Upstream PR to `microsoft/typescript-go`.** Apply the minimal-fix described above (clamp index to the tuple's last `elementInfo`) plus a regression test mirroring the two-line repro. The investigator has the minimal repro file ready and the call site identified; landing the upstream PR is a builder dispatch.
- **Optional: endo-side test-d adjustment as a temporary unblock.** Trade the `expectType` shape on `test/types-advanced.test-d.ts` lines 64-72 for the `Parameters<Fn>[2]` shape (option 2 above). Smaller scope, no upstream coordination, but loses one structural assertion until the upstream fix lands. Builder or fixer dispatch.

## Upstream issue draft

What follows is intended for verbatim filing as a new issue against `microsoft/typescript-go`. Title is short; body covers repro, expected vs. actual, version range, and the suspected root cause with a source link.

---

**Title:** `tsgo panics in compareSignaturesRelated when source signature has a tuple-rest parameter and target arity exceeds the tuple's leading-element count`

**Body:**

### Repro

`tsconfig.json`:
```json
{
  "compilerOptions": {
    "target": "esnext",
    "module": "NodeNext",
    "moduleResolution": "NodeNext",
    "noEmit": true,
    "types": []
  },
  "include": ["./*.ts"]
}
```

`repro.ts`:
```ts
declare const fn: (...args: [bigint, ...string[]]) => boolean;
const a: (n: bigint, x: string, y: boolean) => boolean = fn;
```

### Expected

Same diagnostic as JavaScript-runtime `tsc` 5.x or 6.x emits:

```
repro.ts(2,7): error TS2322: Type '(args_0: bigint, ...args: string[]) => boolean' is not assignable to type '(n: bigint, x: string, y: boolean) => boolean'.
  Types of parameters 'args_2' and 'y' are incompatible.
    Type 'string' is not assignable to type 'boolean'.
```

### Actual

```
panic: runtime error: index out of range [2] with length 2 [recovered, repanicked]

goroutine N [running]:
... (full Go stack)
github.com/microsoft/typescript-go/internal/checker.(*Checker).getParameterNameAtPosition(...)
    github.com/microsoft/typescript-go/internal/checker/relater.go:1935 +0x11c
github.com/microsoft/typescript-go/internal/checker.(*Checker).compareSignaturesRelated(...)
    github.com/microsoft/typescript-go/internal/checker/relater.go:1580 +0xd49
...
```

### Suspected cause

`getParameterNameAtPosition` at relater.go:1926-1938 indexes `restType.TargetTupleType().elementInfos[index]` without a bounds check when the rest parameter's type is a tuple:

```go
restParameter := signature.parameters[paramCount]
restType := c.getTypeOfSymbol(restParameter)
if isTupleType(restType) {
    index := pos - paramCount
    return c.getTupleElementLabel(restType.TargetTupleType().elementInfos[index], restParameter, index)
}
```

When the source signature is `(...args: [bigint, ...string[]]) => boolean`, the tuple has 2 `elementInfos` (one for the fixed `bigint`, one for the `...string[]` spread). The caller in `compareSignaturesRelated` (relater.go:1580) drives `pos` by the **target** signature's arity. With a target of arity 3, `pos = 2`, `paramCount = 0`, `index = 2`, and the slice access panics.

The reference JavaScript implementation at `microsoft/TypeScript/src/compiler/checker.ts` `getParameterNameAtPosition` does the same `elementFlags[index]` access. In JavaScript that returns `undefined`, which `getTupleElementLabel` accepts and routes to the `undefined`-handling branch producing a fallback name `${restSymbol.escapedName}_${index}`. The Go port appears to have ported the indexing pattern without porting the JS engine's implicit out-of-bounds tolerance.

### Suggested fix

Clamp the slice index to the last element when it exceeds the tuple's `elementInfos` length, since positions past the tuple's trailing spread re-use the spread's element info:

```go
index := pos - paramCount
infos := restType.TargetTupleType().elementInfos
if index >= len(infos) {
    index = len(infos) - 1
}
return c.getTupleElementLabel(infos[index], restParameter, index)
```

(Or, to preserve the JS behavior more faithfully, push a bounds-checking helper that returns a zero `TupleElementInfo` plus `nil` labeledDeclaration and let `getTupleElementLabel` synthesize the fallback name.)

Related sites that index by `pos` and may have the same hazard are worth a sweep; `compareSignaturesRelated` (relater.go:1580) iterates over the **target**'s parameter list and passes that `i` into both `getParameterNameAtPosition(source, i)` and `getParameterNameAtPosition(target, i)`, so any other function in the relater that takes a `pos` driven by the target's arity and indexes a source-side per-element slice would have the same shape.

### Version range

Confirmed panic on every published `@typescript/native-preview` version tested, including the first available release:

- `7.0.0-dev.20250522.2` (earliest published)
- `7.0.0-dev.20251101.1`
- `7.0.0-dev.20260101.1`
- `7.0.0-dev.20260301.1`
- `7.0.0-dev.20260512.1`
- `7.0.0-dev.20260601.1`
- `7.0.0-dev.20260605.1`
- `7.0.0-dev.20260611.2` (initial report)
- `7.0.0-dev.20260612.1` (latest as of report)

JavaScript-runtime `tsc` 6.0.3 (the catalog pin) emits the expected `TS2322` and is unaffected.

---

End of upstream issue draft.

## Notes for the orchestrator

- I did not push anything to PR #438, did not comment, did not open the upstream issue. The brief was journal-only and read-only; both constraints are respected.
- The minimal repro lives at `/tmp/tsgo-repro/{repro.ts,tsconfig.json}` in the dispatch root host. The orchestrator's teardown removes the dispatch root but leaves `/tmp` alone; the repro will persist until the next host reboot. Worth lifting verbatim into the upstream issue body or into the endo repo if it becomes the basis for a fix-confirming test.
- The builder's per-package `lint:types` sweep is independently still hitting the same panic inside `@endo/exo` (per the builder's result entry's package list). Either workaround (option 2 or option 3 above) clears it; the upstream fix clears it for free.

Self-improvement: nothing this time. The investigator role's `Hypothesis-driven over comprehensive` norm and `Validate by sampling` directive were both directly load-bearing for this dispatch; the role file is sized correctly for the work.
