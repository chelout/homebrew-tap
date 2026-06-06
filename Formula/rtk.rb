# Homebrew formula for chelout's rtk fork.
#
# macOS arm64 installs a prebuilt binary (no Rust toolchain required).
# Every other platform builds from source (Rust is pulled in as a build dep).
class Rtk < Formula
  desc "CLI proxy that minimizes LLM token consumption (chelout fork)"
  homepage "https://github.com/chelout/rtk"
  # Default (source) download — used on every platform except macOS arm64.
  url "https://github.com/chelout/rtk/archive/refs/tags/v0.42.3-fork.1.tar.gz"
  version "0.42.3-fork.1"
  sha256 "f52c425f9f3e8e22bed9d97f4c79de04a9b0bf173a75d0e02d386d118d6ddc98"
  license "Apache-2.0"

  # macOS arm64: override with the prebuilt binary release asset.
  on_macos do
    on_arm do
      url "https://github.com/chelout/rtk/releases/download/v0.42.3-fork.1/rtk-aarch64-apple-darwin.tar.gz"
      sha256 "30923111ac0d4eb7178b9dd9b802880ebc29827c24ddc69a013be6a72dfcf01e"
    end
  end

  # Rust is only needed when building from source (i.e. not macOS arm64).
  on_linux do
    on_arm do
      depends_on "rust" => :build
    end
  end
  on_intel do
    depends_on "rust" => :build
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      # Prebuilt binary path: the release tarball contains the `rtk` executable.
      bin.install "rtk"
    else
      # Source path: compile with cargo into the formula prefix.
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match "rtk", shell_output("#{bin}/rtk --version")
  end
end
