All 15 checks are green. The shepherd's work is done. No comment authorization was granted in the job body, so I'm not posting a green-run summary comment on the PR (external-repo etiquette).

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #96

**Diagnosis:** Of the 15 CI checks, only `lint` was red. The failure was a single Prettier formatting complaint on `packages/compartment-mapper/test/search.test.js` — fallout from the PR's own rename commit (`walkUpwards`→`walkToCompartmentRoot` and `search`→`searchCompartmentDescriptor`). The longer identifier `searchCompartmentDescriptor` changed several call sites' line-wrapping, and Prettier's `--check` (which short-circuits before `eslint` in `yarn lint`) flagged them. This is a class-C tractable failure, fully in the PR's scope — no impasse, no safety concern.

**Fix applied:** Ran `prettier --write` on the one file (7 insertions, 9 deletions — pure reformatting of three `await searchCompartmentDescriptor(...)` call sites). Committed as `chore(compartment-mapper): prettier-format search.test.js after rename` in an isolated project worktree keyed to this job base, pushed to the PR head branch `design/compartment-mapper-auxiliary-package-json` with `--force-with-lease` anchored on the expected prior SHA `845dd3f743`.

**Result:** New head `ee41a8a298a41226da00d5fd61303cab48bae482`. CI re-dispatched and **all 15 checks passed (15/15 SUCCESS)**, including the previously-red `lint`. PR is OPEN and green.

**Follow-ups:** None. CI is green; the PR is back out of the "is the red mine or the author's?" ambiguity and ready for maintainer review. (Dependabot noise on the default branch is unrelated to this PR and out of shepherd scope.)
