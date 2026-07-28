In kriskowal/garden (`main2`), sweep the ~80 suites under `scripts/jobs/test/` that export neither `GARDEN_TEST` nor `JOURNAL_REMOTE` and add per-suite isolation. The new entrypoint heuristic already covers the leak-from-the-test-process shape, so this is defense in depth; there is no aggregate runner to hang the sentinel on, hence the per-suite sweep.

<!-- garden-reaped: 1 -->
