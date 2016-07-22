require 'spec_helper'

describe 'artifactory_ha' do
  let(:params) { {:license_key => 'my_license_key'} }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "artifactory_ha class with minimum configs" do
          it { is_expected.to compile.with_all_deps }

          #it { is_expected.to contain_class('artifactory_pro::params') }
          it { is_expected.to contain_class('artifactory_pro').that_comes_before('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory_ha::config').that_comes_before('artifactory_ha::post_config') }
          it { is_expected.to contain_class('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory_ha::post_config') }
          it { is_expected.to contain_class('artifactory::service').that_subscribes_to('artifactory_ha::config') }
          it { is_expected.to contain_class('artifactory::service').that_subscribes_to('artifactory_ha::post_config') }

          it { is_expected.to contain_service('artifactory') }
          it { is_expected.to contain_package('jfrog-artifactory-pro').with_ensure('present') }
        end
      end
    end
  end
end
