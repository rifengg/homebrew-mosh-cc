class MoshCc < Formula
  desc "Mosh fork with terminal rendering patches for Claude Code"
  homepage "https://github.com/rifengg/mosh-cc"
  url "https://github.com/rifengg/mosh-cc/releases/download/v1.5.0-cc.2/mosh-1.5.0-cc.2.tar.gz"
  sha256 "5ad61bd1662b7582ef24fd79270d682d5b6f0e2732634d18d42d0fe9af6d5654"
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
