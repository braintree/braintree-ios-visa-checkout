require 'tempfile'
require 'fileutils'
require 'shellwords'
require 'bundler'
Bundler.require
HighLine.color_scheme = HighLine::SampleColorScheme.new

task :default => %w[sanity_checks spec]

desc "Run default set of tasks"
task :spec => %w[spec:all]

desc "Run internal release process, pushing to internal GitHub Enterprise only"
task :release => %w[release:assumptions release:test sanity_checks release:check_working_directory release:bump_version release:lint_podspec release:tag]

desc "Publish code and pod to public github.com"
task :publish => %w[publish:push publish:push_pod]

SEMVER = /\d+\.\d+\.\d+(-[0-9A-Za-z.-]+)?/
PODSPEC = "BraintreeVisaCheckout.podspec"
DEMO_PLIST = "Demo/Supporting Files/Braintree-Demo-Info.plist"
VISA_CHECKOUT_PLIST = "BraintreeVisaCheckout/Info.plist"
PUBLIC_REMOTE_NAME = "origin"

class << self
  def run cmd
    say(HighLine.color("$ #{cmd}", :debug))
    File.popen(cmd) { |file|
      if block_given?
        result = ''
        result << file.gets until file.eof?
        yield result
      else
        puts file.gets until file.eof?
      end
    }
    $? == 0
  end

  def run! cmd
    run(cmd) or fail("Command failed with non-zero exit status #{$?}:\n$ #{cmd}")
  end

  def current_version
    File.read(PODSPEC)[SEMVER]
  end

  def current_version_with_sha
    %x{git describe}.strip
  end

  def current_branch
    %x{git rev-parse --abbrev-ref HEAD}.strip
  end

  def xcodebuild(scheme, command, configuration, ios_version, options={})
    default_options = {
      :build_settings => {}
    }
    ios_version_specifier = ",OS=#{ios_version}" if !ios_version.nil?
    options = default_options.merge(options)
    build_settings = options[:build_settings].map{|k,v| "#{k}='#{v}'"}.join(" ")
    return "set -o pipefail && xcodebuild -workspace 'BraintreeVisaCheckout.xcworkspace' -sdk 'iphonesimulator' -configuration '#{configuration}' -scheme '#{scheme}' -destination 'name=iPhone 12,platform=iOS Simulator#{ios_version_specifier}' #{build_settings} #{command} | xcpretty -c -r junit"
  end

end

namespace :spec do
  def run_test_scheme! scheme, ios_version = nil
    run! xcodebuild(scheme, 'test', 'Release', ios_version)
  end

  desc 'Run unit tests'
  task :unit, [:ios_version] do |t, args|
    if args[:ios_version]
      run_test_scheme! 'UnitTests', args[:ios_version]
    else
      run_test_scheme! 'UnitTests'
    end
  end

  desc 'Run Integration tests'
  task :integration do
    run_test_scheme! 'IntegrationTests'
  end

  desc 'Run UI tests'
  task :ui do
    run_test_scheme! 'UITests'
  end

  desc 'Run all spec schemes'
  task :all => %w[spec:unit spec:integration spec:ui]
end

namespace :demo do
  desc 'Verify that the demo app builds successfully'
  task :build do
    run! xcodebuild('DemoVisaCheckout', 'build', 'Release', nil)
  end
end

desc 'Run all sanity checks'
task :sanity_checks => %w[sanity_checks:pending_specs sanity_checks:build_demo]

namespace :sanity_checks do
  desc 'Check for pending tests'
  task :pending_specs do
    #TODO Update for UI Tests
  end

  desc 'Verify that all demo apps Build successfully'
  task :build_demo => 'demo:build'
end

def apple_doc_command
  %W[/usr/local/bin/appledoc
      -o appledocs
      --project-name 'BraintreeVisaCheckout'
      --project-version '#{current_version_with_sha}'
      --project-company Braintree
      --docset-bundle-id '%COMPANYID'
      --docset-bundle-name BraintreeVisaCheckout
      --docset-desc 'Braintree iOS Visa Checkout SDK (%VERSION)'
      --index-desc README.md
      --include LICENSE
      --include CHANGELOG.md
      --print-information-block-titles
      --company-id com.braintreepayments
      --prefix-merged-sections
      --no-merge-categories
      --warn-missing-company-id
      --warn-undocumented-object
      --warn-undocumented-member
      --warn-empty-description
      --warn-unknown-directive
      --warn-invalid-crossref
      --warn-missing-arg
      --no-repeat-first-par
  ].join(' ')
end

def apple_doc_files
  %x{find Braintree -name "*.h"}.split("\n").reject { |name| name =~ /mSDK/}.map { |name| name.gsub(' ', '\\ ')}.join(' ')
end

desc "Generate documentation via appledoc"
task :docs => 'docs:generate'

namespace :appledoc do
  task :check do
    unless File.exists?('/usr/local/bin/appledoc')
      puts "appledoc not found at /usr/local/bin/appledoc: Install via homebrew and try again: `brew install --HEAD appledoc`"
      exit 1
    end
  end
end

namespace :docs do
  desc "Generate apple docs as html"
  task :generate => 'appledoc:check' do
    command = apple_doc_command << " --no-create-docset --keep-intermediate-files --create-html #{apple_doc_files}"
    run(command)
    puts "Generated HTML documentationa at appledocs/html"
  end

  desc "Check that documentation can be built from the source code via appledoc successfully."
  task :check => 'appledoc:check' do
    command = apple_doc_command << " --no-create-html --verbose 5 #{apple_doc_files}"
    exitstatus = run(command)
    if exitstatus == 0
      puts "appledoc generation completed successfully!"
    elsif exitstatus == 1
      puts "appledoc generation produced warnings"
    elsif exitstatus == 2
      puts "! appledoc generation encountered an error"
      exit(exitstatus)
    else
      puts "!! appledoc generation failed with a fatal error"
    end
    exit(exitstatus)
  end

  desc "Generate & install a docset into Xcode from the current sources"
  task :install => 'appledoc:check' do
    command = apple_doc_command << " --install-docset #{apple_doc_files}"
    run(command)
  end
end


namespace :release do
  desc "Print out pre-release checklist"
  task :assumptions do
    say "Release Assumptions"
    say "* [ ] You have pulled the latest public code from github.com."
    say "* [ ] You are on the branch and commit you want to release."
    say "* [ ] You have already merged hotfixes and pulled changes."
    say "* [ ] You have already reviewed the diff between the current release and the last tag, noting breaking changes in the semver and CHANGELOG."
    say "* [ ] Tests are passing, manual verifications complete."
    say "* [ ] iOS Simulator has hardware keyboard disabled"

    abort(1) unless ask "Ready to release? "
  end

  desc "Check that working directory is clean"
  task :check_working_directory do
    run! "echo 'Checking for uncommitted changes' && git diff --exit-code"
  end

  desc "Bump version in Podspec"
  task :bump_version do
    say "Current version in Podspec: #{current_version}"
    n = 10
    say "Previous #{n} versions in Git:"
    run "git tag -l | tail -n #{n}"
    version = ask("What version are you releasing?") { |q| q.validate = /\A#{SEMVER}\Z/ }

    podspec = File.read(PODSPEC)
    podspec.gsub!(/(s\.version\s*=\s*)"#{SEMVER}"/, "\\1\"#{version}\"")
    File.open(PODSPEC, "w") { |f| f.puts podspec }

    [DEMO_PLIST, VISA_CHECKOUT_PLIST].each do |plist|
      run! "plutil -replace CFBundleVersion -string #{current_version} -- '#{plist}'"
      run! "plutil -replace CFBundleShortVersionString -string #{current_version} -- '#{plist}'"
    end
    run "git commit -m 'Bump pod version to #{version}' -- #{PODSPEC} Podfile.lock '#{DEMO_PLIST}' '#{VISA_CHECKOUT_PLIST}'"
  end

  desc  "Test."
  task :test => 'spec:all'

  desc  "Lint podspec."
  task :lint_podspec do
    run! "pod lib lint --allow-warnings --skip-import-validation"
  end

  desc  "Tag."
  task :tag do
    run! "git tag #{current_version} -a -m 'Release #{current_version}'"
  end

end

namespace :publish do

  desc  "Push code and tag to github.com"
  task :push do
    run! "git push #{PUBLIC_REMOTE_NAME} HEAD #{current_version}"
  end

  desc  "Pod push."
  task :push_pod do
    run! "pod trunk push --allow-warnings --skip-import-validation BraintreeVisaCheckout.podspec"
  end

end

namespace :gen do
  task :strings do
    ["Drop-In", "UI"].each do |subspec|
      run! "genstrings -o Braintree/#{subspec}/Localization/en.lproj Braintree/#{subspec}/**/*.m && " +
           "iconv -f utf-16 -t utf-8 Braintree/#{subspec}/Localization/en.lproj/Localizable.strings > Braintree/#{subspec}/Localization/en.lproj/#{subspec}.strings && " +
           "rm -f Braintree/#{subspec}/Localization/en.lproj/Localizable.strings"
    end
  end
end

