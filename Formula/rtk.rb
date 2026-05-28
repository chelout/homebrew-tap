# Homebrew formula for chelout's rtk fork.
#
# macOS arm64 installs a prebuilt binary (no Rust toolchain required).
# Other platforms build from source (requires Rust as a build dependency).
class Rtk < Formula
  desc "CLI proxy that minimizes LLM token consumption (chelout fork)"
  homepage "https://github.com/chelout/rtk"
  version "0.42.0-fork.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/chelout/rtk/releases/download/v0.42.0-fork.1/rtk-aarch64-apple-darwin.tar.gz"
      sha256 "25b0c31b669919d211322dacfe0b493f001fbefca860d0af4ff2e8b6f20248fd"
    end
    on_intel do
      url "https://github.com/chelout/rtk/archive/refs/tags/v0.42.0-fork.1.tar.gz"
      sha256 "d88be1d7a00849489130bea75ebc895bc82c7a228d8a463b53466aa780118169"
      depends_on "rust" => :build
    end
  end

  on_linux do
    url "https://github.com/chelout/rtk/archive/refs/tags/v0.42.0-fork.1.tar.gz"
    sha256 "d88be1d7a00849489130bea75ebc895bc82c7a228d8a463b53466aa780118169"
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
