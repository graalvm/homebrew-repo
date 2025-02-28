cask 'graalvm-ce-java8@20.1' do
  version '20.1.0'
  sha256 '3b9fd8ce84c9162a188fde88907c66990db22af0ff6ae2c04430113253a9a634'

  NAME_AND_VER = cask.to_s.split('@')
  JVMS_DIR = '/Library/Java/JavaVirtualMachines'.freeze
  TARGET_DIR = "#{JVMS_DIR}/#{NAME_AND_VER.first}-v#{NAME_AND_VER.last}-#{version}".freeze

  # github.com/graalvm/graalvm-ce-builds was verified as official when first introduced to the cask
  url "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-#{version}/#{NAME_AND_VER.first}-darwin-amd64-#{version}.tar.gz"
  appcast 'https://github.com/oracle/graal/releases.atom'
  name 'GraalVM Community Edition 20.1 (Java 8)'
  homepage 'https://www.graalvm.org/'

  artifact "#{NAME_AND_VER.first}-#{version}", target: TARGET_DIR

  caveats <<~EOS
    Installing GraalVM CE #{NAME_AND_VER.last} (Java 8) in #{JVMS_DIR} requires root permissions.
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
