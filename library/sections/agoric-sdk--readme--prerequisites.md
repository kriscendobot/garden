---
title: Prerequisites (with Apple Silicon notes)
source: README.md
source_repo: agoric/agoric-sdk
source_commit: 511d4f74bae7144be5bc904dd7a50f01d09648ed
source_date: 2026-03-25
source_authors: [Michael FIG]
ingested: 2026-05-14
ingested_by: scholar
topics: [getting-started, tooling]
status: current
notes: Soft-flag overlap with agoric-sdk--docs-node-version-- and agoric-sdk--contributing--overview-platforms-and-toolchain. This is the canonical version-range source for any toolchain-bootstrap procedure.
---

> Abstract: agoric-sdk's toolchain prerequisites: Git, Go ^1.24.1, Node.js ^20.9 or ^22.11 (latest LTS recommended via nvm), Yarn (any version — `.yarnrc` pins the checked-in `.yarn/releases/` version), gcc ≥10 / clang ≥10 / another compiler with `__has_builtin()`. These ranges are also enforced in `repoconfig.sh` (`golang_version_check`, `nodejs_version_check`). Apple-Silicon and newer-arch builds may need to compile some native deps from source — currently Canvas — and may require `export CPLUS_INCLUDE_PATH=/opt/homebrew/include` and `xcode-select --install`.

## Prerequisites

Prerequisites are enforced in various places that should be kept synchronized
with this section (e.g., [repoconfig.sh](./repoconfig.sh) defines
`golang_version_check` and `nodejs_version_check` shell functions).

* Git
* Go ^1.24.1
* Node.js ^20.9 or ^22.11
  * we generally support the latest LTS release: use
    [nvm](https://github.com/nvm-sh/nvm) to keep your local system up-to-date
* Yarn (`npm install -g yarn`)
* gcc >=10, clang >=10, or another compiler with `__has_builtin()`

Any version of Yarn will do: the `.yarnrc` file should ensure that all commands
use the specific checked-in version of Yarn (stored in `.yarn/releases/`), which
we can update later with PRs in conjunction with any necessary compatibility
fixes to our `package.json` files.

### Building on Apple Silicon and Newer Architectures

Some dependencies may not be prebuilt for Apple Silicon and other newer
architectures, so it may be necessary to build these dependencies from source
and install that package's native dependencies with your package manager (e.g.
Homebrew).

Currently these dependencies are:

* [Canvas](https://github.com/Automattic/node-canvas#compiling)

Additionally, if your package manager utilizes a non-standard include path, you
may also need to export the following environment variable before running the
commands in the Build section.

```sh
export CPLUS_INCLUDE_PATH=/opt/homebrew/include
```

Finally, you will need the native build toolchain installed to build these items
from source.

```sh
xcode-select --install
```

Source: [README.md](https://github.com/Agoric/agoric-sdk/blob/511d4f74bae7144be5bc904dd7a50f01d09648ed/README.md) at commit `511d4f74`.
