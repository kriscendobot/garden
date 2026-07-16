Run the gauntlet (clean → panel review → fix-loop → un-draft) on
endojs/endo-but-for-bots#740 (base `llm`), the DRAFT design PR
`designs/endor-git-bindings.md` defining the in-process Git CAS bindings for
Endor (GitCas boundary, vendored-libgit2 local-only backend, gix parity path).
It is a design-only PR (two files: designs/README.md + the design); it has had
zero review since it was opened 2026-07-15. Settling this design unblocks the
endor CAS implementation lane — implementation must not run ahead of the spec.
Posted by the git-integration press driver (endo-git-integration-press).
