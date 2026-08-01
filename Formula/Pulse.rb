class Pulse < Formula
  desc "Fast, persistent MQTT v5 broker for Rust-powered systems"
  homepage "https://github.com/PieceOfFall/Pulse"
  version "1.3.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.4/Pulse-aarch64-apple-darwin.tar.xz"
      sha256 "270fb89e067ba6769c319fc88508e2abf64e5a46fd7c6436828742ea9dc01621"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.4/Pulse-x86_64-apple-darwin.tar.xz"
      sha256 "4358a8b274c006ab7b133393f4e3ce6aa4ce425ebd90ed9893787c9d5bbfe26d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.4/Pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "43fac78c77c20efb64dc13b8e71892125e975f5b5c727fa08530495d433262ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.4/Pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e36224f9a89cbf251a834a7f6a8c3b09c4649b91880dd6a013c7c884bf8ba9d4"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "Pulse" if OS.mac? && Hardware::CPU.arm?
    bin.install "Pulse" if OS.mac? && Hardware::CPU.intel?
    bin.install "Pulse" if OS.linux? && Hardware::CPU.arm?
    bin.install "Pulse" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
