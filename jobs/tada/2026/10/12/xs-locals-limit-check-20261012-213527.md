## The XS frame-locals fix has landed upstream (final run; I retired the schedule)

Moddable's parser now rejects scripts with more than 65535 locals in a frame. The fix is commit `cfe72a8cfcd23b188fbb75ea2786e5fb56432812` ("oss-fuzz: fix crash on scope overflow", dated 2026-09-10) on `Moddable-OpenSource/moddable` master. It shipped in **Moddable SDK 10.0.0**, published 2026-10-09; its release notes include "SyntaxError `too many variables` when a function, module, or program exceeds 65535 scope slots (found by OSS-Fuzz)". Master tip when I checked was `5f215f776f` (2026-10-09). I only read upstream and did not interact with it.

### What the fix does
- **Limit:** a frame may have at most 65535 scope slots. That count includes named variables and the compiler's own temporary slots.
- **Where:** in `xs/sources/xsScope.c`, in the bind step for each function, module and program. The check runs once the scope is finished, so a frame is rejected before any byte code is generated.
- **Error:** a `SyntaxError` with the message "too many variables", reported at the line of the function, module or program.
- **What it counts:** every way a slot gets used: `var`, `let` and `const`, parameters, destructuring, `catch` bindings, hoisted functions, captured variables and temporaries. Nested blocks count toward their enclosing function's frame.
- **Upstream test:** `tests/xs/issues/scope-count-limit.js`. 65535 `let`s must compile; 65536 must throw `SyntaxError`.

### Built and checked XS before and after the fix
I built `xst` locally at the fix commit and at its parent `71196ed`, and ran the same scripts on both:

| Input | Before the fix | After the fix |
|---|---|---|
| 65535 `let`s | compiles, runs | compiles, runs |
| 65536 or 70000 `let`s | compiles silently (bad byte code) | SyntaxError "too many variables" |
| 65540 `let`s, writing the last one | `TypeError set a4: undefined private property` (the slot write lands on the wrong instruction) | SyntaxError |
| chain of 32767 tagged templates (the OSS-Fuzz case) | `TypeError this: not an iterator (in next)` | SyntaxError |

The fix rejects the over-limit scripts that broke the old XS.

### Iron Horse's port (endo-but-for-bots PR #1278, still a draft, head `b09834bac8`)
The port matches XS on the limit, where it is enforced, and the error type and message. I ran the upstream test inputs through PR #1278's compiler and runtime, and two differences turned up:

1. **Programs XS accepts are rejected.** With 65534 or 65535 variable names, Iron Horse fails with `too many symbols (maximum 65534)`. With 65533 names it compiles, but the run is refused with `property-key:id-space-exhausted`. XS's own regression test therefore fails its first assertion on Iron Horse.
2. **The OSS-Fuzz case never reaches the new check.** On the 32767 tagged-template chain, Iron Horse's parser fails first with `stack overflow`. The PR's tests also have no case where the slots come only from temporaries.

A minor difference: for class field initializers, Iron Horse reports the error at the first field's line rather than the line of the initializer function XS generates. Ordinary functions report the same line in both.

### Changes
- **Follow-up job posted:** `ironhorse-reconcile-xs-frame-locals-limit` is a fixer job against PR #1278 and is now in `jobs/todo`. It covers:
  - deciding whether to raise Iron Horse's name limits to match XS, or to document the difference;
  - adding an over-limit test built only from temporaries;
  - porting `scope-count-limit.js`;
  - updating the PR description, which still says the fix is not upstream.
- **Schedule retired:** I removed `schedules/xs-frame-locals-limit-upstream-watch.md` from `journal2` with `remove-schedule.sh`, and confirmed on `origin/journal2` that it is gone. **The weekly watch has stopped.**

No garden code changed, so there was nothing to commit to `main2`. I deleted my temporary probe test from the project worktree before finishing. That worktree also shows an uncommitted change to `packages/floot/package.json`, which I didn't make; I left it alone.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/xs-locals-limit-check-20261012-213527.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 42 tokens (1360716 cached reads)
- Output: 12801 tokens
- Cost: $1.0805152
- Wall-clock: 318s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
