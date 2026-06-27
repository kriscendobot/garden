---
source_kind: web
source_url: https://erights.org/elang/intro/starting-e.html
source_effective_url: https://erights.github.io/erights-org-website/elang/intro/starting-e.html
source_fetched_via: mirror
source_content_sha256: 27990f44ed96ebf617e2b79d1432c0de57433a05e75dc7038a3b01e99c03ca65
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-27
ingested_by: scholar
section_count: 1
status: current
notes: |
  Primary erights.org E-language tutorial body chapter ("Starting E and Elmer"),
  the launch-the-interpreter chapter the tutorial index only listed. Fetched
  2026-06-27 from the erights.github.io GitHub Pages mirror via
  scripts/jobs/fetch-source.sh (`source_fetched_via=mirror`; erights.org refuses
  sandbox connections). Idempotency anchor is source_content_sha256, not a commit.
  The source SELF-FLAGS as obsolete ("*** This chapter is obsolete and needs to be
  rewritten. There is no more 'elmer', and the 'e' command has been replaced by the
  bash script 'rune'..."): the tooling names are historical, but the REPL convention
  and the literate-prototyping idea remain teachable. Body chapter of the tutorial
  whose index is [erights--elang-intro](erights--elang-intro.md); grounds the
  secondary-source survey [ocap-history--e-capdesk-polaris](ocap-history--e-capdesk-polaris.md).
---

The (self-described obsolete) opening chapter of the E language tutorial: how to launch an E interpreter and the `elmer` prototyping editor. It documents E's read-eval-print loop (type an expression at the `?` prompt, the interpreter prints `# value: <result>`), the *historical* tooling names a reader needs to parse older erights.org pages (the original `e` command, since replaced by the bash script `rune`; the `elmer` GUI editor; the `eBrowser` and `capDesk` Windows shortcuts), the `elmer` literate-prototyping editor that interleaves plain text with live interpreter sessions, and the project's ambition to "run all our documentation as a readable automated regression test." The chapter carries a maintainer note that it is obsolete and needs rewriting.

| Section | Topics | Status |
|---------|--------|--------|
| [erights--elang-intro-starting-e--launching-and-elmer](../sections/erights--elang-intro-starting-e--launching-and-elmer.md) | getting-started | current |
