class Pytorch < Formula
  include Language::Python::Virtualenv

  desc "Python module for libtorch"
  homepage "https://pytorch.org/"
  url "https://github.com/pytorch/pytorch.git",
      tag:      "v1.12.1",
      revision: "664058fa83f1d8eede5d66418abff6e20bd76ca8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "eigen"
  depends_on "libtorch"
  depends_on "libuv"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "protobuf"
  depends_on "pybind11"
  depends_on "python@3.10"

  on_macos do
    depends_on "libomp"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  def install
    libtorch = Formula["libtorch"]
    venv = virtualenv_create(libexec, Formula["python@3.10"].opt_bin/"python3")
    venv.pip_install resources

    args = %W[
      -GNinja
      -DCMAKE_CXX_COMPILER=#{ENV.cxx}
      -DCMAKE_C_COMPILER=#{ENV.cc}
      -DBUILD_CUSTOM_PROTOBUF=OFF
      -DBUILD_PYTHON=ON
      -DPYTHON_EXECUTABLE=#{libexec}/bin/python
      -DTORCH_INSTALL_PREFIX=#{libtorch.prefix}
      -DBLAS=OpenBLAS
      -DUSE_CUDA=OFF
      -DUSE_METAL=OFF
      -DUSE_MKLDNN=OFF
      -DUSE_NNPACK=OFF
      -DUSE_OPENMP=ON
      -DUSE_DISTRIBUTED=ON
      -DUSE_SYSTEM_EIGEN_INSTALL=ON
      -DUSE_SYSTEM_PYBIND11=ON
    ]
    # Remove when https://github.com/pytorch/pytorch/issues/67974 is addressed
    args << "-DUSE_SYSTEM_BIND11=ON"

    ENV["LDFLAGS"] = "-L#{buildpath}/build/lib"
    ENV["TORCH_INSTALL_PREFIX"] = libtorch.prefix

    # Update references to shared libraries
    inreplace "torch/__init__.py" do |s|
      s.sub!(/here = os.path.abspath\(__file__\)/, "here = \"#{libtorch.prefix}/lib\"")
      s.sub!(/get_file_path\('torch', 'bin', 'torch_shm_manager'\)/, "\"#{bin}/torch_shm_manager\"")
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, *args

      # Avoid references to Homebrew shims
      inreplace "caffe2/core/macros.h", Superenv.shims_path/ENV.cxx, ENV.cxx

      venv.pip_install_and_link buildpath
    end

    # Remove the things that `libtorch` already has installed
    Dir.foreach(libtorch.include) do |f|
      next if [".", ".."].include?(f)

      rm_rf include/f
    end
    Dir.foreach(libtorch.lib) do |f|
      next if [".", ".."].include?(f)

      rm_rf lib/f
    end
    Dir.foreach(libtorch.share) do |f|
      next if [".", ".."].include?(f)

      rm_rf share/f
    end
  end

  test do
    python = Formula["python@3.10"]
    system python.opt_libexec/"bin/python", "-c", <<~EOS
      import torch
      x = torch.rand(5, 3)
      print(x)
    EOS
  end
end
