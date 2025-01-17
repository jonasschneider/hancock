require File.dirname(__FILE__) + '/sso/sessions'
require File.dirname(__FILE__) + '/sso/openid'
require File.dirname(__FILE__) + '/sso/xrds'

require "openid/store/memory"

$openid_store = OpenID::Store::Memory.new

module Hancock
  module SSO
    SESSION_USER_KEY      = 'hancock.user.id'
    SESSION_USER_INFO_KEY = 'hancock.user.info'
    SESSION_OID_REQ_KEY   = 'hancock.oidreq.id'
    SESSION_RETURN_TO_KEY = 'hancock.return_to'

    class App < Sinatra::Base
      set :hancock_server_name, 'Hancock Single Sign On'
      set :authentication_delegate, Hancock::User
      
      def unauthenticated!
        halt 403, "Unauthenticated"
      end
      
      def authorize_openid_request!
        # halt on unauthorized requests here
      end

      register ::Hancock::SSO::Sessions
      register ::Hancock::SSO::OpenIdServer
      register ::Hancock::SSO::XRDSServer
    end
  end
end
