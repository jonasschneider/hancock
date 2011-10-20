module Hancock
  module SSO
    module Sessions
      module Helpers
        def session_user
          session[Hancock::SSO::SESSION_USER_KEY]
        end

        def return_to
          (session[Hancock::SSO::SESSION_OID_REQ_KEY] &&
          session[Hancock::SSO::SESSION_OID_REQ_KEY].return_to) || '/'
        end

        def ensure_authenticated
          unauthenticated! unless session_user
        end
      end

      def self.registered(app)
        app.helpers Helpers

        app.get '/sso/login' do
          ensure_authenticated
        end

        app.post '/sso/login' do
          if ::Hancock::User.authenticated?(params['username'], params['password'])
            session[Hancock::SSO::SESSION_USER_KEY] = params['username']
            redirect return_to
          else
            ensure_authenticated
          end
        end

        app.get '/sso/logout' do
          session.clear
          redirect "/"
        end
      end
    end
  end
end
