cask "graalvm-ce-java17" do
  arch arm: "aarch64", intel: "amd64"

  version "22.3.0"
  sha256 arm:   "dfc0c8998b8d00fcca87ef1c866c6e4985fd20b0beba3021f9677f9b166dfaf8",
         intel: "422cd6abecfb8b40238460c09c42c5a018cb92fab4165de9691be2e3c3d0e8d1"

  jvms_dir = "/Library/Java/JavaVirtualMachines".freeze
  target_dir = "#{jvms_dir}/#{cask}-#{version}".freeze

  # github.com/graalvm/graalvm-ce-builds was verified as official when first introduced to the cask
  url "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-#{version}/#{cask}-darwin-#{arch}-#{version}.tar.gz"
  appcast "https://github.com/oracle/graal/releases.atom"
  name "GraalVM Community Edition (Java 17)"
  homepage "https://www.graalvm.org/"

  artifact "#{cask}-#{version}", target: target_dir

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
    Installing GraalVM CE (Java 17) in #{jvms_dir} requires root permissions.
    You may be asked to enter your password to proceed.

    On macOS Catalina, you may get a warning that "the developer cannot be
    verified". This check can be disabled in the "Security & Privacy"
    preferences pane or by running the following command:
      xattr -r -d com.apple.quarantine "#{target_dir}"

    To use GraalVM CE, you may want to change your $JAVA_HOME:
      export JAVA_HOME="#{target_dir}/Contents/Home"

    or you may want to add its `bin` directory to your $PATH:
      export PATH="#{target_dir}/Contents/Home/bin:$PATH"

    GraalVM CE is licensed under the GPL 2 with Classpath exception:
      https://github.com/oracle/graal/blob/master/LICENSE

  EOS
end
