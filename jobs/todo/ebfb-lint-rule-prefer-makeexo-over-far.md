# Lint rule: prefer makeExo over Far (maintainer follow-up ask)
Repo: endojs/endo-but-for-bots (bot; base `llm`). Maintainer directive (kriskowal, #58 review
4611555757): "We do not use Far except under extenuating circumstances. Please post a follow-up job to
establish a lint rule."
Task: add a lint rule in the repo's **`@endo/eslint-plugin`** (the established custom-lint mechanism —
same place as the `@endo/jsdoc-import-extensions` rule) that **flags `Far(...)` usage and steers to
`makeExo`**. Allow a documented escape hatch for genuinely extenuating circumstances (e.g. an eslint-
disable with a required reason), since Far is not *forbidden*, just discouraged. Wire it into the shared
config so packages inherit it; scope sensibly (source + tests). Add RuleTester cases (Far→report,
makeExo→ok, the escape-hatch→ok). Run `yarn mocha` in the eslint-plugin + `eslint .` green (report any
NEW violations the rule surfaces in the current tree — if many, propose scoping/warn-first rather than
erroring the whole tree). Add a changeset. Open a DRAFT PR on endo-but-for-bots (base `llm`, frozen-base
discipline). Bot fork; no upstream contact.
