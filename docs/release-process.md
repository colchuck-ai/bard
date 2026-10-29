# Release process

A release is a git tag. Everything after the tag push is automated.

## How to cut a release

1. **Pick the version** ([semver](https://semver.org/)):
   - **Major** (`v2.0.0`): a change that alters how existing users' stories come out in a way they'd notice and might not want, such as removing a workflow step, renaming a fidelity level, or changing the default voice.
   - **Minor** (`v1.1.0`): new capability, such as a new structure, a new format, or a new opt-in feature.
   - **Patch** (`v1.0.1`): fixes and wording tweaks that don't change what the skill does.
2. **Bump `metadata.version`** in `skills/bard/SKILL.md` to match, without the `v` (`version: "1.1.0"`). Commit it to `main`.
3. **Tag and push** that commit:

   ```bash
   git tag v1.1.0
   git push origin v1.1.0
   ```

For a prerelease, tag `v1.1.0-rc.1`. It publishes as a GitHub prerelease, which `install.sh` and `releases/latest` ignore.

## What the tag triggers

`.github/workflows/release.yml` runs on any `v*` tag:

1. Validates the skill with the [agent-skill-review](https://github.com/colchuck-ai/agent-skill-review) validator, pinned to a commit.
2. Fails if the tag doesn't match `metadata.version` (`scripts/check-version.sh`), so the two can't drift.
3. Builds `bard.tar.gz` (the skill without `evals/`, plus `LICENSE`) and `checksums.txt` (`scripts/build-release.sh`).
4. Publishes a GitHub release with both files and notes generated from the commits since the last tag.

If a gate fails, nothing is published. Fix it on `main`, delete the tag (`git push origin :v1.1.0` and `git tag -d v1.1.0`), and tag the fixed commit.

## How users receive it

- `install.sh` downloads `releases/latest/download/bard.tar.gz` and verifies it against `checksums.txt`. `--ref vX.Y.Z` pins a release.
- `npx skills add colchuck-ai/bard` installs from the default branch, so it picks up `main`, not the latest release. Users who want a release pin it with `npx skills add https://github.com/colchuck-ai/bard/tree/vX.Y.Z/skills/bard`.

## Checking a release before tagging

```bash
scripts/check-version.sh v1.1.0   # does SKILL.md say 1.1.0?
scripts/build-release.sh          # builds dist/bard.tar.gz and dist/checksums.txt (needs GNU tar)
```

CI (`.github/workflows/ci.yml`) runs the validator, shellcheck and the installer tests on every push to `main` and every pull request, so a commit that passes CI should pass the release gates.
