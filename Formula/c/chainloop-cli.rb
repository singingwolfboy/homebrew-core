class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://github.com/chainloop-dev/chainloop/archive/refs/tags/v0.187.0.tar.gz"
  sha256 "6e6e1e0c803375ebc76196b9e5bb7b083ff81893672b17f46beaa898fb642fcb"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e58e8fa51dcc1b38622da6b597476dd038927d7c6701a7ee80f88c7e4cbc033"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e58e8fa51dcc1b38622da6b597476dd038927d7c6701a7ee80f88c7e4cbc033"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2e58e8fa51dcc1b38622da6b597476dd038927d7c6701a7ee80f88c7e4cbc033"
    sha256 cellar: :any_skip_relocation, sonoma:        "c50c9a830bfe0bb343cde8aa68ab85736b8e567782548827f372094ba0eb01e8"
    sha256 cellar: :any_skip_relocation, ventura:       "cff05b2bdf8a1d00b836ca3c3ddee5febe633ad09743865b476377b8a1f07824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3574cf36284b0f53b11fc0ac70d3cf0ee9f4759d41eba4df981fb447abbe2a2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end
