# homebrew-rtk

Homebrew tap for [`chelout/rtk`](https://github.com/chelout/rtk) — a personal fork of
[`rtk-ai/rtk`](https://github.com/rtk-ai/rtk) (Rust Token Killer) with extra features:

- **Smart `grep`/`rg` rewrite** — `grep -rn pattern src/` → `rtk grep pattern src/`.
- **Full-command tracking** for `rtk gain --history`.

## Install

```bash
brew tap chelout/rtk
brew install chelout/rtk/rtk
```

On **macOS arm64** this installs a prebuilt binary (no Rust required). On other
platforms it builds from source (Rust is pulled in as a build dependency).

> If you already have the upstream `rtk` from `homebrew-core`, uninstall it first
> (`brew uninstall rtk`) to avoid a link conflict, since both provide `bin/rtk`.

## Update

```bash
brew update
brew upgrade chelout/rtk/rtk
```

## Uninstall

```bash
brew uninstall chelout/rtk/rtk
brew untap chelout/rtk
```

## Releasing a new version (maintainer)

1. Tag the fork: `git tag -a vX.Y.Z-fork.N -m "…" && git push origin vX.Y.Z-fork.N`
2. Build + package the arm64 binary, attach it to a GitHub release:
   ```bash
   cargo build --release
   tar -czf rtk-aarch64-apple-darwin.tar.gz -C target/release rtk
   gh release create vX.Y.Z-fork.N rtk-aarch64-apple-darwin.tar.gz --repo chelout/rtk
   ```
3. Update `Formula/rtk.rb`: bump `version`, both `url`s, and both `sha256`s
   (prebuilt = `shasum -a 256` of the tarball; source = sha of
   `…/archive/refs/tags/vX.Y.Z-fork.N.tar.gz`).
4. Commit and push this repo.
