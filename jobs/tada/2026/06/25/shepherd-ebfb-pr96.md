Cleaned up. CI is fully green.

---

## Completion report

**Job:** `shepherd-ebfb-pr96` — drive endojs/endo-but-for-bots PR #96 CI to green.

**Outcome: CI fully green.** All 15 checks pass on the fixed head `905cb7204`.

**What I found:** On the incoming head `729e07f11`, every test job passed (test matrix ×4, cover, test262 ×2, hermes, xs, ocapn-python, build, zizmor, etc.) — only the **`lint`** check failed. Classification: in-scope, not fixer-fixable, trivial. The failure was purely **Prettier formatting** (`prettier --check`) on the two source files this PR touched, `map-parser.js` and `node-modules.js`. The Phase-7 author's local "eslint clean" check did not include the Prettier formatting step that CI's `yarn lint` runs first.

**What I did:**
1. Reproduced the failure in a clean clone at the PR head (full `yarn install`, confirmed `prettier --check` flagged both files).
2. Ran `prettier --write` on the two files — the diff is **line-rewrapping only, no semantic change** (long `.map(...)` and spread-ternary calls re-wrapped to fit width).
3. Verified locally: repo-wide `prettier --check` → clean ("All matched files use Prettier code style!"); `eslint` on both files → clean.
4. Committed as `905cb7204` *"chore(compartment-mapper): prettier-format parse-time honoring sources"* under the bot identity and pushed to `design/compartment-mapper-auxiliary-package-json`.
5. Watched the re-triggered CI run to completion: **lint now SUCCESS**, all other 14 checks SUCCESS.

**State:** PR #96 is OPEN, MERGEABLE, not draft, CI green. Working clone torn down; inbox empty throughout (no maintainer/peer messages).

**Follow-ups:** None required for CI. No escalation to fixer (resolved in-scope). Worth noting for the design branch's authoring chain: the gardening/build automation's pre-push lint should run `yarn lint:prettier` (the formatting check), not just eslint/tsc, to catch this class before it reaches CI — but that's a tooling observation, not a blocker on this PR.
