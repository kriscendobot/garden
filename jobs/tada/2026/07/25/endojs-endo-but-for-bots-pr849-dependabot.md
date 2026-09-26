REJECT — closed endojs/endo-but-for-bots#849.

Reviewed the live head `d0f95e3`: it includes 64 non-root dependency/lockfile files (including source and tests), violating the Dependabot metadata-only gate. Scripts-disabled immutable install passed; OSV found no advisories across 114 newly resolved versions; npm audit findings were pre-existing and unrelated.

Posted the structured verdict, closed the PR, and recorded the terminal disposition in the dependabotany ledger. Follow-up: regenerate as a dependency-metadata/lockfile-only PR; keep formatter changes separate.
