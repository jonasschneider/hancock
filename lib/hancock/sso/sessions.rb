module Hancock
  module SSO
    module Sessions
      module Helpers
        def session_user
          session[Hancock::SSO::SESSION_USER_KEY]
        end

        def return_to
          session['return_to'] || '/'
        end

        def ensure_authenticated
          unless session_user
            session['return_to'] = request.url
            unauthenticated! 
          end
        end
      end

      def self.registered(app)
        app.helpers Helpers

        app.get '/sso/login' do
          unauthenticated!
        end

        app.post '/sso/login' do
          if settings.authentication_delegate.authenticated?(params['username'], params['password'])
            session[Hancock::SSO::SESSION_USER_KEY] = params['username']
            session[Hancock::SSO::SESSION_USER_INFO_KEY] = settings.authentication_delegate.info_for(params['username']) || {}
            redirect return_to
          else
            params['failed_auth'] = true
            unauthenticated!
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
