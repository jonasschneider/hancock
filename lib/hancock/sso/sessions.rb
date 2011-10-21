module Hancock
  module SSO
    module Sessions
      module Helpers
        def session_user
          session[Hancock::SSO::SESSION_USER_KEY]
        end
        
        def session_user_info
          session[Hancock::SSO::SESSION_USER_INFO_KEY]
        end
        
        def return_to
          session['return_to'] || '/'
        end

        def ensure_authenticated
          unless session_user
            session['return_to'] = request.url
            @keep_return_url = true
            unauthenticated! 
          end
        end
      end

      def self.registered(app)
        app.helpers Helpers

        app.get '/sso/login' do
          unauthenticated!
        end
        
        app.after do
          session.delete 'return_to' unless @keep_return_url
        end

        app.post '/sso/login' do
          if info = settings.authentication_delegate.authenticated?(params['username'], params['password'])
            session[Hancock::SSO::SESSION_USER_KEY] = params['username']
            session[Hancock::SSO::SESSION_USER_INFO_KEY] = (info == true) ? {} : info
            redirect return_to
          else
            params['failed_auth'] = true
            @keep_return_url = true
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
