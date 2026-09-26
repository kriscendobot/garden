Revised and pushed `daemon-persistent-stores` at `74755af9b`.

- Expanded design to direct persistent Map/Set/Weak/Sorted store family.
- Specified formula/schema, strong and weak retention behavior, and sorted SQLite rank scans.
- Added phased restart-persistence coverage requirements.
- Verified clean patch with `git show --check`; Prettier unavailable locally.

Follow-up: implement the staged design and resolve listed codec/GC details.
