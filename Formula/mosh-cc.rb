class MoshCc < Formula
  desc "Mosh fork with terminal rendering patches for Claude Code"
  homepage "https://github.com/rifengg/mosh-cc"
  url "https://github.com/rifengg/mosh-cc/releases/download/v1.5.0-cc.3/mosh-1.5.0-cc.3.tar.gz"
  sha256 "e3719a0bd1632a373acc9b9465708b6e7fb3c6178f606ee999a6d28a0b6811d1"
  license "GPL-3.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "protobuf"

  def install
    system "./configure", "--prefix=#{prefix}", "--program-suffix=-cc"
    inreplace "scripts/mosh.pl", /^my \$client = 'mosh-client';/, "my $client = 'mosh-client-cc';"
    inreplace "scripts/mosh.pl", /^my \$server = 'mosh-server';/, "my $server = 'mosh-server-cc';"
    system "make", "-j#{ENV.make_jobs}"
    system "make", "install"
  end

  test do
    assert_match "mosh-server", shell_output("#{bin}/mosh-server-cc --help 2>&1", 0)
    assert_predicate bin/"mosh-cc", :exist?
    assert_predicate bin/"mosh-client-cc", :exist?
  end
end
