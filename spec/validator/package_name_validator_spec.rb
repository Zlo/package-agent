#!/usr/bin/env rspec

require "spec_helper"
require File.join(File.dirname(__FILE__), "../../", "validator", "package_name.rb")

module MCollective
  module Validator
    describe Package_nameValidator do
      describe "#validate" do
        it "should validate a valid package name without errors" do
          expect {
            described_class.validate("rspec")
          }.not_to raise_error

          expect {
            described_class.validate("rspec1")
          }.not_to raise_error

          expect {
            described_class.validate("rspec-package")
          }.not_to raise_error

          expect {
            described_class.validate("rspec-package-1")
          }.not_to raise_error

          expect {
            described_class.validate("rspec.package")
          }.not_to raise_error
        end
        it "should fail on a invalid package name" do
          expect {
            described_class.validate("rspec!")
          }.to raise_error
        end
      end
    end
  end
end
