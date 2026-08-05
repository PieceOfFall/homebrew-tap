class Pulse < Formula
  desc "Fast, persistent MQTT v5 broker for Rust-powered systems"
  homepage "https://github.com/PieceOfFall/Pulse"
  version "1.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.4.0/Pulse-aarch64-apple-darwin.tar.xz"
      sha256 "cc2cc635467e966e32063cc1e2a57514b5201197fcf7a47e50abbdaf1833501a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.4.0/Pulse-x86_64-apple-darwin.tar.xz"
      sha256 "a35df3612e3556c4ba48be901051e89c702f6e4ccd1fa0294f8e4695a66cc3e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.4.0/Pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "070088cad8fe74a69f91b56109f26d28ea568c285d24fbea1391d595a5c9cce1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.4.0/Pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "352ca70ff9db798694b826a2ff553a2b9a63a6e8db1027994f267d739c878b9e"
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
