I reworked the existing draft PR endojs/endo-but-for-bots#1640 to match the design in #1671, as the design report asked, instead of opening a new PR. CI passes on every test leg that actually ran. Two checks are red, and neither is caused by this PR (see CI below).

**PR state:** #1640 is still a draft, mergeable, head `1d9a1ff8f7`. I rebased it onto the design branch `design/endopi-prompt-templates` and changed its base to that branch, so it is now stacked on #1671. I also added this job's `garden-job` marker to the body, and `ensure-pr.sh` picked up #1640 under this job.

**What changed, following the design's "Delta from #1640" list:**
1. **Placeholders:** `{{name}}` is gone. Templates now use Pi's syntax: `$n`, `$@`, `$ARGUMENTS`, `${n:-default}`, `${@:-default}`, `${@:N}`, `${@:N:L}`. Substitution is a single pass, so a substituted value is never expanded again, and any other `$` text stays as typed. Each template now records its `argument-hint`, its highest `$n`, and whether it takes "all arguments" (`$@` and kin).
2. **Argument splitting** follows the design's five rules: a quote only starts a quoted argument at the start of a word (`don't` stays one word), an unmatched quote stays as text, and backslashes never escape.
3. **`argument-hint`** is read from frontmatter. It is shown after the name in the `/` menu and labels the form fields: `<x>` is required, `[x]` is optional. Without a hint, the fields are optional `$1`…`$n`, and the form opens only when the template is invoked with no arguments.
4. **Too many arguments** is an error only when the template has no "all arguments" placeholder. Extra arguments typed before the form opens are kept and passed on when it is submitted.
5. **Shared directory search:** `listConventionalDirectories({ cwd, home, leaves })` is in `@endo/prompt-templates/node.js`, and the prompt-template directory list is built on it. #1643 hasn't merged, so this package got it first; #1643 should import it rather than keep its own copy.
6. **Design file:** `designs/endopi-prompt-templates.md` now has a `## Status` section, and its status (and its row in `designs/README.md`) is In Progress.

Also changed:
- Template names may now contain `.`, per the design.
- I rewrote the package README and the changeset text for the new syntax.
- I rewrote the unit and component tests to cover each placeholder form, each splitting rule, single-pass substitution, the design's own example, the shared directory search, defaults for omitted optional arguments, and the "all arguments" path.

**The two open questions in #1671** are built at the recommended defaults: no `{{name}}` extension, and only the user (not agents) can invoke templates. If the maintainer decides otherwise, this needs follow-up work.

**Local checks:** `@endo/prompt-templates` passed 39/39 tests, and the `@endo/chat` catalog, chat-bar and command-registry tests passed 78/78. eslint (errors only) and prettier are clean on the touched files, and `tsc` reports no errors in the three packages. I did not run the repo-root `tsc` check.

**CI (run 44157685313):**
- All other checks pass, including `test` on 22.x and 24.x ubuntu and 22.x macos-15.
- `test-xs` fails on the hardened262 `ThrowTypeError/intrinsic-metadata.js` baseline. This is the known Node 26 LTS drift: the fix `d82988084a` is on #1559 and not yet on llm. That job also shows the usual benchmark timing failure. It failed the same way on the rerun.
- `test (24.x, macos-15)` was cancelled twice without running. The second time it never got a runner (0 steps) and was cancelled after about 15 minutes in the queue. The 22.x macOS leg passes.

**Follow-ups:**
- The completion machinery should stage #1640's gauntlet; its CI step will need to rerun `test (24.x, macos-15)`.
- When #1671 merges, #1640's base needs to move back to an llm-based branch, and #1643 should switch to importing `listConventionalDirectories`.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-endopi-prompt-templates.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 176 tokens (9625955 cached reads)
- Output: 43597 tokens
- Cost: $3.8768909999999996
- Wall-clock: 5446s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
