class Pulse < Formula
  desc "The Pulse application"
  homepage "https://github.com/PieceOfFall/Pulse"
  version "1.3.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.2/Pulse-aarch64-apple-darwin.tar.xz"
      sha256 "0516d7774f1c2b3d0a2fb54a4389d40039ee2f442ec9ba7a7e112ee881b7f32c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.2/Pulse-x86_64-apple-darwin.tar.xz"
      sha256 "9990a69e46a519156e75a641bd693921b5757eb7acee433bd956c95023f3cef8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.2/Pulse-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f3baddb44b599610df32f07cdc1eba479191c06c5e7cb225913fd847acc12b19"
    end
    if Hardware::CPU.intel?
      url "https://github.com/PieceOfFall/Pulse/releases/download/1.3.2/Pulse-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa7d014463f03a8e4413aa48e1e6e4ba408d815aee43e1c284a50409fdd28ea8"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin": {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin": {},
    "x86_64-pc-windows-gnu": {},
    "x86_64-unknown-linux-gnu": {}
  }

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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "Pulse"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "Pulse"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "Pulse"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "Pulse"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
