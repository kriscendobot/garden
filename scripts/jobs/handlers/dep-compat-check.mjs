#!/usr/bin/env node
// dep-compat-check.mjs -- pure declaration-level compatibility checker.
//
// Reads { packageName, target, manifests } on stdin. `target` is the npm
// registry manifest for the proposed version; `manifests` are project
// package.json documents at the PR head. Prints one machine-shaped TSV proof of
// incompatibility, or nothing when the declarations do not prove one.

import { createRequire } from 'node:module';

const npmRoot = process.env.GARDEN_NPM_ROOT;
if (!npmRoot) {
  throw Error('GARDEN_NPM_ROOT is required');
}
const npmRequire = createRequire(`${npmRoot}/npm/package.json`);
const semver = npmRequire('semver');

let source = '';
for await (const chunk of process.stdin) source += chunk;
const input = JSON.parse(source);
const { packageName, target, manifests } = input;

const clean = value =>
  typeof value === 'string' && /^[A-Za-z0-9@/._+*<>=~^| -]+$/.test(value);
const cleanPath = value =>
  typeof value === 'string' && /^[A-Za-z0-9._/-]+$/.test(value);
const validRange = value => clean(value) && semver.validRange(value) !== null;
const declarations = manifest => ({
  ...manifest.dependencies,
  ...manifest.devDependencies,
  ...manifest.optionalDependencies,
  ...manifest.peerDependencies,
});

const peerDependencies = target?.peerDependencies;
if (peerDependencies && typeof peerDependencies === 'object') {
  for (const [peer, required] of Object.entries(peerDependencies).sort()) {
    if (!clean(peer) || !validRange(required)) continue;
    for (const item of manifests) {
      const declared = declarations(item.manifest)[peer];
      if (!validRange(declared) || !cleanPath(item.path)) continue;
      if (!semver.intersects(declared, required, { includePrerelease: true })) {
        process.stdout.write(
          ['incompatible', 'peer', peer, declared, required, item.path].join('\t') + '\n',
        );
        process.exit(0);
      }
    }
  }
}

const targetNode = target?.engines?.node;
if (validRange(targetNode)) {
  for (const item of manifests) {
    if (item.path !== 'package.json' && declarations(item.manifest)[packageName] === undefined) {
      continue;
    }
    const projectNode = item.manifest?.engines?.node;
    if (!validRange(projectNode) || !cleanPath(item.path)) continue;
    const floor = semver.minVersion(projectNode);
    // A project declaring support from this floor promises that the dependency
    // graph works there. Raising that floor is incompatible even if the two
    // unbounded ranges overlap at some later Node release.
    if (floor && !semver.satisfies(floor, targetNode, { includePrerelease: true })) {
      process.stdout.write(
        ['incompatible', 'node', floor.version, projectNode, targetNode, item.path].join('\t') + '\n',
      );
      process.exit(0);
    }
  }
}
