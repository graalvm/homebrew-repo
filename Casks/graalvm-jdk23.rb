cask "graalvm-jdk23" do
  arch arm: "aarch64", intel: "x64"

  version "23.0.1"
  sha256 arm:   "c00a7a62ce453aa026bff65e5a18c63464f725c01e5a71771856226928ba5b0f",
         intel: "539699d8ff4979623bc7bdf8282ac6f76cd2560f47d14ec5438bada24f136f96"

  installation_dir = "graalvm-jdk-#{version}+11.1".freeze
  jvms_dir = "/Library/Java/JavaVirtualMachines".freeze
  target_dir = "#{jvms_dir}/graalvm-jdk-#{version.split(".").first}".freeze

  # download.oracle.com was verified as official when first introduced to the cask
  url "https://download.oracle.com/graalvm/23/archive/graalvm-jdk-#{version}_macos-#{arch}_bin.tar.gz"
  name "Oracle GraalVM for JDK 23"
  homepage "https://www.graalvm.org/"

  artifact installation_dir, target: target_dir

  postflight do
    # Correct symlink
    macos_dir = "#{target_dir}/Contents/MacOS"
    libjli_filename = "libjli.dylib"
    libjli_path = "#{target_dir}/Contents/Home/lib/#{libjli_filename}"
    libjli_symlink_path = "#{macos_dir}/#{libjli_filename}"
    system_command "/bin/mkdir", args: ["-p", macos_dir], sudo: true
    system_command "/bin/ln", args: ["-s", "-f", libjli_path, libjli_symlink_path], sudo: true
  end

  caveats <<~EOS
    Installing Oracle GraalVM for JDK 23 in #{jvms_dir} requires root permission.
    You may be asked to enter your password to proceed.

    To use GraalVM, you may want to change your $JAVA_HOME:
      export JAVA_HOME="#{target_dir}/Contents/Home"

    or you may want to add its `bin` directory to your $PATH:
      export PATH="#{target_dir}/Contents/Home/bin:$PATH"

    Oracle GraalVM is licensed under the GraalVM Free Terms and Conditions:
      https://www.oracle.com/downloads/licenses/graal-free-license.html

  EOS
end
