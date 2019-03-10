require 'spec_helper'

peers = [
  { 'name'    => 'this.example.net',
    'address' => '2001:db8:1::1',
    'family'  => 'inet6' },
  { 'name'    => 'remote1.example.com',
    'address' => '2001:db8:2::1',
    'family'  => 'inet6' },
  { 'name'    => 'remote2.example.com',
    'address' => '2001:db8:2::2',
    'family'  => 'inet6' },
  { 'name'    => 'remote3.example.com',
    'address' => '2001:db8:2::3',
    'family'  => 'inet6' },
  { 'name'    => 'this.example.net',
    'address' => '192.0.2.1',
    'family'  => 'inet' },
  { 'name'    => 'remote1.example.com',
    'address' => '192.0.2.2',
    'family'  => 'inet' },
  { 'name'    => 'remote2.example.com',
    'address' => '192.0.2.3',
    'family'  => 'inet' },
  { 'name'    => 'remote3.example.com',
    'address' => '192.0.2.4',
    'family'  => 'inet' },
]

describe 'ipsec' do
  on_supported_os.each do |os, facts|
    context "on #{os} #{facts[:osfamily]}" do
      let(:facts) { facts }
      let(:node) { 'this.example.net' }

      context 'with default parameters' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('ipsec') }

        it { is_expected.to contain_file('/etc/ipsec.d/oe-certificate.conf') }
        it {
          is_expected.to contain_file('/etc/ipsec.d/ipsec.secrets')
            .with_content(%r{^:\sRSA\sthis\.example\.net$})
        }
      end

      context 'with peers' do
        let(:params) do
          { 'peers' => peers }
        end

        it { is_expected.to compile }

        # Inspect the first two
        it do
          is_expected.to contain_file('/etc/ipsec.d/inet6-remote1.example.com.conf')
            .with_content(%r{conn inet6::this\.example\.net::remote1\.example\.com})
            .with_content(%r{left=2001:db8:1::1})
            .with_content(%r{right=2001:db8:2::1})
        end
        it do
          is_expected.to contain_file('/etc/ipsec.d/inet-remote1.example.com.conf')
            .with_content(%r{conn inet::this\.example\.net::remote1\.example\.com})
            .with_content(%r{left=192.0.2.1})
            .with_content(%r{right=192.0.2.2})
        end
        # The other files should be present
        [
          '/etc/ipsec.d/inet6-remote2.example.com.conf',
          '/etc/ipsec.d/inet6-remote3.example.com.conf',
          '/etc/ipsec.d/inet-remote2.example.com.conf',
          '/etc/ipsec.d/inet-remote3.example.com.conf',
        ].each do |c|
          it { is_expected.to contain_file(c) }
        end
      end

      context 'with policies' do
        let(:params) do
          {
            'policies' => {
              'clear'   => ['192.0.2.1/25'],
              'private' => ['192.0.2.128/26', '192.0.2.192/26'],
            },
          }
        end

        case facts[:osfamily]
        when 'Debian'
          it { is_expected.to compile.and_raise_error(%r{opportunistic}) }
        when 'RedHat'
          it { is_expected.to compile }

          it do
            is_expected.to contain_file('/etc/ipsec.d/policies')
              .with_ensure('directory')
          end
          it do
            is_expected.to contain_file('/etc/ipsec.d/policies/clear')
              .with_content(%r{192.0.2.1/25})
          end
          it {
            is_expected.to contain_file('/etc/ipsec.d/policies/private')
              .with_content(%r{192.0.2.128/26})
              .with_content(%r{192.0.2.192/26})
          }
          it {
            is_expected.not_to contain_file('/etc/ipsec.d/policies/clear-or-private')
          }
        end
      end
    end
  end
end
