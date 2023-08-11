class JupyterJulia < Formula
  desc "Julia support for Jupyter"
  homepage "https://julialang.github.io/IJulia.jl/stable/"
  url "https://github.com/JuliaLang/IJulia.jl.git",
    tag:      "v1.24.2",
    revision: "4bd9215e18493b80b00633bcc0ac1cd1ecb53c2d"
  license "MIT"
  head "https://github.com/JuliaLang/IJulia.jl.git", branch: "master"

  depends_on "julia"
  depends_on "jupyterlab"

  resource "JSON" do
    url "https://github.com/JuliaIO/JSON.jl.git",
      tag:      "v0.21.4",
      revision: "0f0684ca79b4eef26af1485d40121e2a05559acb"
  end

  resource "Parsers" do
    url "https://github.com/JuliaData/Parsers.jl.git",
      tag:      "v2.7.2",
      revision: "d4e8a6dbb2341d5c282134c08da8989ca06f71dd"
  end

  resource "PrecompileTools" do
    url "https://github.com/JuliaLang/PrecompileTools.jl.git",
      tag:      "v1.1.2",
      revision: "11410b2970041907c2396d374ad7893d6f89a118"
  end

  resource "Preferences" do
    url "https://github.com/JuliaPackaging/Preferences.jl.git",
      tag:      "v1.4.0",
      revision: "e8082bc48a40dc27ed427e5ac9d17398d9949a14"
  end

  resource "MbedTLS" do
    url "https://github.com/JuliaLang/MbedTLS.jl.git",
      tag:      "v1.1.7",
      revision: "fc1d4320b327df033d4aa741410170d93cef544c"
  end

  resource "Conda" do
    url "https://github.com/JuliaPy/Conda.jl.git",
      tag:      "v1.9.1",
      revision: "79c5487dab36bb68ab61f8e315f61ce466cb16ef"
  end

  resource "VersionParsing" do
    url "https://github.com/JuliaInterop/VersionParsing.jl.git",
      tag:      "v1.3.0",
      revision: "027e425d5d66166698ee66a1cd111bf6f2c7ba7b"
  end

  resource "SoftGlobalScope" do
    url "https://github.com/JuliaLang/SoftGlobalScope.jl.git",
      tag:      "v1.1.0",
      revision: "68195b7ed749832c1f54ccb3dcbfce0d317c8f66"
  end

  resource "ZMQ" do
    url "https://github.com/JuliaInterop/ZMQ.jl.git",
      tag:      "v1.2.1",
      revision: "cf2b7a481346c447edea593c917c160d2e843764"
  end

  resource "ZeroMQ_jll" do
    url "https://github.com/JuliaBinaryWrappers/ZeroMQ_jll.jl.git",
      tag:      "ZeroMQ-v4.3.4+0",
      revision: "775ef7a2ac3053c0d2ecfe05e26fb87b95368c4d"
  end

  resource "JLLWrappers" do
    url "https://github.com/JuliaPackaging/JLLWrappers.jl.git",
      tag:      "v1.4.1",
      revision: "bade7d4b7af3e1c0c590bfd383a3df5ed10852f8"
  end

  resource "libsodium_jll" do
    url "https://github.com/JuliaBinaryWrappers/libsodium_jll.jl.git",
      tag:      "libsodium-v1.0.20+0",
      revision: "d7881f6bf029bae13dfddb7e18f6a975601d82b1"
  end

  # above deps are for IJulia, below deps are for LanguageServer

  resource "LanguageServer" do
    url "https://github.com/julia-vscode/LanguageServer.jl.git",
      tag:      "v4.4.0",
      revision: "8a3ae73b510aa66e302f57d5d9545a550fcb4e7a"
  end

  resource "CSTParser" do
    url "https://github.com/julia-vscode/CSTParser.jl.git",
      tag:      "v3.3.6",
      revision: "2831264262b048a83f84a7b5dc54338e7cf96ee7"
  end

  resource "Tokenize" do
    url "https://github.com/JuliaLang/Tokenize.jl.git",
      tag:      "v0.5.24",
      revision: "49b112248e846040c13f28e223493f90cc717fa5"
  end

  resource "URIs" do
    url "https://github.com/JuliaWeb/URIs.jl.git",
      tag:      "v1.5.0",
      revision: "4fd45153c0aac8094877d9a703bc51d1b9aa9c00"
  end

  resource "TestItemDetection" do
    url "https://github.com/julia-vscode/TestItemDetection.jl.git",
      # version 0.2.0 exists in the repo, but there is no Git tag...
      # tag:      "v0.2.0",
      revision: "7a3f0c2a9d5a281cfe40a6ce58f671d8ba31a514"
  end

  resource "JuliaFormatter" do
    url "https://github.com/domluna/JuliaFormatter.jl.git",
      tag:      "v1.0.35",
      revision: "7274909156e7bdd176274f1625d52ff7cfd7611a"
  end

  resource "DataStructures" do
    url "https://github.com/JuliaCollections/DataStructures.jl.git",
      tag:      "v0.18.15",
      revision: "3776698802d7ee1581a60f006abd351ea69588cf"
  end

  resource "Compat" do
    url "https://github.com/JuliaLang/Compat.jl.git",
      tag:      "v4.9.0",
      revision: "c59d116e7039db494ac61548a52651f3d8ba7b30"
  end

  resource "OrderedCollections" do
    url "https://github.com/JuliaCollections/OrderedCollections.jl.git",
      tag:      "v1.5.0",
      revision: "cf2bd5f4fc602ad949a07f0f1e9907cfc363d5f1"
  end

  resource "CommonMark" do
    url "https://github.com/MichaelHatherly/CommonMark.jl.git",
      tag:      "v0.8.12",
      revision: "d3da4078661979b65843905a4afb2c8f13414c23"
  end

  resource "Crayons" do
    url "https://github.com/KristofferC/Crayons.jl.git",
      tag:      "v4.1.1",
      revision: "417e3af6f3c28168553c662f605255b8e1fe1f14"
  end

  resource "Glob" do
    url "https://github.com/vtjnash/Glob.jl.git",
      tag:      "v1.3.1",
      revision: "19e9bb21f629ef13079172bbc1113cde91dc16e9"
  end

  resource "StaticLint" do
    url "https://github.com/julia-vscode/StaticLint.jl.git",
      tag:      "v8.1.0",
      revision: "cf3fcc388f056269937e4c4a501669ce82cbec72"
  end

  resource "SymbolServer" do
    url "https://github.com/julia-vscode/SymbolServer.jl.git",
      tag:      "v7.2.1",
      revision: "88a543f06658a513c4d76ade66959cedbd27e9ff"
  end

  resource "JSONRPC" do
    url "https://github.com/julia-vscode/JSONRPC.jl.git",
      tag:      "v1.3.6",
      revision: "aebbcbcaf57aef8bf1593f43b5388f5df598e1b1"
  end

  def install
    julia = Formula["julia"].opt_bin/"julia"
    venv = share/"venv"
    mkdir_p venv
    touch venv/".keep"
    ENV["JULIA_PKG_OFFLINE"] = "true"
    ENV["JULIA_DEPOT_PATH"] = share/"julia"
    ENV["CONDA_JL_CONDA_EXE"] = Formula["python@3.11"].opt_bin/"pip3.11"
    ENV["CONDA_JL_HOME"] = venv
    ENV["JUPYTER"] = Formula["jupyterlab"].opt_bin/"jupyter"
    ENV["JUPYTER_DATA_DIR"] = buildpath/"jupyter"

    # Julia's package manager doesn't seem to allow for installing packages
    # out of order, so this is a topologically-sorted list of dependencies
    # for installing them in order.
    pkg_order = %w[
      MbedTLS
      Preferences
      PrecompileTools
      Parsers
      JSON
      VersionParsing
      Conda
      SoftGlobalScope
      JLLWrappers
      libsodium_jll
      ZeroMQ_jll
      ZMQ
      Tokenize
      CSTParser
      URIs
      TestItemDetection
      Compat
      OrderedCollections
      DataStructures
      Crayons
      CommonMark
      Glob
      JuliaFormatter
      SymbolServer
      StaticLint
      JSONRPC
      LanguageServer
    ]
    pkg_order.each do |pkg_name|
      resource(pkg_name).stage do |context|
        system julia, "--eval", "using Pkg; Pkg.add(path=\"#{context.staging.tmpdir}\")"
      end
    end

    system julia, "--eval", "using Pkg; Pkg.add(path=\"#{buildpath}\")"
    system julia, "--eval",
      "using IJulia; IJulia.installkernel(\"Julia\", " \
      "env=Dict(\"JULIA_DEPOT_PATH\"=>\"#{HOMEBREW_PREFIX}/share/julia:\"))"
    etc.install ENV["JUPYTER_DATA_DIR"]

    inreplace share/"julia/conda/deps.jl",
      /ROOTENV = ".+"/,
      "ROOTENV = \"#{opt_share}/venv\""
  end

  test do
    # For now, we need to set this `JUPYTER_PATH`` variable so that Jupyter
    # can find the kernel files that this formula installs.
    # Once `platformdirs` supports Homebrew installations, this requirement
    # should go away.
    # https://github.com/platformdirs/platformdirs/issues/220
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    jupyter = Formula["jupyterlab"].opt_bin/"jupyter"
    assert_match "julia-1.9", shell_output("#{jupyter} kernelspec list")

    jupyter_console = Formula["jupyterlab"].opt_bin/"jupyter-console"
    (testpath/"console.exp").write <<~EOS
      spawn #{jupyter_console} --kernel julia-1.9
      expect -timeout 60 "In "
      send "exit\r"
    EOS
    assert_match "Julia: A fresh approach to technical computing", shell_output("expect -f console.exp")
  end
end
