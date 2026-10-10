## Moddable 10.0.0 XS inventory, part c (2026-09-04 → 2026-10-08, ending at 5f215f77)

Every item has a matching commit in the range. I got each commit's message and changed-file list from the GitHub API. I only read the actual diff for the scope-slot item (cfe72a8c), so the behavior column for the other seven comes from the commit titles plus the spec. **The test262 paths are suggested starting points, not checked against a test262 checkout.** The `#17xx` numbers are Moddable issue numbers taken from the commit titles.

All eight items are **engine semantics**. None of them is ECMA-419, device, Piu, board, TypeScript or xsdb work.

| # | Item | Commit (stable URL) | XS files changed | test262 / spec anchor | Expected behavior |
|---|---|---|---|---|---|
| 1 | IsCallable on a revoked Proxy | https://github.com/Moddable-OpenSource/moddable/commit/1e71939f630aa61cbd8d7199b0e13d956e2b9d4d (2026-09-21) | `xsAll.c` (+2), `xsFunction.c` (+2) | Spec: IsCallable checks for a [[Call]] slot, which a Proxy keeps after revocation. Likely tests: `built-ins/Proxy/revocable/` and `typeof` on revoked proxies, e.g. `language/expressions/typeof/proxy.js` (unverified) | A revoked Proxy whose target was callable must still count as callable: `typeof` gives `"function"` and IsCallable is true. Calling it throws TypeError because it is revoked, not because it "is not a function". Which symbol changed is unconfirmed (probably the IsCallable helper or macro). |
| 2 | Array.from: ToLength on array-like lengths | https://github.com/Moddable-OpenSource/moddable/commit/eb7d6de2802c0fc0840a9e7eebe7f041cbf2ba4c (#1715) | `xsArray.c` | `built-ins/Array/from/` (array-like length cases); spec 23.1.2.1 step 9 (`LengthOfArrayLike`) | Array.from must accept any length that ToLength accepts (it clamps to 2^53−1 and turns negatives and NaN into 0) instead of rejecting it early. Any limit belongs to ArrayCreate or Construct. |
| 3 | Array.from: when @@iterator's callability is checked | https://github.com/Moddable-OpenSource/moddable/commit/a795d3e926d3bcc280e3b8bf373ac8f245f4e17c (#1720) | `xsArray.c` | `built-ins/Array/from/iter-*` (unverified); spec 23.1.2.1: `GetMethod(items, @@iterator)` throws a TypeError for a non-callable value before step 5a `Construct(C)` | If @@iterator is present but not callable, throw TypeError **before** constructing the result. Observable: the `this` constructor is never called. |
| 4 | Reflect.apply / Reflect.construct argument reads with a Proxy target | https://github.com/Moddable-OpenSource/moddable/commit/7abe778a17a2cab61138c2e75fef9cb6a4c4df39 (#1717) | `xsProxy.c` | `built-ins/Reflect/apply/`, `built-ins/Reflect/construct/` (arguments-list ordering); spec 28.1.1 and 28.1.2: `CreateListFromArrayLike(argumentsList)` runs before the [[Call]] or [[Construct]] dispatch | Even when the target is a Proxy, `argumentsList` must be read in full (`length`, then each index, through any getters or traps) before the proxy's apply or construct trap runs. The commit title says XS skipped CreateListFromArrayLike for Proxy targets. |
| 5 | Object.prototype.toString: reading @@toStringTag through a callable Proxy's handler | https://github.com/Moddable-OpenSource/moddable/commit/477da58026588cd1a357a96225b75692e8179dc9 (#1721) | `xsObject.c` | `built-ins/Object/prototype/toString/proxy-*` (unverified); spec 20.1.3.6 step 15: `Get(O, @@toStringTag)` goes through the proxy's `get` trap | For a callable Proxy, the `get` trap must see the @@toStringTag read, and a string tag it returns becomes `[object Tag]`. The builtin tag is still "Function". |
| 6 | Array.fromAsync when the iterator's `next` returns a non-object | https://github.com/Moddable-OpenSource/moddable/commit/fbbd2cbb8d424c2f0c10a312f2854b457fb32074 (#1722) | `xsArray.c` | `built-ins/Array/fromAsync/` (non-object iterator result, unverified); spec (proposal, now ES2026): an IteratorResult that is not an object throws TypeError | The promise returned by Array.fromAsync must **reject** with TypeError. Before the fix it never settled. |
| 7 | Set methods when `other.size` exceeds 2^31−1 | https://github.com/Moddable-OpenSource/moddable/commit/0768ebb7c6a8fd9b1b4ac81e76abb2678fc8cf7b (#1725, title marked "(?)") | `xsMapSet.c` | `built-ins/Set/prototype/{union,intersection,difference,isSubsetOf,isSupersetOf,isDisjointFrom,symmetricDifference}/`; spec GetSetRecord: `size` → ToNumber → ToIntegerOrInfinity, then compared as a mathematical value | Comparisons of `this.size` against `other.size` must use the full integer (or double) value, not one truncated to int32. Truncation was observable with large fake sizes on x86-64 and changed which branch the algorithm took (for example in intersection, isSubsetOf, isDisjointFrom). The "(?)" in the upstream title suggests upstream was unsure of the cause. |
| 8 | SyntaxError for code with more than 65535 scope slots | https://github.com/Moddable-OpenSource/moddable/commit/cfe72a8cfcd23b188fbb75ea2786e5fb56432812 (2026-09-10, oss-fuzz) | `xsScope.c` (+6: when `binder->scopeMaximum > 65535`, calls `fxReportParserError(..., "too many variables")`); adds the test `tests/xs/issues/scope-count-limit.js` | XS-specific implementation limit (no test262 test). Moddable's test: 65535 `let` bindings compile; 65536 throws SyntaxError | A function, module or program that needs more than 65535 scope slots (variables plus compiler temporaries) must fail with SyntaxError instead of producing corrupt bytecode. ClusterFuzz found the bug as a null dereference after 32767 tagged templates. |
| 9 | `switch` with labelled break/continue leaks stack | https://github.com/Moddable-OpenSource/moddable/commit/051b31b2dc09e8c038a2fd27092d32972a5ab9cc | `xsCode.c`, `xsScope.c` | Likely `language/statements/switch/` and `language/statements/labeled/`, plus completion-value tests (unverified) | A labelled `break` or `continue` that leaves a `switch` (for example `continue outer` from inside a case) must pop the switch's discriminant or temporaries from the stack. Repeating it in a loop must not grow the stack or corrupt later values. |

Items 2 and 3 are listed separately because they are separate upstream commits.

### Other XS engine commits in range (not in this part's scope; possibly covered by a sibling part)
- `db0490c5bcd5` regexp replace reads each capturing-group value once
- `dca752b707d4` String.prototype.replace with a Proxy replacer whose target is a function (#1716)
- `df98bbacb808` TypedArray constructors read newTarget's prototype before converting the length (#1718)
- `c645752e4b44` and `d19b9da1e009` TypedArray species creation content-type check (#1723)
- `b4e0cab143c7` ArrayBuffer resize argument conversion order (#1724)
- `2d059ebaee86` TypedArray.prototype.set offset RangeError order (#1726)
- `f98758c91a2d` and `bf1c67142309` immutable ArrayBuffer build flag, now enabled by default
- `33cc1b4bf1ce` snapshot-table name for sliceToImmutable
- `83ab166a0386` RevalidateAtomicAccess
- `31f7c389bc25` ASAN poisoning of shrunk blocks (memory-tooling hygiene, no semantic change)

### Not engine semantics (ECMA-419, device, Piu, board, TypeScript, xsdb)
Most of the other commits in range fall here:
- ECMA-419 System object migration, conformance tests and keyValue renames
- typings and linting
- ESP32, pico, nrf52, Zephyr and Pebble targets and manifests
- Piu outline
- mcrun and mcpack tooling

### Uncertainties and follow-ups
- I only read the diff for item 8. For the others, the behavior column comes from the commit title plus the spec, and the files listed are the only files those commits touched. The changed functions inside those files were not identified.
- The test262 paths are guesses at directories; none were checked against a test262 checkout. A successor should run the matching test262 slice on the 10.0.0 xst before and after each commit.
- None of these commits are ported to IronHorse (this job was research only). No garden repo changes and no commits were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/moddable-10-0-0-xs-inventory-part-c-20261009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (176488 cached reads)
- Output: 4402 tokens
- Cost: $0.48644960000000004
- Wall-clock: 51s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
