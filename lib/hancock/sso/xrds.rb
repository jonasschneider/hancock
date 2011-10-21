module Hancock
  module SSO
    module XRDSServer
      def self.registered(app)
        app.helpers do
          def xrds_path(request = request)
            absolute_url("/sso/xrds")
          end
          
          def add_xrds_header!
            headers 'X-XRDS-Location' => xrds_path
          end
        end
      
        app.before do
          add_xrds_header!
        end
        
        app.get "/sso/users/:user" do |user|
          headers 'X-XRDS-Location' => absolute_url("/sso/users/#{user}/xrds")
          "This is the user page for #{user}. XRDS info is attached."
        end
        
        app.get '/sso/xrds' do
        <<-XRDSEND
<?xml version="1.0" encoding="UTF-8"?>
<xrds:XRDS
    xmlns:xrds="xri://$xrds"
    xmlns:ux="http://specs.openid.net/extensions/ux/1.0"
    xmlns="xri://$xrd*($v*2.0)">
  <XRD>

    <Service priority="0">
      <Type>http://specs.openid.net/auth/2.0/server</Type>
      <Type>http://openid.net/sreg/1.0</Type>
      <URI priority="0">http://#{request.host_with_port}/sso</URI>
    </Service>

    <Service>
      <Type>http://specs.openid.net/extensions/ux/1.0/friendlyname</Type>
      <ux:friendlyname>#{options.hancock_server_name}</ux:friendlyname>
    </Service>
  </XRD>
</xrds:XRDS>
XRDSEND
      end

      app.get '/sso/users/:user/xrds' do
        <<-XRDSEND
<?xml version="1.0" encoding="UTF-8"?>
<xrds:XRDS
    xmlns:xrds="xri://$xrds"
    xmlns:openid="http://openid.net/xmlns/1.0"
    xmlns="xri://$xrd*($v*2.0)">
  <XRD version="2.0">
    <Service priority="0">
      <Type>http://specs.openid.net/auth/2.0/signon</Type>
        <Type>http://openid.net/sreg/1.0</Type>
        <Type>http://openid.net/extensions/sreg/1.1</Type>
        <Type>http://schemas.openid.net/pape/policies/2007/06/phishing-resistant</Type>
        <Type>http://openid.net/srv/ax/1.0</Type>
      <URI>#{absolute_url('/sso')}</URI>
      <LocalID>#{url_for_user(params['user'])}</LocalID>
    </Service>
    <Service priority="1">
      <Type>http://openid.net/signon/1.1</Type>
        <Type>http://openid.net/sreg/1.0</Type>
        <Type>http://openid.net/extensions/sreg/1.1</Type>
        <Type>http://schemas.openid.net/pape/policies/2007/06/phishing-resistant</Type>
        <Type>http://openid.net/srv/ax/1.0</Type>
      <URI>#{absolute_url('/sso')}</URI>
      <openid:Delegate>#{url_for_user(params['user'])}</openid:Delegate>
    </Service>
    <Service priority="2">
      <Type>http://openid.net/signon/1.0</Type>
        <Type>http://openid.net/sreg/1.0</Type>
        <Type>http://openid.net/extensions/sreg/1.1</Type>
        <Type>http://schemas.openid.net/pape/policies/2007/06/phishing-resistant</Type>
        <Type>http://openid.net/srv/ax/1.0</Type>
      <URI>#{absolute_url('/sso')}</URI>
      <openid:Delegate>#{url_for_user(params['user'])}</openid:Delegate>
    </Service>
  </XRD>
</xrds:XRDS>
XRDSEND
        end
      end  
    end
  end
end
