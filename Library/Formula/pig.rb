require 'formula'

class Pig < Formula
  homepage 'http://pig.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=pig/pig-0.14.0/pig-0.14.0.tar.gz'
  sha256 '6aea66dda4791f82bad9654ec5290efc6179d333077b0ce9f07624c9c8b071a0'

  patch :DATA

  def install
    bin.install 'bin/pig'
    prefix.install ["pig-#{version}-core-h1.jar", "pig-#{version}-core-h2.jar"]
  end

  def caveats; <<-EOS.undent
    You may need to set JAVA_HOME:
      export JAVA_HOME="$(/usr/libexec/java_home)"
    EOS
  end
end

# There's something weird with Pig's launch script, it doesn't find the correct
# path. This patch finds PIG_HOME from the pig binary path's symlink.
__END__
diff -u a/bin/pig b/bin/pig
--- a/bin/pig 2011-09-30 08:55:58.000000000 +1000
+++ b/bin/pig 2011-11-28 11:18:36.000000000 +1100
@@ -77,11 +77,8 @@

 # resolve links - $0 may be a softlink
 this="${BASH_SOURCE-$0}"
-
-# convert relative path to absolute path
-bin=$(cd -P -- "$(dirname -- "$this")">/dev/null && pwd -P)
-script="$(basename -- "$this")"
-this="$bin/$script"
+here=$(dirname $this)
+this="$here"/$(readlink $this)

 # the root of the Pig installation
 export PIG_HOME=`dirname "$this"`/..
