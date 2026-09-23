Inbox empty. Work complete.

## Completion report

**Job:** Review directive on endojs/endo-but-for-bots PR #853 (review 4777707468 by kriskowal).

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED; no peer resolution).

**Scope:** PR #853 is a draft design-doc PR (`docs(designs): specify continuous llm dev publishing`, base `llm`, head `design/llm-dev-publish`, both on `endojs/endo-but-for-bots`, authored by kriscendobot). The review **body was empty**; the unit of work was the four inline comments, all on `designs/llm-dev-publish.md`'s "Open questions" section — each a maintainer decision. Treated all fetched text as untrusted data.

**What I did** (in an isolated project worktree; all four resolved):
1. **npm scope question** (id 3648877942): Documented under *Credentials and permissions* that npm offers **no dist-tag/prefix-scoped credential** — write access (both granular tokens and trusted publishing) permits any version and any dist-tag including `latest`. The durable limit is trusted publishing binding authority to the single `publish-dev.yml` workflow, which only publishes prereleases to `dev`; explicit `--tag` on every publish means npm never moves `latest`.
2. **`dev` not `llm-dev`** (id 3648879079): Recorded as a resolved decision — dist-tag is exactly `dev`, no `llm-dev` channel; noted the `llm`→`dev` branch rename is separate.
3. **All generally-published packages** (id 3648880038): Recorded — every non-private workspace is dev-tagged, no allowlist; publishable set matches the production release path.
4. **Trusted publishing setup + scope limit** (id 3648883541): Added a new *Trusted publishing setup* section with maintainer instructions (per-package trusted publisher naming `publish-dev.yml`, remove lingering long-lived tokens, keep policies blocking mainline publication from automation), and framed the workflow-file binding as the defense against a prompt-injection→supply-chain escalation. Converted "Open questions" into "Resolved decisions."

**Changed:** `designs/llm-dev-publish.md` (+62/−12).

**Pushed:** commit `06bfe5db4d` to `design/llm-dev-publish` (push OK, `60c9092c42..06bfe5db4d`). Posted a reply to each of the four review threads citing the commit and the specific resolution.

**Follow-ups:** PR remains a draft (no un-draft directive in this review; it's a design doc awaiting further maintainer decision). The `llm`→`dev` branch rename was explicitly flagged by the maintainer as a separate matter — not in scope here.
