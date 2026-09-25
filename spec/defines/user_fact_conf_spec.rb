# frozen_string_literal: true

require 'spec_helper'

describe 'quadlets::user_fact_conf' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      context 'with a simple user' do
        let(:title) { 'nano' }

        it { is_expected.to compile.with_all_deps }

        it {
          is_expected.to contain_class('quadlets')
          is_expected.to contain_file('/var/lib/quadlets-users-fact.d/nano')
        }
      end
    end
  end
end
