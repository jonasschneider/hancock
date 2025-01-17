require File.expand_path(File.dirname(__FILE__)+'/../spec_helper')

describe "visiting /sso/logout" do
  describe "when authenticated" do
    it "clears the session and redirects to /" do
      Hancock::User.authentication_class = MyUserClass
      
      login('atmos', 'hancock')

      get '/sso/logout'
      last_response.status.should eql(302)
      last_response.headers['Location'].should eql('http://example.org/?logged_out=true')
    end
    
    it "returns to return_to when the param is set" do
      Hancock::User.authentication_class = MyUserClass
      
      login('atmos', 'hancock')

      get '/sso/logout?return_to=http://google.com?asdf=ohai'
      last_response.status.should eql(302)
      last_response.headers['Location'].should eql('http://google.com?asdf=ohai')
    end
  end
  
  describe "when unauthenticated" do
    it "redirects to /" do
      get '/sso/logout'
      last_response.status.should eql(302)
      last_response.headers['Location'].should eql('http://example.org/?logged_out=true')
    end
  end
end
