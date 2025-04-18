#!/usr/bin/env rspec

require "spec_helper"
require File.join(File.dirname(__FILE__), "../../", "files", "mcollective", "agent", "package.rb")

module MCollective
  module Agent
    describe Package do
      let(:provider) { mock }

      before do
        agent_file = File.join(File.dirname(__FILE__), "../../",  "files", "mcollective", "agent", "package.rb")
        @agent = MCollective::Test::LocalAgentTest.new("package", :agent_file => agent_file).plugin
        described_class.stubs(:load_provider_class).returns(provider)
        provider.stubs(:new).returns(provider)
        described_class.stubs(:package_provider)
        described_class.stubs(:provider_options)
      end

      describe "#install" do
        result_set = {:status => {:ensure => "installed"},
                      :output => "installed"}

        it "should install the package" do
          provider.expects(:send).with(:install).returns(result_set)
          result = @agent.call(:install, :package => "rspec")
          result.should be_successful
          result.should have_data_items(:ensure => "installed", :output => "installed")
        end

        it "should fail if the package could not be installed" do
          provider.expects(:send).with(:install).raises("rspec_error")
          result = @agent.call(:install, :package => "rspec")
          result.should be_unknown_error
        end
      end

      describe "#update" do
        result_set = {:status => {:ensure => "installed"},
                      :output => "updated"}

        it "should update the package" do
          provider.expects(:send).with(:update).returns(result_set)
          result = @agent.call(:update, :package => "rspec")
          result.should be_successful
          result.should have_data_items(:ensure => "installed", :output => "updated")
        end

        it "should fail if the package could not be updated" do
          provider.expects(:send).with(:update).raises("rspec_error")
          result = @agent.call(:update, :package => "rspec")
          result.should be_unknown_error
        end
      end

      describe "#uninstall" do
        result_set = {:status => {:ensure => "absent"},
                      :output => "uninstalled"}

        it "should install the package" do
          provider.expects(:send).with(:uninstall).returns(result_set)
          result = @agent.call(:uninstall, :package => "rspec")
          result.should be_successful
          result.should have_data_items(:ensure => "absent", :output => "uninstalled")
        end

        it "should fail if the package could not be installed" do
          provider.expects(:send).with(:uninstall).raises("rspec_error")
          result = @agent.call(:uninstall, :package => "rspec")
          result.should be_unknown_error
        end
      end

      describe "#purge" do
        result_set = {:status => {:ensure => "purged"},
                      :output => "purged"}

        it "should install the package" do
          provider.expects(:send).with(:purge).returns(result_set)
          result = @agent.call(:purge, :package => "rspec")
          result.should be_successful
          result.should have_data_items(:ensure => "purged", :output => "purged")
        end

        it "should fail if the package could not be installed" do
          provider.expects(:send).with(:purge).raises("rspec_error")
          result = @agent.call(:purge, :package => "rspec")
          result.should be_unknown_error
        end
      end

      describe "#status" do
        result_set = {:ensure => "installed",
                      :output => ""}

        it "should install the package" do
          provider.expects(:send).with(:status).returns(result_set)
          result = @agent.call(:status, :package => "rspec")
          result.should be_successful
          result.should have_data_items(:ensure => "installed", :output => "")
        end

        it "should fail if the package could not be installed" do
          provider.expects(:send).with(:status).raises("rspec_error")
          result = @agent.call(:status, :package => "rspec")
          result.should be_unknown_error
        end
      end

      describe "#yum_clean" do
        it "should perform a yum clean" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:yum_clean).returns({:exitcode => 0, :output => "cleaned"})

          result = @agent.call(:yum_clean)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "cleaned"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:yum_clean)
          result.should be_unknown_error
        end
      end

      describe "#count" do
        it "should perform package count" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:count).returns({:exitcode => 0, :output => "pkgcount"})

          result = @agent.call(:count)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "pkgcount"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:count)
          result.should be_unknown_error
        end
      end

      describe "#md5" do
        it "should perform package list md5" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:md5).returns({:exitcode => 0, :output => "pkgmd5"})

          result = @agent.call(:md5)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "pkgmd5"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:md5)
          result.should be_unknown_error
        end
      end

      describe "#apt_update" do
        it "should perform an apt update" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:apt_update).returns({:exitcode => 0, :output => "updated"})

          result = @agent.call(:apt_update)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "updated"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:apt_update)
          result.should be_unknown_error
        end
      end

      describe "#checkupdates" do
        it "should check for updates" do
          @agent.stubs(:do_checkupdates_action)
          result = @agent.call(:checkupdates)
          result.should be_successful
        end

        it "should fail if it cannot check for updates" do
          @agent.stubs(:do_checkupdates_action).raises("rspec_error")
          result = @agent.call(:checkupdates)
          result.should be_unknown_error
        end
      end

      describe "#yum_checkupdates" do
        it "should check for updates" do
          @agent.stubs(:do_checkupdates_action)
          result = @agent.call(:yum_checkupdates)
          result.should be_successful
        end

        it "should fail if it cannot check for updates" do
          @agent.stubs(:do_checkupdates_action).raises("rspec_error")
          result = @agent.call(:yum_checkupdates)
          result.should be_unknown_error
        end
      end

      describe "#apt_checkupdates" do
        it "should check for updates" do
          @agent.stubs(:do_checkupdates_action)
          result = @agent.call(:apt_checkupdates)
          result.should be_successful
        end

        it "should fail if it cannot check for updates" do
          @agent.stubs(:do_checkupdates_action).raises("rspec_error")
          result = @agent.call(:apt_checkupdates)
          result.should be_unknown_error
        end
      end

      describe "#apt_clean" do
        it "should perform an apt-get clean" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:apt_clean).returns({:exitcode => 0, :output => "cleaned"})

          result = @agent.call(:apt_clean)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "cleaned"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:apt_clean)
          result.should be_unknown_error
        end
      end

      describe "#apt_autoremove" do
        it "should perform an apt-get autoremove" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:apt_autoremove).returns({:exitcode => 0, :output => "removed"})

          result = @agent.call(:apt_autoremove)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "removed"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:apt_autoremove)
          result.should be_unknown_error
        end
      end

      describe "#apt_upgrade" do
        it "should perform an apt-get upgrade" do
          helper = mock
          @agent.stubs(:package_helper).returns(helper)
          helper.expects(:apt_upgrade).returns({:exitcode => 0, :output => "upgraded"})

          result = @agent.call(:apt_upgrade)
          result.should be_successful
          result.should have_data_items({:exitcode => 0, :output => "upgraded"})
        end

        it "should fail if the command failed" do
          @agent.stubs(:package_helper).raises("rspec_error")
          result = @agent.call(:apt_upgrade)
          result.should be_unknown_error
        end
      end

      describe "#package_provider" do
        before do
          described_class.unstub(:package_provider)
        end
        it "should return the package provider if one is specified" do
          config = mock
          Config.stubs(:instance).returns(config)
          config.stubs(:pluginconf).returns("package.provider" => "rspec")
          described_class.package_provider.should eq "rspec"
        end

        it "returns the default package provider if one is not specified" do
          described_class.package_provider.should eq "puppet"
        end
      end

      describe "#load_provider_class" do
        before do
          module Util; module Package; end; end # rubocop:disable Lint/ConstantDefinitionInBlock
          described_class.unstub(:load_provider_class)
        end

        it "should return the provider class object" do
          Log.expects(:debug).with("Loading RspecPackage package provider")
          PluginManager.stubs(:loadclass).with("MCollective::Util::Package::Base")
          PluginManager.stubs(:loadclass).with("MCollective::Util::Package::RspecPackage")
          Util::Package.stubs(:const_get).with("RspecPackage")

          described_class.load_provider_class("rspec")
        end

        it "should log and raise if the provider cannot be loaded" do
          PluginManager.stubs(:loadclass).raises("error")
          lambda {
            described_class.load_provider_class("rspec")
          }.should raise_error "Cannot load package provider class 'RspecPackage': error"
        end
      end

      describe "#provider_options" do
        before do
          described_class.unstub(:provider_options)
        end

        it "should return a hash of provider specific options" do
          config = mock
          Config.stubs(:instance).returns(config)
          config.stubs(:pluginconf).returns({"package.rspec.k1" => "v1",
                                             "package.notrspec.k2" => "v2",
                                             "package.rspec.k3" => "v3"})
          described_class.provider_options("rspec").should eq({:k1 => "v1", :k3 => "v3"})
        end

        it "should set ensure to the version if supplied" do
          config = mock
          Config.stubs(:instance).returns(config)
          config.stubs(:pluginconf).returns({"package.rspec.k1" => "v1",
                                             "package.notrspec.k2" => "v2",
                                             "package.rspec.k3" => "v3"})
          described_class.provider_options("rspec", "1.21").should eq({:k1 => "v1", :k3 => "v3", :ensure => "1.21"})
        end

        it "should return an empty hash if no provider specific options are found" do
          config = mock
          Config.stubs(:instance).returns(config)
          config.stubs(:pluginconf).returns({})
          described_class.provider_options("rspec").should eq({})
        end
      end

      describe "#do_pkg_action" do
        it "should call the correct pkg method and modify the reply" do
          reply = {}
          provider.expects(:send, "rspec").returns({:status => {:k1 => "v1", :k2 => "v2"}})
          described_class.do_pkg_action("rspec", "rspec_action", reply)
          reply.should eq({:k1 => "v1", :k2 => "v2"})
        end

        it "should call the status action and format the reply correctly" do
          reply = {}
          provider.expects(:send, :status).returns({:k1 => "v1", :k2 => "v2"})
          described_class.do_pkg_action("rspec", :status, reply)
          reply.should eq({:k1 => "v1", :k2 => "v2"})
        end

        it "should raise an error if the :msg key is set" do
          reply = {}
          provider.expects(:send, "rspec").returns({:status => {:k1 => "v1", :k2 => "v2"}, :msg => "error"})
          lambda {
            described_class.do_pkg_action("rspec", "rspec_action", reply)
          }.should raise_error "error"
        end
      end

      describe "#do_checkupdates_action" do
        it "should call the checkupdates helper method and update the reply object" do
          package_helper = mock
          @agent.expects(:package_helper).returns(package_helper)
          package_helper.expects(:send).returns({:exitcode => 0,
                                                 :output => "rspec",
                                                 :outdated_packages => [],
                                                 :package_manager => "rspec"})
          result = @agent.call(:yum_checkupdates)
          result.should be_successful
          result.should have_data_items({:output => "rspec",
                                         :exitcode => 0,
                                         :outdated_packages => [],
                                         :package_manager => "rspec"})
        end
      end

      describe "#package_helper" do
        it "loads an return the PackageHelpers class" do
          module Util; module Package; end; end # rubocop:disable Lint/ConstantDefinitionInBlock
          PluginManager.expects(:loadclass).with("MCollective::Util::Package::PackageHelpers")
          Util::Package.expects(:const_get).with("PackageHelpers")

          @agent.send(:package_helper)
        end
      end
    end
  end
end
