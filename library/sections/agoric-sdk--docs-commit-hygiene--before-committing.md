---
title: Before Committing Changes (6 steps)
source: docs/commit-hygiene.md
source_repo: agoric/agoric-sdk
source_commit: 61325fe5
source_date: 2026-02-27
source_authors: [Turadg Aleahmad]
ingested: 2026-05-14
ingested_by: scholar
project: agoric-sdk
topics: [repository-governance, tooling]
status: current
---

> Abstract: Six pre-commit steps consolidated: run code generation if applicable, update package locks, format with Prettier, install git hooks, run lint, run tests, build before testing. The procedural checklist agoric-sdk maintains.

## Before Committing Changes

### 1. Run Code Generation (if applicable)

If you modify files in packages that have a `codegen` script, you **must** run it before committing:

```bash
# For client-utils
cd packages/client-utils
yarn codegen
```

This generates TypeScript code from proto files and ensures consistency.

### 2. Update Package Locks (if changing package.json)

If you modify any `package.json` files, you **must** run the lock file update script:

```bash
# From repository root
scripts/update-package-locks.sh
```

This updates all yarn.lock files across the repository. This is critical because:
- Several different yarn projects in the repo depend on the root yarn project's dependency graph
- These projects use the "portal" protocol which creates dependencies on the monorepo structure
- Changes to any package.json can affect lock files in other parts of the repository

**Always run this script even if you think only local changes were made.**

### 3. Format Code with Prettier

Always run Prettier to ensure code style compliance:

```bash
# From repository root
yarn format
```

Or format specific files:

```bash
yarn run -T prettier --write path/to/file.js
```

### 3b. Install Git Hooks (recommended once per clone)

Install repository hooks so staged JS/TS files are auto-formatted on commit:

```bash
yarn hooks:install
```

### 4. Run Linting

Ensure your changes pass linting:

```bash
# In the package directory
yarn lint

# Or with auto-fix
yarn lint-fix
```

### 5. Run Tests

Run tests in the affected package:

```bash
# In the package directory
yarn test

# Or just build and typecheck
yarn build
```

### 6. Build Before Testing

Some packages require building before tests will pass:

```bash
yarn build && yarn test
```

- client-utils
- cosmic-proto

Issue: [Changes to package "client-utils" are not visible without compilation #11954
](https://github.com/Agoric/agoric-sdk/issues/11954)


Source: [docs/commit-hygiene.md](https://github.com/agoric/agoric-sdk/blob/61325fe5/docs/commit-hygiene.md) at commit `61325fe5`.
