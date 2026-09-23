---
source_kind: web
source_url: https://erights.org/elang/intro/finding-text.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/finding-text.html
source_fetched_via: mirror
source_content_sha256: b8eaab98cea555b1951c69f05115b3430905c6fd8689ecd3eecca330346bee01
source_authors: [Mark S. Miller, Amy Mar]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Primary erights.org E-language tutorial body chapter ("Example: Finding Text"),
  the first hands-on walkthrough the tutorial index page only listed. Fetched
  2026-06-27 from the erights.github.io GitHub Pages mirror via
  scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses
  sandbox connections). Idempotency anchor is source_content_sha256, not a commit.
  Body chapter of the tutorial whose index is
  [erights--elang-intro](erights--elang-intro.md); grounds the secondary-source
  survey [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md).
---

The first hands-on chapter of the E language tutorial from erights.org: a guided build of a text-finding program (search the lines of a file, then all `.txt` files in a directory tree). It introduces E's conventional-language constructs — `for`-loops over collections, `def`-defined functions, parameters, the `if` / `else if` expression, recursion, string concatenation, and quasi-literal interpolation — and the file-as-mapping model (`for num => line in file`). Its load-bearing capability-theory point is E's framing of the **message call as the primitive and the function call as the special case** (`print(x)` is "a message call in which no message name is provided"), the substrate on which E's object-capability model is built. The chapter also shows E's transparent reuse of Java objects (`java.lang.String`, `java.io.File`).

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elang-intro-finding-text--walkthrough](../sections/erights--elang-intro-finding-text--walkthrough.md) | capability-theory | current |
