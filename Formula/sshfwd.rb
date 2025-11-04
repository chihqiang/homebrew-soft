class Sshfwd < Formula
  desc "Lightweight Go-based SSH port forwarding tool – replicates ssh -L/ssh -R core features, no system SSH dependency, cross-platform ready-to-use."
  homepage "https://github.com/chihqiang/sshfwd"
  url "https://github.com/chihqiang/sshfwd/archive/refs/tags/v0.1.0.tar.gz"
  version "0.1.0"
  sha256 "258c485ca40028f3e7d5e6b7d00aef2b6a163b3803c640ef58dd3205f5e8a1d0"
  license "Apache-2.0"
  head "https://github.com/chihqiang/sshfwd", branch: "main"

  depends_on "go@1.23" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "."
    (etc/"sshfwd").install "config.yaml"
  end

  service do
    run [opt_bin/"sshfwd", "-c", etc/"sshfwd/config.yaml"]
    keep_alive true
    error_log_path var/"log/sshfwd.log"
    log_path var/"log/sshfwd.log"
  end

  test do
    assert_predicate bin/"sshfwd", :exist?
    assert_predicate bin/"sshfwd", :executable?
  end
end
