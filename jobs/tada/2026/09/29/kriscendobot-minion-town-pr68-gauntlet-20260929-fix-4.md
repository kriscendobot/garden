I applied the panel-4 fixes to kriscendobot/minion.town PR #68 and pushed them as four commits (head is now `80fb1ee`). CI finished green: 3/3 checks passed, with `ci-wait-merge` returning 0. Locally, typecheck is clean and the full test suite passes (582 passed, 8 skipped).

**Blocking items:**
- **saboteur:** `resolveNamedContent` now catches a failed `facet.evaluate` and reports it as `content value "X": <reason>`. The new test takes the real `TypeError` that `JSON.stringify` throws for a BigInt and for a cyclic value, and checks that the named error comes back. I also renamed `sourceName` to `contentValueLabel`, as stylist asked.
- **fast-checker:** added a property test for `utf8ByteLengthWithin`. It runs 2000 cases of random UTF-16 code units (biased toward surrogates, so lone and reversed ones are common) and random limits, and compares each result against `TextEncoder`. `fast-check` is added as a devDependency, and the `package-lock.json` update is in its own commit.

**Should-fix items:**
- **Mock auth server:** it now reads `code` only when it is a string (the `client_credentials` and `refresh_token` grants don't send one). It deletes each granted-scope entry once read, so the map no longer grows. A new test in `test/auth.test.ts` exchanges a code without sending `scope`, confirms the token carries the scope granted at `/authorize`, and confirms a replayed code doesn't get it.
- **spec-keeper:** the two `guest.has.bind(guest)` calls in `guest-control.ts` and `daemon-site-registry.ts` are now plain closures. The one in `daemon-site-registry.ts` needs a `!` (non-null assertion) because TypeScript doesn't carry the `guest.has ?` check into the closure.

There are no follow-ups. The driver re-posts panel-5.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr68-gauntlet-20260929-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1539254 cached reads)
- Output: 9925 tokens
- Cost: $1.0765508000000001
- Wall-clock: 417s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
