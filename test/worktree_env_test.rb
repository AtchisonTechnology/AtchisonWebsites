#!/usr/bin/env ruby
# frozen_string_literal: true

# Dependency-free unit test for the worktree port derivation.
# Run: ruby test/worktree_env_test.rb   (or `make test`)
#
# Pure string/arithmetic logic -- touches no filesystem and boots nothing.

require_relative "../lib/worktree_env"

$failures = 0

def assert_equal(expected, actual, label)
  if expected == actual
    puts "  ok   #{label}"
  else
    $failures += 1
    puts "  FAIL #{label}: expected #{expected.inspect}, got #{actual.inspect}"
  end
end

def assert_raises(klass, label)
  yield
  $failures += 1
  puts "  FAIL #{label}: expected #{klass}, nothing raised"
rescue klass
  puts "  ok   #{label}"
end

SITES = %w[LeeAtchison TheSoftwareConductor stosa BusinessBreakthrough30 ArchitectingForScale AtchisonAcademy AtchisonAcademyCourses SoftwareArchitectureInsights].freeze

puts "main (any non-matching checkout name)"
assert_equal({ "LeeAtchison" => 3000, "TheSoftwareConductor" => 8000, "stosa" => 10_000, "BusinessBreakthrough30" => 12_000, "ArchitectingForScale" => 14_000, "AtchisonAcademy" => 16_000, "AtchisonAcademyCourses" => 18_000, "SoftwareArchitectureInsights" => 20_000 },
             WorktreeEnv.ports("AtchisonWebsites"), "base ports")
assert_equal(:main, WorktreeEnv.for_worktree("AtchisonWebsites").kind, "kind")
assert_equal(:main, WorktreeEnv.for_worktree("spec").kind, "bare 'spec' is not a worktree")
assert_equal(:main, WorktreeEnv.for_worktree("spec0010-fix").kind, "suffixed name is not a worktree")
assert_equal(:main, WorktreeEnv.for_worktree("Spec0010").kind, "capitalized name is not a worktree")

puts "spec0010"
assert_equal({ "LeeAtchison" => 3010, "TheSoftwareConductor" => 8010, "stosa" => 10_010, "BusinessBreakthrough30" => 12_010, "ArchitectingForScale" => 14_010, "AtchisonAcademy" => 16_010, "AtchisonAcademyCourses" => 18_010, "SoftwareArchitectureInsights" => 20_010 },
             WorktreeEnv.ports("spec0010"), "ports")
assert_equal(:spec, WorktreeEnv.for_worktree("spec0010").kind, "kind")
assert_equal(10, WorktreeEnv.for_worktree("spec0010").id, "id")

puts "bug0003"
assert_equal({ "LeeAtchison" => 4003, "TheSoftwareConductor" => 9003, "stosa" => 11_003, "BusinessBreakthrough30" => 13_003, "ArchitectingForScale" => 15_003, "AtchisonAcademy" => 17_003, "AtchisonAcademyCourses" => 19_003, "SoftwareArchitectureInsights" => 21_003 },
             WorktreeEnv.ports("bug0003"), "ports")
assert_equal(:bug, WorktreeEnv.for_worktree("bug0003").kind, "kind")

puts "block edges (ID 999 is the last that fits)"
assert_equal(3999, WorktreeEnv.port_for("LeeAtchison", "spec0999"), "service 0 spec top")
assert_equal(4999, WorktreeEnv.port_for("LeeAtchison", "bug0999"), "service 0 bug top")
assert_equal(8999, WorktreeEnv.port_for("TheSoftwareConductor", "spec0999"), "service 1 spec top")
assert_equal(13_999, WorktreeEnv.port_for("BusinessBreakthrough30", "bug0999"), "service 3 bug top")
assert_equal(14_999, WorktreeEnv.port_for("ArchitectingForScale", "spec0999"), "service 4 spec top")
assert_equal(15_999, WorktreeEnv.port_for("ArchitectingForScale", "bug0999"), "service 4 bug top")
assert_equal(16_999, WorktreeEnv.port_for("AtchisonAcademy", "spec0999"), "service 5 spec top")
assert_equal(17_999, WorktreeEnv.port_for("AtchisonAcademy", "bug0999"), "service 5 bug top")
assert_equal(18_999, WorktreeEnv.port_for("AtchisonAcademyCourses", "spec0999"), "service 6 spec top")
assert_equal(19_999, WorktreeEnv.port_for("AtchisonAcademyCourses", "bug0999"), "service 6 bug top")
assert_equal(20_999, WorktreeEnv.port_for("SoftwareArchitectureInsights", "spec0999"), "service 7 spec top")
assert_equal(21_999, WorktreeEnv.port_for("SoftwareArchitectureInsights", "bug0999"), "service 7 bug top")

puts "site lookup"
assert_equal(10_000, WorktreeEnv.port_for("STOSA"), "case-insensitive")
assert_raises(KeyError, "unknown site raises") { WorktreeEnv.port_for("Nope") }

puts "no collisions across every site x kind x ID 1..999, plus main"
seen = {}
collisions = []
SITES.each { |s| (seen[WorktreeEnv.port_for(s, "main")] = "main/#{s}") }
(1..999).each do |n|
  %w[spec bug].each do |kind|
    name = format("%s%04d", kind, n)
    SITES.each do |site|
      port = WorktreeEnv.port_for(site, name)
      collisions << "#{name}/#{site} collides with #{seen[port]} on #{port}" if seen.key?(port)
      seen[port] = "#{name}/#{site}"
    end
  end
end
assert_equal([], collisions, "unique ports (#{seen.size} checked)")

puts
if $failures.zero?
  puts "All checks passed."
else
  puts "#{$failures} check(s) FAILED."
  exit 1
end
