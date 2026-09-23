Implemented and pushed `bb971c9a39` to `main2`.

- Fully armed own forks now get a successful-probe local stamp and recheck every 4 hours; 404s tombstone and remove both records. rc2 remains untouched/retried.
- Existing reconciler disables all watcher timer families after records are removed.
- Added liveness regression coverage: 31 passed.
- Ran syntax checks; repository gate suite has unrelated pre-existing inbox-policy failures.
