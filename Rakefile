# -*- ruby -*-
# Rakefile: build ruby libvirt bindings
#
# Copyright (C) 2007,2010 Red Hat, Inc.
#
# Distributed under the GNU Lesser General Public License v2.1 or later.
# See COPYING for details
#
# David Lutterkort <dlutter@redhat.com>

# Rakefile for ruby-rpm -*- ruby -*-
require "bundler/gem_tasks"
require 'rake/clean'
require 'rdoc/task'
require 'rake/testtask'
require 'rubygems/package_task'
require 'rbconfig'
require 'rake/extensiontask'

PKG_NAME='ruby-libvirt'
PKG_VERSION='0.4.0'

EXT_CONF='ext/libvirt/extconf.rb'
MAKEFILE="ext/libvirt/Makefile"
LIBVIRT_MODULE="ext/libvirt/_libvirt.so"
SPEC_FILE="ruby-libvirt.spec"
LIBVIRT_SRC=Dir.glob("ext/libvirt/*.c")
LIBVIRT_SRC << MAKEFILE

#
# Additional files for clean/clobber
#

CLEAN.include [ "ext/**/*.o", LIBVIRT_MODULE,
                "ext/**/depend" ]

CLOBBER.include [ "config.save", "ext/**/mkmf.log", "ext/**/extconf.h",
                  MAKEFILE ]

#
# Build locally
#
file MAKEFILE => EXT_CONF do |t|
    Dir::chdir(File::dirname(EXT_CONF)) do
        extra = ""
        args = ARGV.grep(/^--with-libvirt-include=/)
        extra += args[0].chomp unless args.empty?
        args = ARGV.grep(/^--with-libvirt-lib=/)
        extra += " " + args[0].chomp unless args.empty?

        unless sh "ruby #{File::basename(EXT_CONF)} #{extra}"
            $stderr.puts "Failed to run extconf"
            break
        end
    end
end
file LIBVIRT_MODULE => LIBVIRT_SRC do |t|
    Dir::chdir(File::dirname(EXT_CONF)) do
        unless sh "make"
            $stderr.puts "make failed"
            break
        end
     end
end
desc "Build the native library"
task :build => LIBVIRT_MODULE

#
# Test task
#

Rake::TestTask.new(:test) do |t|
    t.test_files = [ 'tests/test_conn.rb', 'tests/test_domain.rb',
                     'tests/test_interface.rb', 'tests/test_network.rb',
                     'tests/test_nodedevice.rb', 'tests/test_nwfilter.rb',
                     'tests/test_open.rb', 'tests/test_secret.rb',
                     'tests/test_storage.rb' ]
    t.libs = [ 'lib', 'ext/libvirt' ]
end
task :test => :build

#
# Documentation tasks
#

RDOC_FILES = FileList[ "README.rdoc", "lib/libvirt.rb",
                       "ext/libvirt/_libvirt.c", "ext/libvirt/connect.c",
                       "ext/libvirt/domain.c", "ext/libvirt/interface.c",
                       "ext/libvirt/network.c", "ext/libvirt/nodedevice.c",
                       "ext/libvirt/nwfilter.c", "ext/libvirt/secret.c",
                       "ext/libvirt/storage.c", "ext/libvirt/stream.c" ]

Rake::RDocTask.new do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_dir = "doc/site/api"
    rd.rdoc_files.include(RDOC_FILES)
end

Rake::RDocTask.new(:ri) do |rd|
    rd.main = "README.rdoc"
    rd.rdoc_dir = "doc/ri"
    rd.options << "--ri-system"
    rd.rdoc_files.include(RDOC_FILES)
end

#
# Splint task
#

task :splint => [ MAKEFILE ] do |t|
    Dir::chdir(File::dirname(EXT_CONF)) do
        unless sh "splint -I" + Config::CONFIG['vendorarchdir'] + " *.c"
            $stderr.puts "Failed to run splint"
            break
        end
    end
end

#
# Package tasks
#

PKG_FILES = FileList[ "Rakefile", "COPYING", "README", "NEWS", "README.rdoc",
                      "lib/**/*.rb",
                      "ext/**/*.[ch]", "ext/**/MANIFEST", "ext/**/extconf.rb", "ext/**/*.so",
                      "tests/**/*",
                      "spec/**/*" ]

DIST_FILES = FileList[ "pkg/*.src.rpm",  "pkg/*.gem",  "pkg/*.zip",
                       "pkg/*.tgz" ]

SPEC = Gem::Specification.load('ruby-libvirt.gemspec')
Rake::ExtensionTask.new('_libvirt', SPEC)

Gem::PackageTask.new(SPEC) do |pkg|
    pkg.need_tar = true
    pkg.need_zip = true
end

desc "Build (S)RPM for #{PKG_NAME}"
task :rpm => [ :package ] do |t|
    system("sed -e 's/@VERSION@/#{PKG_VERSION}/' #{SPEC_FILE} > pkg/#{SPEC_FILE}")
    Dir::chdir("pkg") do |dir|
        dir = File::expand_path(".")
        system("rpmbuild --define '_topdir #{dir}' --define '_sourcedir #{dir}' --define '_srcrpmdir #{dir}' --define '_rpmdir #{dir}' --define '_builddir #{dir}' -ba #{SPEC_FILE} > rpmbuild.log 2>&1")
        if $? != 0
            raise "rpmbuild failed"
        end
    end
end
