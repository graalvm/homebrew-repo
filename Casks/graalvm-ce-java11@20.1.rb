cask 'graalvm-ce-java11@20.1' do
  version '20.1.0'
  sha256 '04efcb7bdd2e94715d0f3fddcc754594da032887e6aec94a3701bd4774d1a92e'

  NAME_AND_VER = cask.to_s.split('@')
  JVMS_DIR = '/Library/Java/JavaVirtualMachines'.freeze
  TARGET_DIR = "#{JVMS_DIR}/#{NAME_AND_VER.first}-v#{NAME_AND_VER.last}-#{version}".freeze

  # github.com/graalvm/graalvm-ce-builds was verified as official when first introduced to the cask
  url "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-#{version}/#{NAME_AND_VER.first}-darwin-amd64-#{version}.tar.gz"
  appcast 'https://github.com/oracle/graal/releases.atom'
  name 'GraalVM Community Edition 20.1 (Java 11)'
  homepage 'https://www.graalvm.org/'

  artifact "#{NAME_AND_VER.first}-#{version}", target: TARGET_DIR

  postflight do
    # Ensure GraalVM JDK 11 is listed by `/usr/libexec/java_home -V`.
    macos_dir = "#{TARGET_DIR}/Contents/MacOS"
    libjli_filename = 'libjli.dylib'
    libjli_path = "#{TARGET_DIR}/Contents/Home/lib/jli/#{libjli_filename}"
    libjli_symlink_path = "#{macos_dir}/#{libjli_filename}"
    next if File.exist?(libjli_symlink_path)

    system_command '/bin/mkdir', args: ['-p', macos_dir], sudo: true
    system_command '/bin/ln', args: ['-s', libjli_path, libjli_symlink_path], sudo: true
  end

  caveats <<~EOS
    Installing GraalVM CE #{NAME_AND_VER.last} (Java 11) in #{JVMS_DIR} requires root permissions.
    You may be asked to enter your password to proceed.

    On macOS Catalina, you may get a warning that "the developer cannot be
    verified". This check can be disabled in the "Security & Privacy"
    preferences pane or by running the following command:
      xattr -r -d com.apple.quarantine #{TARGET_DIR}

    To use GraalVM CE #{NAME_AND_VER.last}, you may want to change your `JAVA_HOME`:
      export JAVA_HOME=#{TARGET_DIR}/Contents/Home

    or you may want to add its `bin` directory to your `PATH`:
      export PATH=#{TARGET_DIR}/Contents/Home/bin:"$PATH"

    GraalVM CE is licensed under the GPL 2 with Classpath exception:
      https://github.com/oracle/graal/blob/master/LICENSE

  EOS
end
