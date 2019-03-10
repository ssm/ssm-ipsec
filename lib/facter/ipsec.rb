# These facts provide paths to the Puppet tls keys and certificates
# for the running instance of puppet.
#
# The intention is to re-use the puppet agent certificate for other
# infrastructure managed by the same puppet master. To do this, we
# need the certificate path.
#
# Note:
#
#   This is a security tradeoff.  Use with care.
#
#   - Positive: We get TLS for our transport of logs, metrics and
#     such, verified against the Puppet CA.
#
#   - Negative: We expose the puppet agent key and certificate for
#     those services.
#
#   A soon as we have a SCEP server which provides enterprise signed
#   client and server certificates on demand, this is obsolete, and
#   SCEP should be used instead.
#
#   -- Stig, 2019-02-20

require 'facter/util/puppet_settings'

Facter.add(:ipsec) do
  setcode do
    Facter::Util::PuppetSettings.with_puppet do
      {
        puppet_setting: {
          localcacert: Puppet[:localcacert],
          hostcert: Puppet[:hostcert],
          hostprivkey: Puppet[:hostprivkey],
        },
      }
    end
  end
end
