module Hancock
  module SSO
    module OpenIdServer
      module Helpers
        def server
          @server ||= OpenID::Server::Server.new($openid_store, absolute_url('/sso'))
        end

        def url_for_user user = session_user
          absolute_url("/sso/users/#{user}")
        end

        def render_response(oidresp)
          if oidresp.needs_signing
            signed_response = server.signatory.sign(oidresp)
          end
          web_response = server.encode_response(oidresp)

          case web_response.code
          when 302
            clear_return_to!
            redirect web_response.headers['location']
          else
            web_response.body
          end
        end

        def absolute_url(suffix = nil)
          port_part = case request.scheme
                      when "http"
                        request.port == 80 ? "" : ":#{request.port}"
                      when "https"
                        request.port == 443 ? "" : ":#{request.port}"
                      end
            "#{request.scheme}://#{request.host}#{port_part}#{suffix}"
        end
      end

      def self.registered(app)
        app.helpers Helpers
        
        [:get, :post].each do |meth|
          app.send(meth, '/sso') do
            begin
              oidreq = server.decode_request(params)
            rescue OpenID::Server::ProtocolError => e
              oidreq = session[Hancock::SSO::SESSION_OID_REQ_KEY]
            end
            halt 400, "Bad request" unless oidreq

            oidresp = nil
            if oidreq.kind_of?(OpenID::Server::CheckIDRequest)
              session[Hancock::SSO::SESSION_OID_REQ_KEY] = oidreq
              session['openid_realm'] = params["openid.realm"]

              ensure_authenticated
              authorize_openid_request!

              oidreq.identity = oidreq.claimed_id = url_for_user
              oidresp = oidreq.answer(true, nil, oidreq.identity)
              sreg_data = session[SESSION_USER_INFO_KEY]
              
              oidresp.add_extension(OpenID::SReg::Response.new(sreg_data))
            else # associate
              oidresp = server.handle_request(oidreq) 
            end
            render_response(oidresp)
          end
        end
      end
    end
  end
end
