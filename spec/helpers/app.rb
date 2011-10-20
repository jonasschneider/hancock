module Hancock
  class TestApp < ::Hancock::SSO::App
    def landing_page_tpl
      "%h2 Hello #{session_user.inspect}!"
    end

    def unauthenticated_tpl
      <<-HAML
%fieldset
%legend You need to log in, buddy.
%form{:action => '/sso/login', :method => 'POST'}
  %label{:for => 'username'}
    Username:
    %input{:type => 'text', :name => 'username'}
    %br
  %label{:for => 'password'}
    Password:
    %input{:type => 'password', :name => 'password'}
    %br
  %input{:type => 'submit', :value => 'Login'}
  or
  %a{:href => '/sso/signup'} Signup
HAML
    end
    
    enable  :raise_errors
    disable :show_exceptions
    
    def unauthenticated!
      halt haml(unauthenticated_tpl)
    end
    
    get '/' do
      ensure_authenticated
      haml landing_page_tpl
    end

    def self.app
      @app ||= Rack::Builder.new do
        use Rack::Session::Cookie
        run TestApp
      end
    end
  end
end
